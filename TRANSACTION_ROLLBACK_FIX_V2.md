# Transaction Rollback Fix V2 - STATUS_ROLLEDBACK at Batch 34

## New Problem
After fixing the collection fetch issue, a new error appeared:
```
Batch 34 (offset 86800) failed: STATUS_ROLLEDBACK
LockAcquisitionException: Transaction cannot proceed
```

## Root Cause Analysis

### The Issue
1. **Nested Transactions**: `updateStudentProgression2()` was calling `updateStudent()` and `newEntry()` which have `@Transactional` annotations
2. **Transaction Conflict**: When called within `processStudentBatch()` which uses `@Transactional(REQUIRES_NEW)`, this created nested transactions
3. **Rollback Propagation**: When an inner transaction failed, it marked the outer `REQUIRES_NEW` transaction for rollback
4. **Cascading Failure**: Once a transaction is marked `STATUS_ROLLEDBACK`, all subsequent operations in that transaction fail

### Why It Failed at Batch 34
- Batches 1-33 processed successfully (86,600 students)
- Batch 34 encountered a student record that caused an error
- The error in `updateStudent()` or `newEntry()` marked the transaction for rollback
- The code tried to continue processing, but the transaction was already dead

## The Fix

### 1. Fixed `updateStudentProgression2()`

**Changed from**: No transaction annotation (implicit transaction)
**Changed to**: `@Transactional(TxType.MANDATORY)` - must run within existing transaction

**Key Changes**:
```java
// BEFORE: Called methods with their own @Transactional
this.updateStudent(std);
this.newEntry(proggSecond);

// AFTER: Direct EntityManager operations within same transaction
em.merge(std);
em.persist(proggSecond);
```

**Why This Works**:
- No nested transactions - all operations share the same transaction
- If one operation fails, we can catch and handle it without killing the batch
- EntityManager operations are more efficient than calling separate transactional methods

### 2. Improved Error Handling in `processStudentBatch()`

Added specific handling for `OptimisticLockException`:
```java
catch (jakarta.persistence.OptimisticLockException ole) {
    System.err.println("Optimistic lock error at offset " + offset);
    throw new RuntimeException("Lock acquisition failed - will retry", ole);
}
```

Added stack traces for debugging:
```java
catch (Exception studentError) {
    System.err.println("Failed to update progression for student " + std.getId());
    studentError.printStackTrace();
    // Continue with next student
}
```

## Transaction Flow (Fixed)

### Before (Broken)
```
processStudentBatch() [REQUIRES_NEW Transaction A]
  └─> updateStudentProgression2() [No transaction]
       ├─> updateStudent() [NEW Transaction B] ❌ Nested!
       │    └─> em.createQuery().executeUpdate()
       └─> newEntry() [NEW Transaction C] ❌ Nested!
            └─> em.persist()
```

When Transaction B or C failed, it marked Transaction A for rollback.

### After (Fixed)
```
processStudentBatch() [REQUIRES_NEW Transaction A]
  └─> updateStudentProgression2() [MANDATORY - uses Transaction A]
       ├─> em.merge(std) ✓ Same transaction
       └─> em.persist(proggSecond) ✓ Same transaction
```

All operations share Transaction A. If one fails, we catch it and continue.

## Benefits

1. **No Nested Transactions**: All database operations happen in the same transaction
2. **Better Error Isolation**: Individual student failures don't kill the entire batch
3. **Proper Rollback Handling**: If a batch fails, only that batch rolls back
4. **Retry Capability**: Failed batches can be retried without affecting successful ones
5. **Performance**: Direct EntityManager operations are faster than method calls

## Testing Checklist

After deploying:
- [ ] No more "STATUS_ROLLEDBACK" errors
- [ ] Batches process beyond batch 34
- [ ] Individual student errors don't stop batch processing
- [ ] Failed batches are retried successfully
- [ ] Progress logs show completion to 100%
- [ ] Database contains progression records for all students

## Additional Notes

### Why MANDATORY?
- `MANDATORY` means the method MUST be called within an existing transaction
- If called without a transaction, it throws an exception
- This prevents accidental use outside of batch processing
- Ensures all operations share the parent transaction

### Why em.merge() instead of em.createQuery().executeUpdate()?
- `merge()` updates the entity in the persistence context
- More efficient for single entity updates
- Automatically handles all changed fields
- Works within the same transaction seamlessly

### What if a student update still fails?
- The exception is caught in the `for` loop
- Error is logged with student ID
- Processing continues with next student
- Batch completes with partial success
- Failed student count is tracked
