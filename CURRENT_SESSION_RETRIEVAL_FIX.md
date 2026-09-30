# Current Session Retrieval Fix

## Issue

The "Current Session" displayed on `website_epayment_applicants.jsp` was retrieving the **wrong session**, which could prevent applicants from making payments even when an active session exists.

## Root Cause

The `getCurrentSessionManagerBySchoolAndOperation()` method in `MainSession.java` was retrieving sessions based solely on alphabetical ordering, without considering the session's status (OPEN/CLOSED).

### Original Logic (BROKEN):

```java
public Sessionmanager getCurrentSessionManagerBySchoolAndOperation(String schoolId, String operation) {
    Sessionmanager sm = null;
    try {
        sm = (Sessionmanager) em.createQuery(
                "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op ORDER BY l.name DESC, l.semester DESC")
                .setParameter("sch", schoolId).setParameter("op", operation)
                .setMaxResults(1)
                .getSingleResult();
    } catch (Exception k) {
    }
    return sm;
}
```

**Problem:** This query orders by `name DESC` (e.g., "2024/2025", "2023/2024", "2022/2023") and takes the first result. This means:
- If "2024/2025" is CLOSED and "2023/2024" is OPEN, it returns the CLOSED "2024/2025" session
- Applicants see: "Sorry, session 2024/2025 is marked closed hence no payment can be made on it"
- Even though "2023/2024" is OPEN and accepting payments!

## How It Affects the Payment Flow

### In website_epayment_applicants.jsp:

1. **Line 124:** Retrieves the "current" session
   ```jsp
   Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation(
       appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), 
       "APPLICATION"
   );
   ```

2. **Line 196:** Displays the session name
   ```jsp
   <td class="left"><%=sm.getName()%></td>
   ```

3. **Line 200:** Checks if session is OPEN
   ```jsp
   if (sm.getStatus().equalsIgnoreCase("OPEN")) {
       // Show payment options
   } else {
       // Show "session is closed" message
   }
   ```

### The Problem Scenario:

```
Database State:
- Session "2024/2025" - Status: CLOSED, Operation: APPLICATION
- Session "2023/2024" - Status: OPEN, Operation: APPLICATION

Old Behavior:
1. Method returns "2024/2025" (alphabetically latest)
2. JSP checks status → CLOSED
3. Shows error: "Sorry, session 2024/2025 is marked closed..."
4. Applicant CANNOT make payment even though 2023/2024 is OPEN!

New Behavior:
1. Method returns "2023/2024" (latest OPEN session)
2. JSP checks status → OPEN
3. Shows payment options
4. Applicant CAN make payment ✓
```

## Solution

Modified the method to **prioritize OPEN sessions** while maintaining backward compatibility:

```java
public Sessionmanager getCurrentSessionManagerBySchoolAndOperation(String schoolId, String operation) {
    Sessionmanager sm = null;
    try {
        // First, try to get an OPEN session
        sm = (Sessionmanager) em.createQuery(
                "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op AND l.status = 'OPEN' ORDER BY l.name DESC, l.semester DESC")
                .setParameter("sch", schoolId).setParameter("op", operation)
                .setMaxResults(1)
                .getSingleResult();
    } catch (Exception k) {
        // If no OPEN session found, fall back to the latest session regardless of status
        try {
            sm = (Sessionmanager) em.createQuery(
                    "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op ORDER BY l.name DESC, l.semester DESC")
                    .setParameter("sch", schoolId).setParameter("op", operation)
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (Exception e) {
        }
    }
    return sm;
}
```

### New Logic:

1. **First attempt:** Query for OPEN sessions only, ordered by name DESC
   - If found: Returns the latest OPEN session ✓
   
2. **Fallback:** If no OPEN session exists, query for any session
   - Returns the latest session regardless of status
   - This maintains backward compatibility for pages that need to display session info even when closed

## Impact

This fix affects ALL places where `getCurrentSessionManagerBySchoolAndOperation()` is called:

### Direct Impact (Payment Pages):
- `website_epayment_applicants.jsp` - Applicant payments ✓
- `website_epayment_student.jsp` - Student payments (if similar logic exists)

### Indirect Impact (Other Operations):
- `AjaxServlet.java` - REGISTRATION operations
- `DownloadCompleteApplications.java` - Application downloads
- `UploadDEApplicants.java` - Direct Entry uploads
- `UploadJambAdmissionlist.java` - JAMB admission list uploads
- `UploadPGAdmissionlist.java` - Postgraduate admission uploads
- `UploadUTMEApplicants.java` - UTME applicant uploads
- `UploadUTMEPostutme.java` - Post-UTME uploads
- Various auto-screening and student progression operations

All these operations will now correctly use the OPEN session when available.

## Testing Recommendations

1. **Test with OPEN session:**
   - Create a session with status = "OPEN"
   - Verify applicants can make payments
   - Verify correct session name is displayed

2. **Test with multiple sessions:**
   - Create "2023/2024" with status = "OPEN"
   - Create "2024/2025" with status = "CLOSED"
   - Verify "2023/2024" is used (not "2024/2025")

3. **Test with no OPEN session:**
   - Mark all sessions as "CLOSED"
   - Verify the latest session is still displayed
   - Verify appropriate "session closed" message appears

4. **Test session transitions:**
   - Close current session
   - Open new session
   - Verify payment page immediately uses new OPEN session

## Files Modified

- `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Line 2575)
  - Method: `getCurrentSessionManagerBySchoolAndOperation()`

## Related Files (No Changes Needed)

- `src/main/webapp/website_epayment_applicants.jsp` - Already has status check logic
- `src/main/java/com/mnl/eduportal/entities/Sessionmanager.java` - Entity definition
