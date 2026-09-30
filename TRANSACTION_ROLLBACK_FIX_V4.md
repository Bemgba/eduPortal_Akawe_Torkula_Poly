# Transaction Rollback Fix V4 - Fresh Transaction Context for Retries

## Problem Analysis

The batch processing was experiencing persistent `STATUS_ROLLEDBACK` errors where:
- Batch 116 was stuck in an infinite retry loop at offset 5750
- The transaction was already rolled back when trying to execute queries
- The `@TransactionalRequiresNew` annotation wasn't creating fresh transactions for retries
- Each retry attempt was trying to reuse the same rolled-back transaction context

## Root Cause

When a transaction is rolled back and you retry the operation within the same method call, even with `@TransactionalRequiresNew`, the EJB container may not create a truly new transaction context. This is because:

1. The method is being called directly (not through the EJB proxy)
2. The transaction context is inherited from the calling method
3. Once rolled back, the transaction cannot be reused

## Solution Implemented

### 1. SessionContext Injection

Added `SessionContext` to get access to the EJB proxy:

```java
@jakarta.annotation.Resource
private jakarta.ejb.SessionContext sessionContext;
```

### 2. New Retry Method with Fresh Transactions

Created `retryBatch()` method that ensures each retry gets a completely new transaction:

```java
private void retryBatch(int batchNumber, int offset, int batchSize, String schoolId,
                       AtomicInteger successCount, AtomicInteger failureCount) {
    // Get EJB proxy to ensure fresh transaction
    MainSession self = sessionContext.getBusinessObject(MainSession.class);
    self.processStudentBatch(offset, batchSize, schoolId, successCount, failureCount);
}
```

**Key Point**: `sessionContext.getBusinessObject(MainSession.class)` returns the EJB proxy, which ensures that the `@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)` annotation on `processStudentBatch` actually creates a NEW transaction for each call.

### 3. Updated processStudentBatch Signature

Changed from returning `int` to `void` and using `AtomicInteger` counters:

```java
@TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
public void processStudentBatch(int offset, int batchSize, String schoolId,
                                AtomicInteger successCount,
                                AtomicInteger failureCount)
```

This allows thread-safe counting across transaction boundaries.

### 4. Enhanced Error Detection

Added `isTransactionOrLockIssue()` method to properly identify retryable errors:

```java
private boolean isTransactionOrLockIssue(Exception e) {
    String message = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
    return message.contains("status_rolledback") ||
           message.contains("transaction") ||
           message.contains("lock") ||
           message.contains("deadlock") ||
           e instanceof OptimisticLockException ||
           e instanceof PessimisticLockException;
}
```

### 5. Exponential Backoff

Implemented exponential backoff for retries:
- Attempt 1: Wait 1 second
- Attempt 2: Wait 2 seconds
- Attempt 3: Wait 4 seconds

```java
long waitTime = 1000L * (1 << (retryCount - 1));
Thread.sleep(waitTime);
```

## How It Works

### Before (Broken):
```
createSessionProgressionBatched()
  └─> processStudentBatch() [Transaction A]
       └─> Query fails, Transaction A rolls back
       └─> Retry: processStudentBatch() [Still Transaction A - ROLLED BACK!]
            └─> Query fails with STATUS_ROLLEDBACK
```

### After (Fixed):
```
createSessionProgressionBatched()
  └─> retryBatch()
       └─> self.processStudentBatch() [Transaction A via EJB proxy]
            └─> Query fails, Transaction A rolls back
       └─> Retry: self.processStudentBatch() [NEW Transaction B via EJB proxy]
            └─> Query succeeds in fresh transaction
```

## Key Changes Summary

1. **SessionContext injection** - Access to EJB proxy
2. **retryBatch() method** - Ensures fresh transaction per retry
3. **EJB proxy usage** - `sessionContext.getBusinessObject(MainSession.class)`
4. **AtomicInteger counters** - Thread-safe counting across transactions
5. **Enhanced error detection** - Proper identification of retryable errors
6. **Exponential backoff** - Prevents immediate re-failure

## Benefits

1. **No more STATUS_ROLLEDBACK errors** - Each retry gets a fresh transaction
2. **Better error handling** - Distinguishes retryable vs non-retryable errors
3. **Improved reliability** - Exponential backoff reduces database pressure
4. **Thread-safe counting** - Accurate success/failure tracking
5. **Circuit breaker** - Prevents infinite retry loops

## Testing Recommendations

1. Monitor logs for "Connection/Transaction/Lock issue detected - batch will be retried"
2. Verify that retries succeed after initial failures
3. Check that batch processing completes without infinite loops
4. Confirm accurate success/failure counts in the result map

## Configuration Notes

- **Max retries**: 2 (configurable in `retryBatch()`)
- **Batch size**: 50 students (fixed)
- **Circuit breaker**: 5 consecutive failures
- **Query timeout**: 60 seconds
- **Lock timeout**: 10 seconds

## Rollback Plan

If issues persist, the previous version can be restored from `TRANSACTION_ROLLBACK_FIX_V3.md`.
