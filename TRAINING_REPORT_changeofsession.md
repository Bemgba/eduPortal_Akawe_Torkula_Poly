# Training Activity Report - changeofsession.jsp
**Date:** February 12, 2026  
**Client:** EduPortal  
**Page/Module:** Session Manager (changeofsession.jsp)

---

## Overview
The **changeofsession.jsp** page is a critical administrative interface for managing academic sessions within the EduPortal system. This page serves as the central control panel for creating and managing academic sessions for both student applications and registrations across different schools. It provides administrators with the ability to define and control the active academic periods that govern the entire admission and registration workflow.

---

## Page Access & Security
- **Access Control:** The page is protected and requires user authentication. Unauthenticated users are automatically redirected to the login page.
- **User Type:** This page is accessible only to staff members with appropriate administrative privileges.
- **URL Path:** `/session_change`
- **Authorization Level:** High-level administrative access required due to the critical nature of session management

---

## Core Functionality

### 1. **Create New Academic Session**
The primary function of this page is to create new academic session records that control when applications and registrations are open.

#### Session Creation Form Fields:

**a) Select Session**
- Dropdown menu displaying available academic sessions
- Automatically generates the next 5 possible sessions after the latest existing session
- Format: Academic year format (e.g., "2024/2025", "2025/2026")
- System intelligently suggests upcoming sessions based on current records

**b) Semester**
- Three options available:
  - **First:** First semester of the academic session
  - **Second:** Second semester of the academic session
  - **Session:** Full academic session (both semesters)
- Allows granular control over semester-specific operations

**c) Select School**
- Dropdown menu listing all schools in the system
- Each session is school-specific
- Enables different schools to operate on different academic calendars
- Displays school names for easy identification

**d) Operation Type**
- Two operation types available:
  - **APPLICATION:** Controls when prospective students can submit applications
  - **REGISTRATION:** Controls when admitted students can register for courses
- Each operation type can have separate sessions and timelines

#### Session Creation Process:
1. Select the desired academic session from the dropdown
2. Choose the semester (First, Second, or Session)
3. Select the school for which the session applies
4. Choose the operation type (APPLICATION or REGISTRATION)
5. Click the "Create" button

#### Automatic Session Properties:
When a new session is created, the system automatically:
- Generates a unique session ID (format: first part of session year + 4-digit random ID)
- Sets the start date to the current date and time
- Sets the initial status to "OPEN"
- Associates the session with the selected school
- Stores all configuration parameters

#### Validation & Error Handling:
- **Duplicate Prevention:** The system checks if a session with the same combination already exists
  - Same session name
  - Same operation type
  - Same semester
  - Same school
- **Error Message:** "This session is already created" (displayed in red alert)
- **Success:** New session appears immediately in the session list table

---

### 2. **View All Session Managers**
The page displays a comprehensive table showing all created session managers across all schools.

#### Table Columns:
- **# (Serial Number):** Sequential numbering of session records
- **School:** The name of the school this session applies to
- **Session:** The academic session (e.g., "2024/2025")
- **Semester:** The semester designation (First, Second, or Session)
- **Operation:** The operation type (APPLICATION or REGISTRATION)
- **Opened:** The date when the session was created (format: YYYY-MM-DD)
- **Status:** Current status with interactive toggle button

#### Table Features:
- **DataTable Integration:** Advanced table with the following capabilities:
  - Pagination (25, 50, 100, 200, 500 records per page)
  - Search/Filter functionality across all columns
  - Sorting by any column
  - Responsive design for different screen sizes
  - Export options: Copy, CSV, Excel, PDF, Print
  - Information display showing record counts
  - Real-time filtering and searching

---

### 3. **Toggle Session Status (OPEN/CLOSED)**
Administrators can toggle the status of any session between OPEN and CLOSED directly from the table.

#### Status Indicators:
- **OPEN Status:** Displayed as a green button (success style)
  - Indicates the session is currently active
  - Applications or registrations can be processed
  - Students can interact with the system for this session

- **CLOSED Status:** Displayed as a red button (danger style)
  - Indicates the session is currently inactive
  - Applications or registrations are not accepted
  - Students cannot submit forms for this session

#### Toggle Operation:
1. Click on the status button (green for OPEN, red for CLOSED)
2. System automatically toggles the status:
   - OPEN → CLOSED
   - CLOSED → OPEN
3. Page refreshes to show the updated status
4. Change takes effect immediately across the entire system

#### Security Features:
- URL parameters are encrypted for security
- Session ID is encrypted before being passed in the URL
- Decryption occurs server-side before processing
- Prevents unauthorized manipulation of session status

---

## Important Instructions & Warnings

The page includes a collapsible instruction panel with critical warnings:

### Warning Messages:
1. **Irreversibility:** "This operation should be performed with high level of care as it will not be reversed thereafter."
   - Session changes are permanent
   - Cannot be undone once executed
   - Requires careful planning before implementation

2. **Authorization Required:** "The change of session Operation should be performed after due verification from the University Management"
   - Requires management approval
   - Should not be done without proper authorization
   - Institutional policy compliance required

3. **Dual Purpose:** "This operation is open for both Application and Registration"
   - Can manage both admission applications and student registrations
   - Each operates independently
   - Different timelines can be set for each operation

4. **Student Promotion:** "If it is a total change of session for registration, Student's classes will be promoted aside other operations"
   - Changing registration session triggers automatic student class promotion
   - Students are moved to the next academic level
   - Critical impact on student records
   - Affects academic progression tracking

---

## Session Management Concepts

### Session vs Semester vs Operation
Understanding the relationship between these three elements is crucial:

**Session:** The academic year (e.g., 2024/2025)
- Represents the full academic calendar year
- Typically runs from one year to the next

**Semester:** The subdivision of the session
- First Semester: Usually the first half of the academic year
- Second Semester: Usually the second half of the academic year
- Session: Represents the entire academic year without semester division

**Operation:** The type of activity being managed
- APPLICATION: For prospective students applying for admission
- REGISTRATION: For admitted students registering for courses

### Example Combinations:
1. **2024/2025 - First Semester - APPLICATION - School of Engineering**
   - Controls when prospective students can apply to Engineering for the first semester of 2024/2025

2. **2024/2025 - Session - REGISTRATION - School of Sciences**
   - Controls when admitted students in Sciences can register for the entire 2024/2025 session

3. **2025/2026 - Second Semester - APPLICATION - School of Arts**
   - Controls when prospective students can apply to Arts for the second semester of 2025/2026

---

## Practical Use Cases

### Use Case 1: Opening Applications for New Academic Session
**Scenario:** The university wants to start accepting applications for the 2025/2026 academic session for the School of Engineering.

**Steps:**
1. Navigate to changeofsession.jsp
2. Click "View instructions" to review warnings
3. Obtain management approval for opening applications
4. Select "2025/2026" from the Session dropdown
5. Select "Session" from the Semester dropdown (or "First" if only first semester)
6. Select "School of Engineering" from the Schools dropdown
7. Select "APPLICATION" from the Operation dropdown
8. Click "Create" button
9. Verify the new session appears in the table with OPEN status (green button)
10. Confirm with the admissions team that applications can now be received

### Use Case 2: Closing Applications After Deadline
**Scenario:** The application deadline has passed and no more applications should be accepted.

**Steps:**
1. Navigate to changeofsession.jsp
2. Locate the relevant session in the table (use search if needed)
3. Find the row with the correct School, Session, Semester, and Operation (APPLICATION)
4. Click the green "OPEN" button in the Status column
5. Button changes to red "CLOSED"
6. Applications are now blocked for that session
7. Notify the admissions team that applications are closed

### Use Case 3: Opening Registration for Admitted Students
**Scenario:** Students have been admitted and need to register for courses for the first semester.

**Steps:**
1. Navigate to changeofsession.jsp
2. Ensure management approval is obtained
3. Select the appropriate session (e.g., "2025/2026")
4. Select "First" from the Semester dropdown
5. Select the relevant school
6. Select "REGISTRATION" from the Operation dropdown
7. Click "Create" button
8. New registration session is created with OPEN status
9. Students can now proceed with course registration
10. Monitor registration progress through other system modules

### Use Case 4: Changing Session for Registration (Student Promotion)
**Scenario:** The academic year is ending and students need to be promoted to the next level.

**Steps:**
1. Navigate to changeofsession.jsp
2. Review the warning about student class promotion
3. Obtain explicit approval from university management
4. Verify all current semester activities are completed
5. Create a new registration session for the next academic year
6. Select "REGISTRATION" as the operation type
7. Click "Create" button
8. System automatically promotes students to the next class level
9. Verify student promotions in the student management module
10. Communicate the change to academic departments

### Use Case 5: Managing Multiple Schools with Different Timelines
**Scenario:** Different schools have different application and registration schedules.

**Steps:**
1. Navigate to changeofsession.jsp
2. Create separate sessions for each school:
   - School of Engineering: 2025/2026 - First - APPLICATION - OPEN
   - School of Sciences: 2025/2026 - Session - APPLICATION - OPEN
   - School of Arts: 2024/2025 - Second - REGISTRATION - OPEN
3. Each school operates independently
4. Use the table's search function to filter by school
5. Export school-specific reports using the Excel export feature
6. Monitor and toggle statuses as needed for each school

### Use Case 6: Auditing Session History
**Scenario:** Need to review all sessions created for compliance or reporting purposes.

**Steps:**
1. Navigate to changeofsession.jsp
2. Adjust table to show all records (select 500 from length menu)
3. Use search function to filter by:
   - Specific school
   - Specific session year
   - Operation type (APPLICATION or REGISTRATION)
   - Status (OPEN or CLOSED)
4. Click "Excel" or "PDF" export button
5. Save the exported file for audit documentation
6. Review the "Opened" dates to track when sessions were created

---

## Technical Features

### Data Export Capabilities
The page includes robust data export functionality:
- **Copy:** Copy table data to clipboard for quick sharing
- **CSV:** Export as comma-separated values for data analysis
- **Excel:** Export as Excel spreadsheet for reporting
- **PDF:** Generate PDF document for formal documentation
- **Print:** Print-friendly format for physical records

### User Interface Elements
- **Responsive Design:** Adapts to different screen sizes and devices
- **Bootstrap-based:** Modern, professional appearance with consistent styling
- **DataTables Integration:** Enhanced table functionality with sorting and filtering
- **Collapsible Instructions:** Important warnings can be shown/hidden as needed
- **Alert Messages:** Color-coded feedback (success in green, errors in red, warnings in yellow)
- **Form Validation:** Client and server-side validation to prevent errors
- **Interactive Status Buttons:** Visual indicators with click-to-toggle functionality

### Database Operations
The page performs the following database operations:
- `sess.getAllSessionmanager()` - Retrieves all session manager records
- `sess.getLatestSession()` - Gets the most recent session to calculate next sessions
- `sess.getAllSchoos()` - Retrieves all schools in the system
- `sess.newSessionmanager(smu)` - Creates a new session manager record
- `sess.getSessionmanager(id)` - Retrieves a specific session manager by ID
- `sess.updateSessionmanager(smu)` - Updates session manager status
- `settings.getSessionAfter()` - Calculates the next academic session
- `settings.getSessionsBefore()` - Generates list of upcoming sessions

### Security Mechanisms
- **Authentication Check:** Redirects unauthenticated users to login
- **URL Encryption:** All session IDs in URLs are encrypted
- **Parameter Decryption:** Server-side decryption before processing
- **Duplicate Prevention:** Validates against existing session combinations
- **Audit Trail:** Records creation date for all sessions

---

## Session Status Impact

### When Status is OPEN:
- **For APPLICATION Sessions:**
  - Prospective students can submit new applications
  - Application forms are accessible
  - Payment processing is enabled for application fees
  - Application data is accepted and stored

- **For REGISTRATION Sessions:**
  - Admitted students can register for courses
  - Course selection is enabled
  - Registration fees can be processed
  - Student records are updated with course enrollments

### When Status is CLOSED:
- **For APPLICATION Sessions:**
  - Application forms are disabled or hidden
  - Prospective students cannot submit new applications
  - Application deadline has passed
  - System may display "Applications Closed" message

- **For REGISTRATION Sessions:**
  - Course registration is disabled
  - Students cannot modify their course selections
  - Registration period has ended
  - Late registration may require special approval

---

## Best Practices & Recommendations

### Before Creating a Session:
1. **Obtain Approval:** Always get management authorization before creating sessions
2. **Verify Dates:** Confirm the academic calendar and important dates
3. **Check Existing Sessions:** Review the table to avoid duplicates
4. **Plan Ahead:** Create sessions in advance to allow for testing
5. **Communicate:** Inform relevant departments about upcoming session changes

### When Managing Session Status:
1. **Announce Changes:** Notify students and staff before closing sessions
2. **Grace Period:** Consider providing a grace period before closing
3. **Document Decisions:** Export session data before making changes
4. **Test First:** If possible, test with a single school before rolling out to all
5. **Monitor Impact:** Check system logs and user feedback after status changes

### For Student Promotion (Registration Session Change):
1. **Critical Operation:** This is the most critical operation on this page
2. **Backup Data:** Ensure database backups are current before proceeding
3. **Verify Completion:** Confirm all current semester activities are complete
4. **Management Approval:** Requires explicit approval from university leadership
5. **Timing:** Perform during low-traffic periods to minimize disruption
6. **Verification:** Immediately verify student promotions after execution
7. **Communication:** Inform students about their new class levels

### Regular Maintenance:
1. **Weekly Review:** Check session statuses weekly during active periods
2. **Export Reports:** Generate monthly reports of all sessions
3. **Clean Old Data:** Archive closed sessions from previous years
4. **Monitor Usage:** Track which sessions are most active
5. **Update Documentation:** Keep records of all session changes

---

## Common Scenarios & Solutions

### Scenario: Accidentally Created Wrong Session
**Problem:** Created a session with wrong parameters (wrong school, semester, or operation)
**Solution:** 
- The system does not provide a delete function for safety reasons
- Close the incorrect session immediately (set status to CLOSED)
- Create the correct session with proper parameters
- Document the error for audit purposes
- The closed session will remain in the system but will not affect operations

### Scenario: Need to Reopen a Closed Session
**Problem:** Session was closed prematurely and needs to be reopened
**Solution:**
- Locate the session in the table
- Click the red "CLOSED" button
- Status toggles back to "OPEN" (green button)
- Verify the change took effect
- Notify affected users that the session is open again

### Scenario: Multiple Schools Need Same Session
**Problem:** Need to open applications for multiple schools for the same academic session
**Solution:**
- Create separate session records for each school
- Use the same session year and semester
- Select different schools for each creation
- Each school's session can be managed independently
- Use table filters to view school-specific sessions

### Scenario: Unsure Which Sessions Are Currently Active
**Problem:** Need to quickly identify all active (OPEN) sessions
**Solution:**
- Use the DataTable search function
- Type "OPEN" in the search box
- Table filters to show only open sessions
- Export the filtered results for reference
- Review by school and operation type

---

## Important Notes for Administrators

1. **Irreversible Operations:** Session creation and student promotion cannot be undone. Exercise extreme caution.

2. **Management Approval Required:** Never create or change sessions without proper authorization from university management.

3. **Student Promotion Impact:** Changing registration sessions automatically promotes students to the next class level. This affects:
   - Student academic records
   - Class assignments
   - Course eligibility
   - Graduation tracking

4. **School-Specific Sessions:** Each school can have its own session timeline. Ensure you select the correct school when creating sessions.

5. **Operation Independence:** APPLICATION and REGISTRATION sessions are independent. Closing applications does not affect registration and vice versa.

6. **No Delete Function:** Sessions cannot be deleted once created. They can only be closed. This is by design for audit trail purposes.

7. **Immediate Effect:** Status changes (OPEN/CLOSED) take effect immediately across the entire system.

8. **Semester Flexibility:** The "Session" semester option allows managing the entire academic year without semester divisions.

9. **Date Tracking:** The "Opened" date records when the session was created, not when it was set to OPEN status.

10. **Encrypted URLs:** All status toggle operations use encrypted URLs. Do not attempt to manually construct these URLs.

---

## Training Summary

During today's training session, the client was introduced to the **Session Manager** functionality, which serves as the central control system for managing academic sessions across the institution. The key takeaways include:

- Understanding the critical nature of session management and its impact on the entire system
- Ability to create new sessions for applications and registrations
- Managing session status (OPEN/CLOSED) to control when operations are available
- Recognizing the relationship between sessions, semesters, operations, and schools
- Understanding the automatic student promotion feature when changing registration sessions
- Using the table interface to monitor and audit all session records
- Leveraging export features for documentation and compliance
- Following best practices to prevent errors and ensure smooth operations

This page is essential for controlling the academic calendar and ensuring that applications and registrations occur during the appropriate time periods. It requires careful management and should only be operated by authorized administrators with proper training.

---

## Critical Warnings Recap

⚠️ **CRITICAL:** Session changes, especially for REGISTRATION operations, trigger automatic student class promotions. This cannot be reversed.

⚠️ **AUTHORIZATION:** Always obtain university management approval before creating or changing sessions.

⚠️ **PLANNING:** Plan session changes well in advance and communicate with all stakeholders.

⚠️ **VERIFICATION:** After creating or changing sessions, verify the impact across the system.

⚠️ **BACKUP:** Ensure database backups are current before performing critical operations.

---

**Report Prepared By:** Training Team  
**Page Analyzed:** changeofsession.jsp  
**System:** EduPortal v1.0  
**Classification:** Critical Administrative Function
