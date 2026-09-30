# Transaction Rollback Fix V3 - Infinite Retry Loop at Offset 2000

## Critical Problem Identified

The system is stuck in an infinite retry loop with the following pattern:
```
Retrying 440 failed batches...
Retry attempt 1 of 2 for 440 batches
Optimistic lock error at offset 2000: STATUS_ROLLEDBACK (repeating infinitely)
```

## Root Cause Analysis

### The Real Issue: Connection Pool Exhaustion

1. **440 out of 450 batches failed** - This means almost ALL batches are failing
2. **Transaction marked STATUS_ROLLEDBACK BEFORE query executes** - The transaction manager is rejecting transactions before they even start
3. **Stuck at offset 2000** - The retry logic keeps trying the same batch over and over
4. **REQUIRES_NEW is the culprit** - Each batch creates a NEW transaction, and with 450 batches, this exhausts the connection pool

### Why REQUIRES_NEW Causes This

```java
@Transactional(REQUIRES_NEW)  // ❌ Creates NEW transaction for EACH batch
private int processStudentBatch(...) {
    // Each of 450 batches gets its own transaction
    // If batches don't complete fast enough, connections pile up
    // Connection pool exhausted → STATUS_ROLLEDBACK
}
```

With 89,889 students in batches of 100:
- 899 batches total
- Each batch tries to get a NEW connection
- If connection pool has only 20 connections, and batches take time to complete
- After 20 batches, no more connections available
- All subsequent batches get STATUS_ROLLEDBACK immediately

## The Solution: Remove REQUIRES_NEW and Add Circuit Breaker

### Key Changes

1. **Remove REQUIRES_NEW** - Use regular `@Transactional` so batches share connection pool normally
2. **Add Circuit Breaker** - Stop retrying after consecutive failures to prevent infinite loops
3. **Reduce Batch Size** - Smaller batches = faster completion = less connection pool pressure
4. **Add Longer Delays** - Give connection pool time to recover between batches

## Implementation

### Change 1: Remove REQUIRES_NEW

```java
// BEFORE (BROKEN)
@Transactional(Transactional.TxType.REQUIRES_NEW)
private int processStudentBatch(...) {

// AFTER (FIXED)
@Transactional(Transactional.TxType.REQUIRED)
private int processStudentBatch(...) {
```

**Why This Works:**
- `REQUIRED` reuses existing transaction if available, or creates one if needed
- Doesn't force creation of new transactions for every batch
- Reduces connection pool pressure dramatically
- Transactions still commit independently because parent method has no transaction

### Change 2: Add Circuit Breaker

```java
int consecutiveFailures = 0;
int maxConsecutiveFailures = 5;  // Stop after 5 consecutive failures

for (int offset = 0; offset < totalStudents; offset += batchSize) {
    try {
        int batchProcessed = processStudentBatch(...);
        consecutiveFailures = 0;  // Reset on success
        processedStudents += batchProcessed;
    } catch (Exception batchError) {
        consecutiveFailures++;
        failedStudents += batchFailedCount;
        
        // Circuit breaker: Stop if too many consecutive failures
        if (consecutiveFailures >= maxConsecutiveFailures) {
            String msg = "STOPPING: " + consecutiveFailures + " consecutive failures detected. " +
                        "Possible connection pool exhaustion or database issue.";
            errors.add(msg);
            System.err.println(msg);
            break;  // Stop processing
        }
    }
}
```

**Why This Works:**
- Detects when system is in a bad state (consecutive failures)
- Stops processing instead of continuing to fail
- Prevents infinite retry loops
- Gives clear error message about what happened

### Change 3: Reduce Batch Size

```java
// BEFORE
if (totalStudents >= 10000) {
    batchSize = 100;  // Still too large
}

// AFTER
if (totalStudents >= 10000) {
    batchSize = 50;   // Smaller batches
}
```

**Why This Works:**
- Smaller batches complete faster
- Less time holding database connections
- Reduces memory pressure
- Lower risk of timeout

### Change 4: Add Longer Delays

```java
// Add delay every 5 batches instead of every 10
if (processedBatches % 5 == 0) {
    Thread.sleep(1000);  // 1 second pause (increased from 500ms)
}
```

**Why This Works:**
- Gives connection pool time to recover
- Allows database to process commits
- Reduces sustained load on database
- Prevents connection pool exhaustion

## Complete Fixed Code

The fixed code includes:
1. `@Transactional(REQUIRED)` instead of `REQUIRES_NEW`
2. Circuit breaker with 5 consecutive failure limit
3. Reduced batch sizes (50 for large datasets)
4. Longer delays (1 second every 5 batches)
5. Better error messages indicating connection pool issues

## Expected Behavior After Fix

### Before (Broken)
```
Starting progression processing: 89889 students in 450 batches (batch size: 200)
Batch 11 (offset 89800) failed: STATUS_ROLLEDBACK
Retrying 440 failed batches...
Optimistic lock error at offset 2000: STATUS_ROLLEDBACK
Optimistic lock error at offset 2000: STATUS_ROLLEDBACK
Optimistic lock error at offset 2000: STATUS_ROLLEDBACK
(infinite loop...)
```

### After (Fixed)
```
Starting progression processing: 89889 students in 1798 batches (batch size: 50)
Progress: 10000/89889 students (11%) - Batch 200/1798
Progress: 20000/89889 students (22%) - Batch 400/1798
Progress: 44945/89889 students (50%) - Batch 899/1798
Progress: 67418/89889 students (75%) - Batch 1349/1798
Progress: 89889/89889 students (100%) - Batch 1798/1798
Progression processing completed: 89889 succeeded, 0 failed
```

## Why Previous Fixes Didn't Work

### Fix V1: Removed collection fetch
- ✅ Fixed pagination warning
- ❌ Didn't address connection pool issue

### Fix V2: Changed to MANDATORY, used em.merge()
- ✅ Fixed nested transaction issue
- ❌ Didn't address connection pool exhaustion from REQUIRES_NEW

### Fix V3 (This Fix): Remove REQUIRES_NEW + Circuit Breaker
- ✅ Fixes connection pool exhaustion
- ✅ Prevents infinite retry loops
- ✅ Provides clear error messages
- ✅ Reduces batch size for faster completion

## Testing Checklist

After deploying this fix:
- [ ] No more "STATUS_ROLLEDBACK" errors
- [ ] No infinite retry loops
- [ ] Processing completes to 100%
- [ ] Circuit breaker triggers if there's a real database issue
- [ ] Error messages clearly indicate connection pool problems if they occur
- [ ] All students get progression records

## If Issues Persist

If you still see failures after this fix, it indicates a deeper problem:

1. **Database Connection Pool Too Small**
   - Check WildFly datasource configuration
   - Increase `max-pool-size` from default (usually 20) to 50 or 100

2. **Database Performance Issues**
   - Check for missing indexes on `students` table
   - Check for long-running queries blocking progression
   - Monitor database CPU and memory

3. **Network Issues**
   - Check network latency between app server and database
   - Look for intermittent connection drops

## Configuration to Check

### WildFly Datasource (standalone.xml or standalone-full.xml)

```xml
<datasource jndi-name="java:jboss/datasources/YourDS" pool-name="YourDS">
    <connection-url>jdbc:postgresql://localhost:5432/yourdb</connection-url>
    <driver>postgresql</driver>
    <pool>
        <min-pool-size>10</min-pool-size>
        <max-pool-size>50</max-pool-size>  <!-- Increase this -->
        <prefill>true</prefill>
    </pool>
    <timeout>
        <idle-timeout-minutes>5</idle-timeout-minutes>
        <blocking-timeout-millis>30000</blocking-timeout-millis>
    </timeout>
</datasource>
```

## Summary

The fix changes the transaction strategy from `REQUIRES_NEW` (which creates a new transaction for every batch) to `REQUIRED` (which reuses transactions), adds a circuit breaker to prevent infinite loops, reduces batch sizes, and adds delays to prevent connection pool exhaustion.

This should resolve the infinite retry loop and allow progression processing to complete successfully.
