# Active Session Table - Complete Explanation

## Answer: The `sessionmanager` Table

The current active session in `website_epayment_applicants.jsp` is determined by the **`sessionmanager`** database table.

## Flow Breakdown

### 1. JSP Page Call (website_epayment_applicants.jsp)

**Line 125:**
```jsp
Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation(
    appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), 
    "APPLICATION"
);
```

### 2. Backend Method (MainSession.java)

**Line 2098:**
```java
public Sessionmanager getCurrentSessionManagerBySchoolAndOperation(String schoolId, String operation) {
    Sessionmanager sm = null;
    try {
        // First attempt: Get OPEN session
        sm = (Sessionmanager) this.em.createQuery(
            "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op AND l.status = 'OPEN' ORDER BY l.name DESC, l.semester DESC"
        ).setParameter("sch", schoolId).setParameter("op", operation).setMaxResults(1).getSingleResult();
    } catch (Exception k) {
        try {
            // Fallback: Get latest session regardless of status
            sm = (Sessionmanager) this.em.createQuery(
                "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op ORDER BY l.name DESC, l.semester DESC"
            ).setParameter("sch", schoolId).setParameter("op", operation).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
    }
    return sm;
}
```

### 3. Database Query

**Table:** `sessionmanager`

**Query Logic:**
```sql
-- First attempt (prioritizes OPEN sessions)
SELECT * FROM sessionmanager 
WHERE school_id = ? 
  AND operation = 'APPLICATION' 
  AND status = 'OPEN' 
ORDER BY name DESC, semester DESC 
LIMIT 1;

-- Fallback (if no OPEN session found)
SELECT * FROM sessionmanager 
WHERE school_id = ? 
  AND operation = 'APPLICATION' 
ORDER BY name DESC, semester DESC 
LIMIT 1;
```

## Database Table Structure

### Table: `sessionmanager`

**Entity Class:** `com.mnl.eduportal.entities.Sessionmanager`

**Key Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | VARCHAR(50) | Primary key |
| `name` | VARCHAR(10) | Session name (e.g., "2024/2025") |
| `school_id` | VARCHAR(50) | Foreign key to schools table |
| `operation` | VARCHAR(20) | Operation type (e.g., "APPLICATION", "REGISTRATION") |
| `status` | VARCHAR(20) | Session status ("OPEN" or "CLOSED") |
| `semester` | VARCHAR(20) | Semester (e.g., "First", "Second", "Session") |
| `start_date` | TIMESTAMP | Session start date |
| `end_date` | TIMESTAMP | Session end date |
| `status_comment` | VARCHAR(200) | Optional comment about status |
| `programme_id` | VARCHAR(50) | Optional programme filter |

## How Active Session is Determined

### Priority 1: OPEN Status
The system first looks for sessions with `status = 'OPEN'`

### Priority 2: Latest Session Name
Orders by `name DESC` (e.g., "2024/2025" comes before "2023/2024")

### Priority 3: Latest Semester
Orders by `semester DESC` as secondary sort

### Filter Criteria:
1. **School Match:** `school_id` must match the applicant's school
2. **Operation Match:** `operation` must be "APPLICATION"
3. **Status Preference:** Prefers `status = 'OPEN'`

## Example Scenarios

### Scenario 1: Single OPEN Session
```
Database:
- Session "2024/2025", School S001, Operation APPLICATION, Status OPEN

Result: Returns "2024/2025" ✓
```

### Scenario 2: Multiple Sessions, One OPEN
```
Database:
- Session "2023/2024", School S001, Operation APPLICATION, Status CLOSED
- Session "2024/2025", School S001, Operation APPLICATION, Status OPEN

Result: Returns "2024/2025" (OPEN session) ✓
```

### Scenario 3: Multiple OPEN Sessions
```
Database:
- Session "2023/2024", School S001, Operation APPLICATION, Status OPEN
- Session "2024/2025", School S001, Operation APPLICATION, Status OPEN

Result: Returns "2024/2025" (latest by name) ✓
```

### Scenario 4: No OPEN Sessions
```
Database:
- Session "2023/2024", School S001, Operation APPLICATION, Status CLOSED
- Session "2024/2025", School S001, Operation APPLICATION, Status CLOSED

Result: Returns "2024/2025" (latest by name, fallback) ✓
```

### Scenario 5: Different Schools
```
Database:
- Session "2024/2025", School S001, Operation APPLICATION, Status OPEN
- Session "2023/2024", School S002, Operation APPLICATION, Status OPEN

Applicant from School S001:
Result: Returns "2024/2025" (matches school S001) ✓

Applicant from School S002:
Result: Returns "2023/2024" (matches school S002) ✓
```

## How to Control Active Session

### To Set a Session as Active:

1. **Update the status to OPEN:**
   ```sql
   UPDATE sessionmanager 
   SET status = 'OPEN' 
   WHERE id = 'SESSION_ID';
   ```

2. **Ensure other sessions are CLOSED:**
   ```sql
   UPDATE sessionmanager 
   SET status = 'CLOSED' 
   WHERE school_id = 'S001' 
     AND operation = 'APPLICATION' 
     AND id != 'ACTIVE_SESSION_ID';
   ```

### To Close a Session:

```sql
UPDATE sessionmanager 
SET status = 'CLOSED',
    status_comment = 'Session closed on 2024-03-11'
WHERE id = 'SESSION_ID';
```

### To Open a New Session:

```sql
INSERT INTO sessionmanager (
    id, 
    name, 
    school_id, 
    operation, 
    status, 
    semester,
    start_date,
    end_date
) VALUES (
    'SM_2024_2025_S001_APP',
    '2024/2025',
    'S001',
    'APPLICATION',
    'OPEN',
    'Session',
    '2024-09-01',
    '2025-08-31'
);
```

## Validation in JSP

After retrieving the session, the JSP validates:

```jsp
// Check if session exists
if (sm != null) {
    // Check if session is OPEN
    if (sm.getStatus().equalsIgnoreCase("OPEN")) {
        // Show payment options
    } else {
        // Show "session closed" message
    }
    
    // Validate applicant's session matches current session
    if (appx.getSession() != null && !appx.getSession().equalsIgnoreCase(sm.getName())) {
        // Show session mismatch error
    }
}
```

## Related Tables

### schools
- Referenced by `sessionmanager.school_id`
- Determines which school the session belongs to

### programmes
- Optionally referenced by `sessionmanager.programme_id`
- Can filter sessions by programme

### applicants
- Has `session` field that should match `sessionmanager.name`
- Used for validation in payment flow

## Admin Management

To manage active sessions, admins should:

1. **View Current Sessions:**
   ```sql
   SELECT id, name, school_id, operation, status, semester
   FROM sessionmanager
   WHERE operation = 'APPLICATION'
   ORDER BY school_id, name DESC;
   ```

2. **Check Active Sessions:**
   ```sql
   SELECT s.name as school_name, sm.name as session_name, sm.status
   FROM sessionmanager sm
   JOIN schools s ON sm.school_id = s.id
   WHERE sm.operation = 'APPLICATION'
     AND sm.status = 'OPEN';
   ```

3. **Transition Sessions:**
   ```sql
   -- Close old session
   UPDATE sessionmanager SET status = 'CLOSED' WHERE name = '2023/2024';
   
   -- Open new session
   UPDATE sessionmanager SET status = 'OPEN' WHERE name = '2024/2025';
   ```

## Important Notes

### Multi-School Support
Each school can have its own active session. School S001 can be on "2024/2025" while School S002 is on "2023/2024".

### Operation Types
Different operations can have different active sessions:
- `APPLICATION` - For applicant payments
- `REGISTRATION` - For student course registration
- Other custom operations

### Status Values
- `OPEN` - Session is active and accepting transactions
- `CLOSED` - Session is inactive, no transactions allowed

### Semester Values
- `Session` - Full academic session
- `First` - First semester
- `Second` - Second semester
- Custom values as needed

## Troubleshooting

### Issue: Wrong session displayed
**Check:**
1. Is the correct session marked as OPEN?
2. Is the school_id correct?
3. Is the operation set to "APPLICATION"?

### Issue: No session found
**Check:**
1. Does a sessionmanager record exist for the school?
2. Is the operation field set correctly?
3. Are there any database connection issues?

### Issue: Session mismatch error
**Check:**
1. Does applicant's session field match the current session name?
2. Is the applicant from an old session trying to pay for a new session?
3. Should the applicant's session be updated?

## Summary

**Table:** `sessionmanager`  
**Key Field:** `status = 'OPEN'`  
**Filter:** `school_id` + `operation = 'APPLICATION'`  
**Sort:** `name DESC, semester DESC`  
**Result:** Latest OPEN session for the school's APPLICATION operation  

This table is the single source of truth for determining which session is currently active for applicant payments.
