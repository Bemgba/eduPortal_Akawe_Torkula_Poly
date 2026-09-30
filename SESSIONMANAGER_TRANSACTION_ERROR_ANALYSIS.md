# Sessionmanager Transaction Rollback Error Analysis

## Error Summary

**Error**: `LockAcquisitionException: could not prepare statement [IJ031070: Transaction cannot proceed: STATUS_ROLLEDBACK]`

**Location**: `changeofsession.jsp` line 565 → `sess.newSessionmanager(smu)`

**Root Cause**: **Lazy Loading + N+1 Query Problem** causing transaction timeout and rollback

---

## The Problem Chain

### 1. Initial Transaction Starts
```java
@Transactional
public void newSessionmanager(Sessionmanager obj) {
    em.persist(obj);  // Persists Sessionmanager
    
    if (obj.getOperation().equalsIgnoreCase("REGISTRATION")) {
        this.createSessionProgression(obj.getId());  // Calls progression creation
    }
}
```

### 2. Fetches ALL Students with Eager Loading
```java
public void createSessionProgression(String id) {
    // Query fetches students with JOIN FETCH
    TypedQuery<Students> query = em.createQuery(
        "SELECT s FROM Students s "
        + "JOIN FETCH s.courseId "
        + "JOIN FETCH s.courseId.schoolProgrammeId "
        + "JOIN FETCH s.courseId.schoolProgrammeId.schoolId "
        + "WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId",
        Students.class);
    
    List<Students> students = query.getResultList();
    
    // Loops through ALL students
    for (Students std : students) {
        this.updateStudentProgression2(std);  // PROBLEM STARTS HERE
    }
}
```

### 3. The Killer: Lazy Loading in Loop
```java
public void updateStudentProgression2(Students std) {
    // THIS LINE TRIGGERS LAZY LOADING!
    Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
    
    // Iterates through the collection
    for (Studentprogression person : prograssion) {
        // Checks existing progression
    }
}
```

---

## Why It Fails

### The N+1 Query Problem

**Error Log Shows**:
```
Suppressed: org.hibernate.exception.LockAcquisitionException: 
could not prepare statement [IJ031070: Transaction cannot proceed: STATUS_ROLLEDBACK]
[select sc1_0.students_id,sc1_0.id,sc1_0.course_id,ci1_0.id,ci1_0.code,c1_0.id,
c1_0.jamd_name,spi1_0.id,hi1_0.id,a1_0.id,a1_0.contact_address,a1_0.date_added,
... (MASSIVE JOIN QUERY) ...]
```

**What's Happening**:

1. **Initial Query**: Fetches all students (could be hundreds/thousands)
2. **For Each Student**: Hibernate tries to lazy-load `studentprogressionCollection`
3. **Each Lazy Load**: Triggers a MASSIVE join query (see error log - joins 17+ tables!)
4. **Result**: 
   - If 1000 students → 1000+ additional queries
   - Each query joins 17+ tables
   - Transaction times out
   - Database locks accumulate
   - **Transaction rolls back with STATUS_ROLLEDBACK**

### The Massive Query Problem

The lazy-loaded query joins:
- `studentprogression` table
- `courses` (multiple times: ci1_0, ci2_0, ci3_0, etc.)
- `schoolprogrammes` (spi1_0, spi2_0)
- `users` (hi1_0, hi3_0, hi5_0, hi6_0, hi8_0, hi10_0, hi12_0, hi14_0)
- `applicantsbiodata` (a1_0, a2_0, a3_0, etc.)
- `lgas`, `states`, `countries` (multiple times)
- `roles`, `pages`, `menus`
- `faculties_directorates` (fd1_0, fd2_0, etc.)
- `departments`, `positions`
- And more...

**This is a 17+ table join executed 1000+ times!**

---

## Root Causes

### 1. **Lazy Loading in Transaction**
```java
// Students entity has lazy-loaded collection
@OneToMany(mappedBy = "studentsId", fetch = FetchType.LAZY)
private Collection<Studentprogression> studentprogressionCollection;
```

When accessed inside the loop:
```java
Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
```
Hibernate executes a new query for EACH student.

### 2. **Over-Eager Entity Relationships**
The `Studentprogression` entity has too many eager relationships:
- Course → SchoolProgramme → School → Head (User) → Biodata → LGA → State → Country
- Course → Department → Faculty → Head (User) → Biodata → ...
- Multiple levels of eager fetching cascade

### 3. **No Batch Processing**
Processing all students in a single transaction without:
- Batch commits
- Pagination
- Transaction boundaries

### 4. **Transaction Timeout**
The transaction takes too long:
- Persist Sessionmanager
- Fetch all students
- For each student: lazy load progression (massive query)
- For each student: update progression
- For each student: potentially update student record
- Database locks accumulate
- **Transaction timeout → Rollback**

---

## Solutions

### Solution 1: **Fetch Studentprogression Eagerly** (Quick Fix)

Modify the initial query to include studentprogression:

```java
public void createSessionProgression(String id) {
    Sessionmanager sm = this.getSessionmanager(id);
    if (sm != null && sm.getOperation().equalsIgnoreCase("REGISTRATION")) {
        try {
            // FETCH studentprogression collection eagerly
            TypedQuery<Students> query = em.createQuery(
                "SELECT DISTINCT s FROM Students s "
                + "JOIN FETCH s.courseId "
                + "JOIN FETCH s.courseId.schoolProgrammeId "
                + "JOIN FETCH s.courseId.schoolProgrammeId.schoolId "
                + "LEFT JOIN FETCH s.studentprogressionCollection "  // ADD THIS
                + "WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId",
                Students.class);
            query.setParameter("schoolId", sm.getSchoolId().getId());
            List<Students> students = query.getResultList();

            for (Students std : students) {
                this.updateStudentProgression2(std);
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
    }
}
```

**Pros**: Simple one-line fix
**Cons**: Still loads all data at once (memory intensive)

---

### Solution 2: **Batch Processing** (Recommended)

Process students in batches with separate transactions:

```java
public void createSessionProgression(String id) {
    Sessionmanager sm = this.getSessionmanager(id);
    if (sm != null && sm.getOperation().equalsIgnoreCase("REGISTRATION")) {
        try {
            int batchSize = 50;  // Process 50 students at a time
            int firstResult = 0;
            boolean hasMore = true;

            while (hasMore) {
                // Fetch batch of students
                TypedQuery<Students> query = em.createQuery(
                    "SELECT DISTINCT s FROM Students s "
                    + "JOIN FETCH s.courseId "
                    + "JOIN FETCH s.courseId.schoolProgrammeId "
                    + "JOIN FETCH s.courseId.schoolProgrammeId.schoolId "
                    + "LEFT JOIN FETCH s.studentprogressionCollection "
                    + "WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId",
                    Students.class);
                query.setParameter("schoolId", sm.getSchoolId().getId());
                query.setFirstResult(firstResult);
                query.setMaxResults(batchSize);
                
                List<Students> students = query.getResultList();
                
                if (students.isEmpty()) {
                    hasMore = false;
                } else {
                    // Process batch
                    for (Students std : students) {
                        this.updateStudentProgression2(std);
                    }
                    
                    // Flush and clear to free memory
                    em.flush();
                    em.clear();
                    
                    firstResult += batchSize;
                }
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
    }
}
```

**Pros**: 
- Prevents memory overflow
- Smaller transactions
- Better performance

**Cons**: Slightly more complex

---

### Solution 3: **Separate Transactions** (Best for Large Data)

Split the operation into two separate transactions:

**Step 1**: Create Sessionmanager (separate transaction)
```java
@Transactional
public void newSessionmanager(Sessionmanager obj) {
    em.persist(obj);
    // DON'T call createSessionProgression here
}
```

**Step 2**: Create progression asynchronously or in background job
```java
// In changeofsession.jsp
sess.newSessionmanager(smu);  // Creates session only

// Then trigger async progression creation
sess.createSessionProgressionAsync(smu.getId());  // Separate transaction
```

**Implement async method**:
```java
@Asynchronous  // Or use a background job
@Transactional(Transactional.TxType.REQUIRES_NEW)  // New transaction
public void createSessionProgressionAsync(String sessionId) {
    // Use batch processing from Solution 2
    createSessionProgression(sessionId);
}
```

**Pros**: 
- Fast response to user
- No transaction timeout
- Can show progress to user

**Cons**: More complex architecture

---

### Solution 4: **Optimize Entity Relationships** (Long-term)

Review and optimize `Studentprogression` entity relationships:

```java
@Entity
public class Studentprogression {
    // Change eager fetches to lazy where appropriate
    @ManyToOne(fetch = FetchType.LAZY)  // Instead of EAGER
    private Courses courseId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    private Students studentsId;
    
    // Only fetch what you need, when you need it
}
```

**Pros**: Better overall performance
**Cons**: Requires careful analysis and testing

---

### Solution 5: **Use Native Query with Minimal Joins**

Instead of fetching full entities, fetch only IDs:

```java
public void createSessionProgression(String id) {
    Sessionmanager sm = this.getSessionmanager(id);
    if (sm != null && sm.getOperation().equalsIgnoreCase("REGISTRATION")) {
        try {
            // Fetch only student IDs
            Query query = em.createNativeQuery(
                "SELECT s.id FROM students s "
                + "JOIN courses c ON s.course_id = c.id "
                + "JOIN schoolprogrammes sp ON c.school_programme_id = sp.id "
                + "WHERE sp.school_id = :schoolId");
            query.setParameter("schoolId", sm.getSchoolId().getId());
            
            List<String> studentIds = query.getResultList();
            
            // Process in batches
            int batchSize = 50;
            for (int i = 0; i < studentIds.size(); i += batchSize) {
                int end = Math.min(i + batchSize, studentIds.size());
                List<String> batch = studentIds.subList(i, end);
                
                for (String studentId : batch) {
                    Students std = em.find(Students.class, studentId);
                    this.updateStudentProgression2(std);
                }
                
                em.flush();
                em.clear();
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
    }
}
```

---

## Immediate Fix (Choose One)

### Option A: Quick Fix (5 minutes)
Add `LEFT JOIN FETCH s.studentprogressionCollection` to the query in `createSessionProgression`

### Option B: Better Fix (30 minutes)
Implement batch processing (Solution 2)

### Option C: Best Fix (2 hours)
Implement separate transactions with async processing (Solution 3)

---

## Testing After Fix

1. **Test with small dataset** (10-20 students)
2. **Monitor transaction time**
3. **Check database locks**: `SELECT * FROM pg_locks;` (PostgreSQL)
4. **Test with realistic dataset** (1000+ students)
5. **Monitor memory usage**
6. **Check application logs** for any remaining lazy loading issues

---

## Prevention

1. **Always use `JOIN FETCH` for collections accessed in loops**
2. **Implement batch processing for bulk operations**
3. **Use pagination for large datasets**
4. **Monitor transaction duration**
5. **Set appropriate transaction timeouts**
6. **Use `@BatchSize` annotation on collections**
7. **Consider using DTOs instead of full entities for bulk operations**

---

## Summary

**Problem**: Lazy loading `studentprogressionCollection` inside a loop causes N+1 queries with massive joins, leading to transaction timeout and rollback.

**Quick Fix**: Add `LEFT JOIN FETCH s.studentprogressionCollection` to the initial query.

**Best Fix**: Implement batch processing with separate transaction boundaries.

**Root Cause**: Combination of lazy loading, over-eager entity relationships, and lack of batch processing for bulk operations.
