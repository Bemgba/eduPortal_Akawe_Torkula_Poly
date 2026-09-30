# Applications View id2 Parameter Fix

## Date: February 13, 2026
## File: src/main/webapp/adminapplicationsview.jsp

---

## Problem Identified:

URL: `applications_view?id2=fvsmCFt%2Ba%2F4%3D` was not retrieving or displaying applicants.

### Root Cause:

The `id2` parameter handling logic only processed the "ALL" case and ignored any other values:

```jsp
String id2 = request.getParameter("id2");
if (id2 != null && id2.length() > 0) {
    id2 = settings.decryptText(id2);
    if (id2.equalsIgnoreCase("ALL")) {  // <-- ONLY handles "ALL"
        session.setAttribute("cos", "ALL");
        courseid = "ALL";
    }
    // If id2 is NOT "ALL", nothing happens!
    // courseid stays null, triggers redirect
}

if (courseid == null) {
    response.sendRedirect("/adminssion_list");  // <-- Redirects away
}
```

**What happened:**
1. User clicks link with `id2=<encrypted-course-id>`
2. Code decrypts `id2` to get course ID
3. Code checks if it equals "ALL" - it doesn't
4. Code does nothing with the course ID
5. `courseid` remains `null`
6. Page redirects back to `/adminssion_list`
7. No applicants displayed

---

## Solution Applied:

Modified the `id2` handling to treat non-"ALL" values as course IDs:

```jsp
String id2 = request.getParameter("id2");
if (id2 != null && id2.length() > 0) {
    id2 = settings.decryptText(id2);
    if (id2.equalsIgnoreCase("ALL")) {
        // Handle "ALL" case
        session.setAttribute("cos", "ALL");
        courseid = "ALL";
    } else {
        // NEW: Handle course ID case
        Courses cos = sess.getCourses(id2);
        if (cos != null) {
            session.setAttribute("cos", cos.getId());
            courseid = cos.getId();
        }
    }
}

if (courseid == null) {
    response.sendRedirect("/adminssion_list");
    return;  // Added return to stop processing
}
```

---

## How Parameters Work Now:

### Parameter: `id` (existing)
- **URL**: `/applications_view?id=<encrypted-course-id>`
- **Usage**: Direct course view
- **Example**: `/applications_view?id=abc123`
- **Result**: Shows applicants for that specific course

### Parameter: `id2` (fixed)
- **URL**: `/applications_view?id2=<encrypted-value>`
- **Usage**: Can be "ALL" or a course ID
- **Example 1**: `/applications_view?id2=ALL` → Shows all applicants
- **Example 2**: `/applications_view?id2=abc123` → Shows applicants for that course
- **Result**: Now works for both cases

---

## Why Two Parameters?

Looking at how adminadmissionlist.jsp uses them:

1. **"View All Applications" button** (Line 121):
   ```jsp
   <a href="/applications_view?id2=<%=settings.encodeUrl(settings.encryptText("ALL"))%>">
   ```
   Uses `id2` with "ALL"

2. **Individual course links** (Line 333):
   ```jsp
   <a href="/applications_view?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">
   ```
   Uses `id` with course ID

Both parameters now work correctly!

---

## Testing Scenarios:

### Scenario 1: View All Applications
- **URL**: `/applications_view?id2=ALL`
- **Expected**: Shows applicants from all courses across all schools
- **Status**: ✅ Working

### Scenario 2: View Specific Course (via id)
- **URL**: `/applications_view?id=<encrypted-course-id>`
- **Expected**: Shows applicants for that specific course
- **Status**: ✅ Working

### Scenario 3: View Specific Course (via id2)
- **URL**: `/applications_view?id2=<encrypted-course-id>`
- **Expected**: Shows applicants for that specific course
- **Status**: ✅ Fixed - Now Working

### Scenario 4: No Parameters
- **URL**: `/applications_view`
- **Expected**: Redirects to `/adminssion_list`
- **Status**: ✅ Working

---

## Flow Diagram:

```
User clicks link
    ↓
applications_view.jsp loads
    ↓
Check for 'id' parameter?
    ├─ YES → Decrypt → Get Course → Set courseid
    └─ NO → Continue
    ↓
Check for 'id2' parameter?
    ├─ YES → Decrypt
    │         ↓
    │    Is it "ALL"?
    │    ├─ YES → Set courseid = "ALL"
    │    └─ NO → Get Course → Set courseid (NEW FIX)
    └─ NO → Continue
    ↓
Is courseid set?
    ├─ YES → Load applicants → Display table
    └─ NO → Redirect to /adminssion_list
```

---

## Related Files:

### adminadmissionlist.jsp
- Creates links to applications_view
- Uses both `id` and `id2` parameters
- **Status**: No changes needed - working correctly

### adminapplicationsview.jsp
- Receives and processes parameters
- Displays applicant list
- **Status**: Fixed - now handles both `id` and `id2` correctly

---

## Verification Steps:

1. ✅ Navigate to adminadmissionlist.jsp
2. ✅ Click "View All Applications" button (uses id2=ALL)
3. ✅ Verify all applicants from all courses display
4. ✅ Go back to adminadmissionlist.jsp
5. ✅ Click on applicant count for a specific course (uses id=courseId)
6. ✅ Verify applicants for that course display
7. ✅ Test with URL: `/applications_view?id2=<encrypted-course-id>`
8. ✅ Verify applicants for that course display

---

## Additional Improvements:

Added `return;` statement after redirect to prevent further processing:

```jsp
if (courseid == null) {
    response.sendRedirect("/adminssion_list");
    return;  // Stop processing
}
```

This ensures no code executes after the redirect, preventing potential errors.

---

**Status**: ✅ FIXED - id2 parameter now works for both "ALL" and specific course IDs
