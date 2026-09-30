# Transaction Rollback Fix - STATUS_MARKED_ROLLBACK

## Problem
The application was experiencing infinite retry loops with the error:
```
IJ031070: Transaction cannot proceed: STATUS_MARKED_ROLLBACK
Batch processing error at offset 0: could not prepare statement
```

## Root Cause
The `processStudentBatch()` method had a critical Hibernate issue:

1. **Collection fetch with pagination**: Using `LEFT JOIN FETCH s.studentprogressionCollection` with `setFirstResult/setMaxResults`
2. **In-memory pagination**: Hibernate warning "firstResult/maxResults specified with collection fetch; applying in memory"
3. **Transaction marked for rollback**: An earlier failure marked the transaction for rollback, causing infinite retries

## The Fix
**File**: `src/main/java/com/mnl/eduportal/sessions/MainSession.java`

**Changed**: Removed collection fetch from the paginated query and load it separately

**Before**:
```java
TypedQuery<Students> query = em.createQuery(
    "SELECT DISTINCT s FROM Students s "
    + "JOIN FETCH s.courseId "
    + "JOIN FETCH s.courseId.schoolProgrammeId "
    + "JOIN FETCH s.courseId.schoolProgrammeId.schoolId "
    + "LEFT JOIN FETCH s.studentprogressionCollection "  // ❌ Problem
    + "WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId "
    + "ORDER BY s.id",
    Students.class);
query.setFirstResult(offset);
query.setMaxResults(batchSize);
```

**After**:
```java
// Step 1: Fetch students without collection (allows proper pagination)
TypedQuery<Students> query = em.createQuery(
    "SELECT DISTINCT s FROM Students s "
    + "JOIN FETCH s.courseId "
    + "JOIN FETCH s.courseId.schoolProgrammeId "
    + "JOIN FETCH s.courseId.schoolProgrammeId.schoolId "
    + "WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId "
    + "ORDER BY s.id",
    Students.class);
query.setFirstResult(offset);
query.setMaxResults(batchSize);

List<Students> students = query.getResultList();

// Step 2: Load collections separately (avoids N+1 and pagination issues)
if (!students.isEmpty()) {
    em.createQuery(
        "SELECT s FROM Students s "
        + "LEFT JOIN FETCH s.studentprogressionCollection "
        + "WHERE s IN :students",
        Students.class)
        .setParameter("students", students)
        .getResultList();
}
```

## Additional Fixes
- Updated deprecated hint from `javax.persistence.query.timeout` to `jakarta.persistence.query.timeout`

## Why This Works
1. **Proper pagination**: Database can paginate efficiently without loading collections
2. **No in-memory pagination**: Hibernate doesn't need to load all results into memory
3. **Avoids N+1**: Second query loads all collections in one batch
4. **Transaction stability**: No collection fetch conflicts with pagination

## Testing
After deploying, verify:
- No more "firstResult/maxResults specified with collection fetch" warnings
- No more STATUS_MARKED_ROLLBACK errors
- Student batch processing completes successfully
- Performance remains acceptable
