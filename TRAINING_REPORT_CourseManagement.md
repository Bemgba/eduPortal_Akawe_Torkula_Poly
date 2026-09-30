# Training Activity Report - Course Management
**Date:** February 12, 2026  
**Client:** EduPortal  
**Pages/Modules:** 
- adminCourseManagement.jsp (Programme/Course Management)
- adminmanagesemcourses.jsp (Semester Courses Overview)
- adminListSemCourses.jsp (Semester Courses Details)

---

## Overview
The **Course Management** module consists of three interconnected pages that provide comprehensive management of academic programmes and courses within the EduPortal system. This module allows administrators to:
1. Manage academic programmes (degree programs) with their properties
2. Manage semester courses that students can register for
3. Control course activation/deactivation and registration availability

These pages are critical for academic operations as they define what students can study and register for each semester.

---

## Page Access & Security
- **Access Control:** All pages are protected and require user authentication
- **User Type:** Accessible only to staff members with appropriate administrative privileges
- **URL Paths:** 
  - Programme Management: `/course_management`
  - Semester Courses Overview: `/manage_sem_courses`
  - Semester Courses Details: `/list_sem_courses`
- **Authorization Level:** High-level academic administrative access required

---

## Module Structure

### Three-Page Workflow:

1. **adminCourseManagement.jsp** - Programme/Course Management
   - Manages academic programmes (degree programs)
   - Defines programme properties, duration, level ranges
   - Associates programmes with schools, departments, and heads

2. **adminmanagesemcourses.jsp** - Semester Courses Overview
   - Provides overview of all programmes and their course counts
   - Shows active and inactive course statistics per programme
   - Entry point for managing semester courses

3. **adminListSemCourses.jsp** - Semester Courses Details
   - Detailed management of semester courses for a specific programme
   - Add, edit, delete, activate, and deactivate courses
   - View students taking each course

---

## PART 1: Programme/Course Management (adminCourseManagement.jsp)

### 1. **View All Academic Programmes**

The page displays a comprehensive table of all academic programmes in the system.

#### Table Columns:
- **# (Serial Number):** Sequential numbering
- **Programme Code:** Short code identifying the programme
- **Programme Name:** Full name of the academic programme
- **Programme Type:** School and Programme type (e.g., "School of Sciences - Undergraduate")
- **Department:** Department managing the programme
- **Duration (Semester):** Total duration in semesters
- **Level Range:** Minimum and maximum levels (e.g., "100 - 400")
- **Actions:** Edit and Delete buttons

#### Table Features:
- DataTable integration with search, sort, and pagination
- Export options: Copy, CSV, Excel, PDF, Print
- Pagination: 25, 50, 100, 200, 500 records per page
- Responsive design

---

### 2. **Add New Academic Programme**

Administrators can create new academic programmes through a modal dialog.

#### Modal Dialog: "Add New Course" Button

**Form Fields:**

**a) Course Code** (Required)
- Text input for programme code
- Short identifier (e.g., "BSC-CS", "MSC-ENG")
- Used for quick reference

**b) Course Name** (Required)
- Text input for full programme name
- Example: "Bachelor of Science in Computer Science"
- Descriptive name displayed to students

**c) School/Programme** (Required)
- Dropdown combining school and programme type
- Format: "School Name - Programme Type"
- Example: "School of Sciences - Undergraduate"
- Defines the academic unit and level

**d) Department** (Required)
- Dropdown with all departments
- Dynamically loaded based on selected school/programme
- Assigns administrative responsibility
- AJAX-powered: Updates when school/programme changes

**e) Head of Department**
- Dropdown with all staff members
- Optional field
- Assigns programme coordinator/head
- Shows staff username

**f) Head Title**
- Dropdown with position titles
- Optional field
- Defines the official title of the head
- Example: "Programme Coordinator", "Head of Department"

**g) Min Level**
- Numeric input (100-900)
- Defines the starting level for the programme
- Example: 100 for undergraduate, 500 for postgraduate
- Optional field

**h) Max Level**
- Numeric input (100-900)
- Defines the final level for the programme
- Example: 400 for 4-year undergraduate, 600 for 2-year postgraduate
- Optional field

**i) Max Spill**
- Numeric input (minimum 0)
- Defines maximum spillover years allowed
- Controls how long students can remain in the programme
- Optional field

**j) Duration (Semesters)**
- Numeric input (1-10)
- Total number of semesters for the programme
- Example: 8 for 4-year programme, 4 for 2-year programme
- Optional field

**k) Entry Requirements**
- Textarea for detailed entry requirements
- Multi-line text input
- Describes admission criteria
- Example: "5 O'Level credits including Mathematics and English"
- Optional field

**Save Button:** Creates the new programme

---

### 3. **Edit Existing Programme**

Each programme has an "Edit" button that opens the same modal with pre-filled data.

**Edit Process:**
1. Click "Edit" button on any programme row
2. Modal opens with all current programme data
3. Modify any fields as needed
4. Click "Save Course" button
5. Programme is updated in the database
6. Success message: "Course updated successfully"

**Dynamic Department Loading:**
- When school/programme is changed during edit
- Department dropdown automatically updates
- Shows only departments relevant to the selected school
- Prevents invalid school-department combinations

---

### 4. **Delete Programme**

Each programme has a "Delete" button with confirmation dialog.

**Delete Process:**
1. Click "Delete" button on any programme row
2. Confirmation dialog appears: "Are you sure you want to delete the course '[Programme Name]'? This action cannot be undone."
3. Click OK to confirm or Cancel to abort
4. If confirmed, programme is deleted from database
5. Success message: "Course deleted successfully"

**Important Notes:**
- Deletion is permanent and cannot be undone
- May fail if programme has associated records (students, courses, etc.)
- Error message displayed if deletion fails due to constraints



---

## PART 2: Semester Courses Overview (adminmanagesemcourses.jsp)

### 5. **View Programme Course Statistics**

The page displays a summary table of all programmes with their course counts.

#### Table Columns:
- **# (Serial Number):** Sequential numbering
- **Programme:** Full name of the academic programme
- **Active Courses:** Number of courses currently available for student registration
- **In-Active Courses:** Number of courses not available for registration
- **Details:** Button to view and manage courses for that programme

#### Purpose:
- Quick overview of course availability across all programmes
- Identify programmes with no active courses
- Monitor course activation status
- Entry point for detailed course management

---

### 6. **Add New Semester Course (Quick Add)**

The page provides a quick-add modal for creating semester courses.

#### Modal Dialog: "Add New" Button

**Form Fields:**

**a) Select Programme** (Required)
- Dropdown with all programmes
- Determines which programme the course belongs to
- Required for course creation

**b) Enter Course Code** (Required)
- Text input for course code
- Minimum 3 characters
- Automatically converted to uppercase
- Example: "CSC101", "MTH201"
- Must be unique within the programme

**c) Enter Course Name** (Required)
- Text input for course name
- Minimum 3 characters
- Example: "Introduction to Computer Science"
- Descriptive name shown to students

**d) Default Semester**
- Dropdown with options:
  - **First:** First semester course
  - **Second:** Second semester course
- Can be adjusted later
- Determines when course is typically offered

**e) Default Level** (Required)
- Numeric input (100-900)
- 3-digit level code
- Example: 100, 200, 300, 400, 500
- Determines which students can take the course

**f) Credit Units** (Required)
- Numeric input (minimum 0)
- Number of credit units for the course
- Used for GPA calculation and graduation requirements

**Add Now Button:** Creates the course with status "ACTIVE"

#### Validation:
- **Duplicate Check:** System checks if course code already exists in the programme
- **Error Message:** "Course code [CODE] is already added to this programme"
- **Success Message:** "Course code [CODE] has been added successfully"

#### Automatic Properties:
- Status: Automatically set to "ACTIVE"
- Category: Automatically set to "CCMAS"
- Course is immediately available for student registration

---

### 7. **Navigate to Programme Course Details**

Each programme row has a "Details" button.

**Navigation Process:**
1. Click "Details" button for any programme
2. System stores programme information in session
3. Redirects to `/list_sem_courses` (adminListSemCourses.jsp)
4. Shows detailed course management for that specific programme

**URL Parameters:**
- Encrypted programme ID and status (ACTIVE or INACTIVE)
- Security: Parameters are encrypted to prevent tampering

---

### 8. **Quick Navigation Buttons**

The page header provides quick access to related functions:

**a) Manage Programmes Button** (Blue/Info)
- Links to `/course_management`
- Opens the programme management page (adminCourseManagement.jsp)
- Allows creating and editing programmes

**b) Credit Unit Controls Button** (Blue/Info)
- Links to `/credit_unit_controls`
- Opens credit unit management interface
- Controls minimum/maximum credit units per semester

**c) Registration Controls Button** (Yellow/Warning)
- Links to `/sem_reg_courses`
- Opens course registration control interface
- Manages which courses are available for registration

---

## PART 3: Semester Courses Details (adminListSemCourses.jsp)

### 9. **View Active and Inactive Courses**

The page displays courses in two tabs: Active and Inactive.

#### Tab 1: Active Courses
"These courses are registrable by students"

**Table Columns:**
- **# (Serial Number):** Sequential numbering
- **Course Code:** Short code (e.g., "CSC101")
- **Course Name:** Full course name
- **Credit Unit:** Number of credit units
- **Semester:** First, Second, or BOTH
- **Level:** Default level (100, 200, 300, etc.)
- **Used By:** Number of students currently taking the course (clickable)
- **Actions:** Edit, Delete, Deactivate buttons

#### Tab 2: Inactive Courses
"These courses are not registrable by students but can be used for result processing and transcript."

**Table Columns:**
- Same as Active Courses tab
- **Actions:** Edit, Delete, Activate buttons (instead of Deactivate)

#### Table Features (Both Tabs):
- Separate DataTables for each tab
- Independent search and filtering
- Export options: Copy, CSV, Excel, PDF, Print
- Pagination: 25, 50, 100, 200, 500 records per page

---

### 10. **Add New Semester Course (Detailed)**

The "Add New Course" button opens a comprehensive modal dialog.

#### Modal Dialog Form Fields:

**a) Course Code** (Required)
- Text input, maximum 15 characters
- Automatically converted to uppercase
- Must be unique within the programme
- Example: "CSC101", "MTH201"

**b) Credit Unit**
- Numeric input (1-10)
- Number of credit units
- Used for GPA and graduation calculations

**c) Course Name** (Required)
- Text input, maximum 150 characters
- Full descriptive name
- Example: "Introduction to Computer Science"

**d) Semester**
- Dropdown with options:
  - **1:** First Semester
  - **2:** Second Semester
  - **BOTH:** Both Semesters
- Determines when course is offered

**e) Default Level**
- Dropdown with options:
  - 100 Level
  - 200 Level
  - 300 Level
  - 400 Level
  - 500 Level
  - 600 Level
- Determines which students can register

**f) Course Category**
- Dropdown with options:
  - **CORE:** Core Course (required for all students)
  - **ELECTIVE:** Elective Course (optional)
  - **GENERAL:** General Studies (university-wide requirements)
  - **PRACTICAL:** Practical Course (lab/workshop)
- Classifies the course type

**g) Note**
- Textarea, maximum 200 characters
- Additional information about the course
- Optional field

**Save Course Button:** Creates or updates the course

---

### 11. **Edit Semester Course**

Each course has an "Edit" button that opens the modal with pre-filled data.

**Edit Process:**
1. Click "Edit" button on any course row
2. Modal opens with all current course data
3. Modify any fields as needed
4. Click "Save Course" button
5. Course is updated in the database
6. Success message: "Semester course '[Course Name]' has been updated successfully!"

**Validation:**
- Duplicate course code check (if code is changed)
- Error message if code already exists
- All required fields must be filled

---

### 12. **Delete Semester Course**

Each course has a "Delete" button with confirmation and usage check.

**Delete Process:**
1. Click "Delete" button on any course row
2. Confirmation dialog: "Are you sure you want to delete the semester course '[Course Name]'? This action cannot be undone."
3. System checks if course is being used by students
4. If course is in use:
   - Warning message: "Cannot delete course '[Course Name]': It is currently being used by [X] student(s)."
   - Deletion is prevented
5. If course is not in use:
   - Course is deleted
   - Success message: "Semester course '[Course Name]' has been deleted successfully!"
   - Page refreshes to show updated list

**Safety Features:**
- Prevents deletion of courses with student registrations
- Shows number of affected students
- Confirmation dialog prevents accidental deletion
- Permanent deletion (cannot be undone)

---

### 13. **Activate/Deactivate Courses**

Courses can be toggled between ACTIVE and INACTIVE status.

#### Deactivate Course (From Active Tab):
1. Click yellow "Deactivate" button on any active course
2. Course status changes to INACTIVE
3. Course moves to Inactive Courses tab
4. Students can no longer register for this course
5. Existing registrations remain intact

#### Activate Course (From Inactive Tab):
1. Click green "Activate" button on any inactive course
2. Course status changes to ACTIVE
3. Course moves to Active Courses tab
4. Students can now register for this course

**Use Cases for Deactivation:**
- Course is temporarily not offered
- Course is being revised or updated
- Course has been replaced by a new version
- Semester has ended and course is not offered next semester

**Important Notes:**
- Deactivation does not delete the course
- Inactive courses can still be used for result processing
- Inactive courses appear on transcripts
- Activation/deactivation is instant (no confirmation dialog)

---

### 14. **View Students Taking a Course**

The "Used By" column shows the number of students taking each course.

**View Process:**
1. Click on the number in the "Used By" column
2. Modal dialog opens with title: "List of Courses offering [Course Name] ([Course Code])"
3. System loads student data via AJAX
4. Displays list of students registered for the course
5. Shows loading indicator while data is being fetched

**AJAX Loading:**
- Function: `getCoursesTakingsemco()`
- Fetches data from: `AjaxServlet?action=getCoursesTakingsemco`
- Dynamic loading prevents page reload
- Error handling displays message if loading fails

**Purpose:**
- Monitor course enrollment
- Identify popular courses
- Check if course can be safely deleted
- Verify student registrations



---

## Practical Use Cases

### Use Case 1: Creating a New Academic Programme
**Scenario:** The university is launching a new "Bachelor of Science in Data Science" programme.

**Steps:**
1. Navigate to `/course_management` (adminCourseManagement.jsp)
2. Click "Add New Course" button
3. Fill in the form:
   - Course Code: "BSC-DS"
   - Course Name: "Bachelor of Science in Data Science"
   - School/Programme: "School of Sciences - Undergraduate"
   - Department: Select "Computer Science" (loads after school selection)
   - Head of Department: Select programme coordinator
   - Head Title: "Programme Coordinator"
   - Min Level: 100
   - Max Level: 400
   - Max Spill: 2
   - Duration: 8 semesters
   - Entry Requirements: "5 O'Level credits including Mathematics, English, and Physics"
4. Click "Save Course"
5. Verify success message
6. Programme appears in the table
7. Navigate to semester courses to add courses for this programme

---

### Use Case 2: Adding Semester Courses to a Programme
**Scenario:** Need to add first semester courses for 100 level Data Science students.

**Steps:**
1. Navigate to `/manage_sem_courses` (adminmanagesemcourses.jsp)
2. Locate "Bachelor of Science in Data Science" in the table
3. Click "Details" button
4. On the details page, click "Add New Course" button
5. Fill in the form for each course:
   
   **Course 1:**
   - Course Code: "CSC101"
   - Course Name: "Introduction to Computer Science"
   - Credit Unit: 3
   - Semester: 1 (First Semester)
   - Default Level: 100
   - Course Category: CORE
   - Click "Save Course"
   
   **Course 2:**
   - Course Code: "MTH101"
   - Course Name: "General Mathematics I"
   - Credit Unit: 3
   - Semester: 1
   - Default Level: 100
   - Course Category: CORE
   - Click "Save Course"
   
   **Course 3:**
   - Course Code: "PHY101"
   - Course Name: "General Physics I"
   - Credit Unit: 3
   - Semester: 1
   - Default Level: 100
   - Course Category: CORE
   - Click "Save Course"

6. Verify all courses appear in the Active Courses tab
7. Courses are now available for student registration

---

### Use Case 3: Editing Programme Duration
**Scenario:** Programme duration needs to be changed from 8 to 10 semesters.

**Steps:**
1. Navigate to `/course_management`
2. Locate the programme in the table
3. Click "Edit" button
4. Change "Duration (Semesters)" from 8 to 10
5. Click "Save Course"
6. Success message: "Course updated successfully"
7. Verify the change in the table (Duration column shows 10)

---

### Use Case 4: Deactivating a Course Temporarily
**Scenario:** A course is not being offered this semester due to staff unavailability.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the relevant programme
3. Locate the course in the Active Courses tab
4. Click yellow "Deactivate" button
5. Course immediately moves to Inactive Courses tab
6. Students can no longer register for this course
7. Existing student registrations remain intact
8. Course can be reactivated when staff becomes available

---

### Use Case 5: Checking Course Enrollment
**Scenario:** Need to verify how many students are taking a specific course.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the programme
3. Locate the course in the Active Courses tab
4. Look at the "Used By" column (shows number)
5. Click on the number
6. Modal opens showing list of students
7. Review student enrollment
8. Close modal when done

---

### Use Case 6: Deleting an Obsolete Course
**Scenario:** A course has been replaced and is no longer needed.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the programme
3. Locate the course (check both Active and Inactive tabs)
4. Click "Delete" button
5. Confirmation dialog appears
6. System checks if students are taking the course
7. If no students: Course is deleted, success message appears
8. If students exist: Warning message shows number of students, deletion is prevented
9. If deletion is prevented, deactivate the course instead

---

### Use Case 7: Updating Course Credit Units
**Scenario:** University policy changes require updating credit units for a course.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the programme
3. Locate the course in the table
4. Click "Edit" button
5. Change "Credit Unit" field to new value
6. Click "Save Course"
7. Success message appears
8. Verify the change in the table
9. New credit unit applies to future registrations
10. Existing student registrations may need manual adjustment

---

### Use Case 8: Adding an Elective Course
**Scenario:** Adding an optional elective course for 300 level students.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the programme
3. Click "Add New Course" button
4. Fill in the form:
   - Course Code: "CSC301E"
   - Course Name: "Mobile Application Development"
   - Credit Unit: 3
   - Semester: 2 (Second Semester)
   - Default Level: 300
   - Course Category: ELECTIVE
   - Note: "Optional course for students interested in mobile development"
5. Click "Save Course"
6. Course appears in Active Courses tab
7. Students can choose to register for this elective

---

### Use Case 9: Managing Courses Across Multiple Programmes
**Scenario:** Need to add the same course to multiple programmes (e.g., General Studies).

**Steps:**
1. Navigate to `/manage_sem_courses`
2. For each programme:
   - Click "Details" button
   - Click "Add New Course"
   - Enter course details (same code, name, credit unit)
   - Save course
   - Return to overview
3. Repeat for all programmes
4. Each programme now has the course independently
5. Changes to one programme's course don't affect others

---

### Use Case 10: Exporting Course List for Review
**Scenario:** Department head wants to review all courses in Excel.

**Steps:**
1. Navigate to `/manage_sem_courses`
2. Click "Details" for the programme
3. Click on "Active Courses" tab
4. Click "Excel" button in the DataTable toolbar
5. Excel file downloads with all active courses
6. Repeat for "Inactive Courses" tab if needed
7. Send files to department head for review
8. Make adjustments based on feedback

---

## Technical Features

### AJAX Dynamic Loading
- **Department Loading:** When school/programme is selected, departments are loaded dynamically
- **Student List Loading:** When "Used By" is clicked, student data is fetched asynchronously
- **Prevents Page Reload:** Smooth user experience without full page refreshes

### Session Management
- Selected programme is stored in HTTP session
- Allows navigation between pages without losing context
- Validates session data before displaying details

### Data Validation
- **Client-side:** HTML5 form validation (required fields, min/max values, maxlength)
- **Server-side:** Validates all inputs before database operations
- **Duplicate Check:** Prevents duplicate course codes within a programme
- **Usage Check:** Prevents deletion of courses with student registrations

### Database Operations
**Programme Management:**
- `sess.getAllCourses()` - Retrieves all programmes
- `sess.getSingleObject(Courses.class, id)` - Retrieves specific programme
- `sess.newEntry(course)` - Creates new programme
- `sess.updateObject(course)` - Updates programme
- `sess.deleteObject(course)` - Deletes programme

**Semester Course Management:**
- `sess.getAllProgrammes()` - Retrieves all programmes
- `sess.getAllSemestercoursesByStatusAndProgramme()` - Retrieves courses by status
- `sess.getSemestercoursesByCodeAndProgramme()` - Checks for duplicate codes
- `sess.newEntry(semestercourse)` - Creates new semester course
- `sess.updateRecord(semestercourse)` - Updates semester course
- `sess.deleteSemestercourses(id)` - Deletes semester course
- `sess.updateSemesterCourseStatus()` - Activates/deactivates course
- `sess.getSemesterregistrationcoursesBySemestercourseid()` - Gets students taking course

### Security Mechanisms
- **Authentication Check:** Redirects unauthenticated users
- **URL Encryption:** Programme IDs and status are encrypted in URLs
- **Parameter Decryption:** Server-side decryption before processing
- **Session Validation:** Validates required session attributes
- **SQL Injection Prevention:** Uses parameterized queries

### User Interface Elements
- **Modal Dialogs:** For adding and editing programmes/courses
- **Tab Interface:** Separates active and inactive courses
- **Confirmation Dialogs:** For delete operations
- **DataTables Integration:** Advanced table features
- **Responsive Design:** Works on different screen sizes
- **Bootstrap Styling:** Professional, consistent appearance
- **Alert Messages:** Color-coded feedback (success, danger, warning)

---

## Important Concepts

### Programme vs Semester Course

**Programme (Course in adminCourseManagement.jsp):**
- A degree program (e.g., "Bachelor of Science in Computer Science")
- Defines the overall academic path
- Has duration, level range, entry requirements
- Contains multiple semester courses

**Semester Course (in adminmanagesemcourses.jsp):**
- Individual courses within a programme
- What students actually register for each semester
- Has course code, credit units, level, semester
- Example: "CSC101 - Introduction to Computer Science"

### Active vs Inactive Status

**Active Courses:**
- Available for student registration
- Appear in course registration interface
- Students can add these courses to their semester registration
- Counted towards credit unit limits

**Inactive Courses:**
- Not available for student registration
- Hidden from course registration interface
- Still exist in the system for historical records
- Can be used for result processing and transcripts
- Can be reactivated when needed

### Course Categories

**CORE:**
- Required courses for all students in the programme
- Must be taken to graduate
- Usually programme-specific

**ELECTIVE:**
- Optional courses students can choose from
- Provide specialization options
- Students select based on interest

**GENERAL:**
- University-wide requirements
- General Studies courses
- Required for all students regardless of programme

**PRACTICAL:**
- Lab, workshop, or practical courses
- Hands-on learning components
- May have different assessment methods

---

## Best Practices & Recommendations

### Programme Management:
1. **Complete Information:** Fill all fields when creating programmes
2. **Consistent Naming:** Use standard naming conventions for codes
3. **Verify Department:** Ensure correct department is selected
4. **Set Level Ranges:** Define min/max levels accurately
5. **Document Requirements:** Provide detailed entry requirements

### Semester Course Management:
1. **Unique Codes:** Ensure course codes are unique within each programme
2. **Accurate Credit Units:** Verify credit units match university policy
3. **Correct Levels:** Assign courses to appropriate levels
4. **Proper Categories:** Classify courses correctly (CORE, ELECTIVE, etc.)
5. **Regular Review:** Periodically review active/inactive courses

### Course Activation:
1. **Plan Ahead:** Activate courses before registration period
2. **Communicate Changes:** Notify students of course availability
3. **Check Enrollment:** Monitor "Used By" numbers
4. **Deactivate Unused:** Deactivate courses not being offered
5. **Keep Records:** Don't delete courses with historical data

### Data Management:
1. **Export Regularly:** Export course lists for backup
2. **Review Before Delete:** Always check usage before deleting
3. **Test Changes:** Verify changes in a test environment if possible
4. **Document Decisions:** Keep records of why courses were added/removed
5. **Coordinate with Departments:** Consult with academic departments

---

## Common Scenarios & Solutions

### Scenario: Cannot Delete Programme
**Problem:** Delete button fails with constraint error.
**Solution:** 
- Programme has associated semester courses or students
- First deactivate all semester courses
- Move students to another programme
- Then delete the programme
- Or keep programme as inactive instead of deleting

### Scenario: Duplicate Course Code Error
**Problem:** "A course with code 'CSC101' already exists in this programme."
**Solution:**
- Check if course already exists in Active or Inactive tab
- If it exists and is inactive, activate it instead
- If you need a new course, use a different code (e.g., "CSC101A")
- If it's truly a duplicate, edit the existing course instead

### Scenario: Students Cannot Register for Course
**Problem:** Course doesn't appear in student registration interface.
**Solution:**
- Check if course is in Active Courses tab
- If inactive, click "Activate" button
- Verify course level matches student's current level
- Check if course semester matches current registration semester
- Ensure registration period is open

### Scenario: Need to Change Course from First to Second Semester
**Problem:** Course was created for wrong semester.
**Solution:**
- Click "Edit" button on the course
- Change "Semester" dropdown to correct value
- Click "Save Course"
- Change applies immediately
- Students registered for wrong semester may need manual adjustment

### Scenario: Course Has Wrong Credit Units
**Problem:** Course was created with incorrect credit units.
**Solution:**
- Click "Edit" button on the course
- Change "Credit Unit" field
- Click "Save Course"
- New value applies to future registrations
- Existing student registrations keep old value
- May need to manually update existing registrations

---

## Important Notes for Administrators

1. **Programme vs Course Terminology:** In adminCourseManagement.jsp, "Course" refers to academic programmes (degree programs), not individual courses.

2. **No Edit for Quick Add:** Courses added via quick-add modal in adminmanagesemcourses.jsp have limited fields. Use the detailed page for full control.

3. **Deletion is Permanent:** Deleted programmes and courses cannot be recovered. Always verify before deleting.

4. **Active Status Required:** Only active courses appear in student registration interface.

5. **Department Required:** Programmes must have a department assigned. This is enforced during creation.

6. **Unique Course Codes:** Course codes must be unique within each programme but can be duplicated across different programmes.

7. **Credit Unit Limits:** Ensure credit units comply with university policy and credit unit controls.

8. **Level Matching:** Students can only see courses matching their current level (with some spillover allowance).

9. **Semester Matching:** Courses are filtered by semester during registration periods.

10. **Historical Data:** Inactive courses are kept for historical records, transcripts, and result processing.

---

## Training Summary

During today's training session, the client was introduced to the **Course Management** module, which consists of three interconnected pages for managing academic programmes and semester courses. The key takeaways include:

- Understanding the difference between programmes (degree programs) and semester courses
- Ability to create and manage academic programmes with all properties
- Managing semester courses including creation, editing, and deletion
- Controlling course availability through activation/deactivation
- Monitoring course enrollment and student usage
- Understanding active vs inactive course status
- Using course categories (CORE, ELECTIVE, GENERAL, PRACTICAL)
- Navigating between the three pages in the workflow
- Exporting course data for review and documentation
- Following best practices for course management

This module is essential for academic operations as it defines the structure of academic programmes and controls what courses students can register for each semester.

---

## Critical Warnings Recap

⚠️ **DELETION IS PERMANENT:** Deleted programmes and courses cannot be recovered. Always verify before deleting.

⚠️ **CHECK USAGE BEFORE DELETE:** System prevents deletion of courses with student registrations, but always check first.

⚠️ **DEPARTMENT REQUIRED:** Programmes must have a department assigned. Creation will fail without it.

⚠️ **UNIQUE CODES:** Course codes must be unique within each programme to avoid conflicts.

⚠️ **ACTIVE STATUS:** Only active courses are available for student registration. Inactive courses are hidden.

⚠️ **CREDIT UNITS:** Ensure credit units comply with university policy and graduation requirements.

⚠️ **COORDINATE CHANGES:** Always coordinate course changes with academic departments and notify students.

---

**Report Prepared By:** Training Team  
**Pages Analyzed:** 
- adminCourseManagement.jsp (Programme Management)
- adminmanagesemcourses.jsp (Semester Courses Overview)
- adminListSemCourses.jsp (Semester Courses Details)  
**System:** EduPortal v1.0  
**Classification:** Critical Academic Management Function
