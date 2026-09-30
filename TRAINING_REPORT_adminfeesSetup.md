# Training Activity Report - adminfeesSetup.jsp
**Date:** February 12, 2026  
**Client:** EduPortal  
**Page/Module:** Fees Setup (adminfeesSetup.jsp & adminFeesSetupDetails.jsp)

---

## Overview
The **adminfeesSetup.jsp** page is a critical administrative interface for managing student fees within the EduPortal system. This page serves as the entry point for configuring fees across different schools, sessions, semesters, and fee groups. It provides administrators with a sophisticated fee management system that allows granular control over fee structures at multiple organizational levels (Faculty, Department, and Course).

---

## Page Access & Security
- **Access Control:** The page is protected and requires user authentication. Unauthenticated users are automatically redirected to the login page.
- **User Type:** This page is accessible only to staff members with appropriate administrative privileges.
- **URL Paths:** 
  - Entry Page: `/fees_setup`
  - Details Page: `/admin_fees_details`
- **Authorization Level:** High-level administrative access required due to the financial nature of fee management

---

## Two-Page Workflow

The fees setup functionality operates across two interconnected pages:

1. **adminfeesSetup.jsp** - Selection/Filter Page
   - Allows administrators to select the context for fee setup
   - Acts as a gateway to the detailed fee configuration page

2. **adminFeesSetupDetails.jsp** - Configuration Page
   - Displays and manages actual fee configurations
   - Provides detailed fee setup at multiple organizational levels

---

## Core Functionality - Page 1: adminfeesSetup.jsp

### 1. **Fee Context Selection**
This is the primary function of the entry page - selecting the context for fee configuration.

#### Selection Form Fields:

**a) Select School**
- Dropdown menu displaying all schools in the system
- Each school can have its own fee structure
- Dynamically loads related data when selected
- Required field for proceeding to fee setup

**b) Payment Item (Fee Group)**
- Dropdown menu populated dynamically based on selected school
- Displays fee groups/categories (e.g., "SCHOOL FEES", "APPLICATION FEES", etc.)
- Loaded via AJAX when school is selected
- Represents the category of fees being configured
- Required field for proceeding

**c) Session**
- Dropdown menu populated dynamically based on selected school and payment item
- Displays available academic sessions (e.g., "2024/2025", "2025/2026")
- Loaded via AJAX when school is selected
- Determines which academic year the fees apply to
- Required field for proceeding

**d) Semester**
- Three options available:
  - **First:** First semester fees
  - **Second:** Second semester fees
  - **Session:** Full academic session fees
- Determines the time period for fee application
- Required field for proceeding

#### Dynamic Loading Features:
The page uses AJAX to provide a seamless user experience:

1. **When School is Selected:**
   - JavaScript function `loadItems()` is triggered
   - Makes AJAX call to `AjaxServlet?action=loadItemsAndSessions`
   - Populates both "Payment Item" and "Session" dropdowns
   - Ensures only relevant fee groups and sessions are displayed

2. **When Payment Item is Selected:**
   - JavaScript function `loadSesssem()` is triggered
   - Makes AJAX call to `AjaxServlet?action=loadsesssem`
   - Updates semester options based on fee group configuration
   - Ensures semester selection matches fee group requirements

#### Navigation Button:
- **"Manage Fee Groups" Button** (Blue/Info button)
  - Located in the card header
  - Links to `/create_fees_group`
  - Allows administrators to create and manage fee group categories
  - Opens fee group management interface

#### View Button:
- **"View" Button** (Primary/Blue button)
  - Submits the selection form
  - Stores selected values in session attributes
  - Redirects to `/admin_fees_details` (adminFeesSetupDetails.jsp)
  - Passes context to the detailed configuration page

---

## Core Functionality - Page 2: adminFeesSetupDetails.jsp

### 2. **Add Fees at Multiple Organizational Levels**

The details page provides three distinct scopes for fee configuration, each with its own modal dialog:

#### A. Faculty Scope Fee Setup

**Purpose:** Configure fees that apply to entire faculties or across all faculties.

**Modal Dialog Fields:**

1. **Select Faculty**
   - Dropdown with all faculties/directorates
   - Special option: "None (Applicable across all faculties)"
   - Selecting "None" makes the fee apply university-wide

2. **Select Sub Item**
   - Dropdown with all fee items (e.g., "Tuition", "Library Fee", "Lab Fee")
   - Breaks down the fee group into specific components
   - Required field

3. **Enter Level**
   - Numeric input for student level (0-900)
   - Leave empty: Applies to all levels
   - Enter 0: Level not applicable (e.g., for application fees)
   - Enter specific level (e.g., 100, 200, 300): Applies only to that level

4. **Indigene Status**
   - Options:
     - **indigene:** Applies only to indigenes (local students)
     - **non_indigene:** Applies only to non-indigenes
     - **All:** Applies to both indigenes and non-indigenes
     - **None:** Not applicable (status doesn't matter)
   - Allows differential pricing based on student origin

5. **Effective Date**
   - Date picker with minimum date set to today
   - Determines when the fee becomes active
   - Allows future-dated fee changes

6. **Amount**
   - Numeric input for fee amount
   - Minimum value: 300
   - Required field
   - Formatted with currency notation in display

**Add Button:** Submits the faculty scope fee configuration

---

#### B. Department Scope Fee Setup

**Purpose:** Configure fees that apply to specific departments or across all departments.

**Modal Dialog Fields:**

1. **Select Department**
   - Dropdown with all departments
   - Special option: "None (Applicable across all departments)"
   - Selecting "None" makes the fee apply to all departments

2. **Select Sub Item**
   - Same as Faculty scope
   - Dropdown with all fee items

3. **Enter Level**
   - Same as Faculty scope
   - Numeric input for student level (0-900)

4. **Indigene Status**
   - Same as Faculty scope
   - Options: indigene, non_indigene, All, None

5. **Effective Date**
   - Same as Faculty scope
   - Date picker for future-dated fees

6. **Amount**
   - Same as Faculty scope
   - Minimum value: 300

**Add Button:** Submits the department scope fee configuration

---

#### C. Course Scope Fee Setup

**Purpose:** Configure fees that apply to specific courses or across all courses.

**Modal Dialog Fields:**

1. **Select Course**
   - Dropdown with courses filtered by the selected school
   - Special option: "None (Applicable across all courses)"
   - Selecting "None" makes the fee apply to all courses
   - Only shows courses relevant to the selected school

2. **Select Sub Item**
   - Same as Faculty and Department scopes
   - Dropdown with all fee items

3. **Enter Level**
   - Same as Faculty and Department scopes
   - Numeric input for student level (0-900)

4. **Indigene Status**
   - Same as Faculty and Department scopes
   - Options: indigene, non_indigene, All, None

5. **Effective Date**
   - Same as Faculty and Department scopes
   - Date picker for future-dated fees

6. **Amount**
   - Same as Faculty and Department scopes
   - Minimum value: 300

**Add Button:** Submits the course scope fee configuration

---

### 3. **View Configured Fees in Accordion Tables**

The page displays all configured fees organized in three collapsible accordion sections:

#### Faculty Scope Accordion

**Table Columns:**
- **# (Serial Number):** Sequential numbering
- **Faculty:** Faculty name (blank if "None" - applies to all)
- **Level:** Student level (All, None, or specific level like 100, 200)
- **Indigene Status:** indigene, non_indigene, All, or None
- **Amount:** Fee amount formatted with currency notation
- **Fees Item:** The specific fee item name
- **Delete:** Red button to remove the fee configuration

**Table Features:**
- DataTable integration with search, sort, and pagination
- Export options: Copy, CSV, Excel, PDF, Print
- Pagination: 25, 50, 100, 200, 500 records per page
- Responsive design

---

#### Department Scope Accordion

**Table Columns:**
- **# (Serial Number):** Sequential numbering
- **Department:** Department code (blank if "None" - applies to all)
- **Level:** Student level (All, None, or specific level)
- **Indigene Status:** indigene, non_indigene, All, or None
- **Amount:** Fee amount formatted with currency notation
- **Fees Item:** The specific fee item name
- **Delete:** Red button to remove the fee configuration

**Table Features:**
- Same DataTable features as Faculty scope
- Independent search and filtering
- Separate export functionality

---

#### Course Scope Accordion

**Table Columns:**
- **# (Serial Number):** Sequential numbering
- **Course:** Course name (blank if "None" - applies to all)
- **Level:** Student level (All, None, or specific level)
- **Indigene Status:** indigene, non_indigene, All, or None
- **Amount:** Fee amount formatted with currency notation
- **Fees Item:** The specific fee item name
- **Delete:** Red button to remove the fee configuration

**Table Features:**
- Same DataTable features as Faculty and Department scopes
- Independent search and filtering
- Separate export functionality

---

### 4. **Delete Fee Configurations**

**Operation:**
- Each fee record has a red "Delete" button
- Clicking the button removes the fee configuration
- URL parameters are encrypted for security
- Deletion is immediate and permanent
- Success message: "Records has been removed from fees setup"

**Security Features:**
- Encrypted fee setup ID in URL
- Server-side decryption before processing
- No confirmation dialog (exercise caution)

---

### 5. **Navigation and Management**

**Header Buttons:**

1. **Back Button** (Red/Danger)
   - Returns to `/fees_setup` (selection page)
   - Allows changing the context (school, session, etc.)

2. **Manage Fee Groups Button** (Blue/Info)
   - Links to `/create_fees_group`
   - Opens fee group management interface
   - Allows creating and editing fee group categories

3. **Faculty Scope Button** (Gray/Secondary)
   - Opens the Faculty Scope modal dialog
   - Allows adding fees at faculty level

4. **Department Scope Button** (Blue/Primary)
   - Opens the Department Scope modal dialog
   - Allows adding fees at department level

5. **Course Scope Button** (Green/Success)
   - Opens the Course Scope modal dialog
   - Allows adding fees at course level

---

## Fee Hierarchy and Precedence

Understanding how fees are applied is crucial:

### Scope Hierarchy (Most Specific to Least Specific):
1. **Course Scope** - Most specific, applies to individual courses
2. **Department Scope** - Applies to all courses in a department
3. **Faculty Scope** - Applies to all departments in a faculty
4. **"None" Scope** - Applies universally across all faculties/departments/courses

### Level Specification:
- **Specific Level (e.g., 100, 200):** Applies only to students at that level
- **"All":** Applies to students at all levels
- **"None":** Level is not applicable (used for non-level-specific fees like applications)

### Indigene Status:
- **indigene:** Only local/indigene students pay this fee
- **non_indigene:** Only non-local students pay this fee
- **All:** Both indigene and non-indigene students pay
- **None:** Indigene status doesn't affect this fee

### Example Scenarios:

**Scenario 1: Universal Tuition Fee**
- Faculty: None
- Department: None
- Course: None
- Level: All
- Indigene Status: All
- Result: Every student in the school pays this fee

**Scenario 2: Engineering Faculty Lab Fee**
- Faculty: Engineering
- Department: None
- Course: None
- Level: All
- Indigene Status: All
- Result: All students in Engineering faculty pay this fee

**Scenario 3: Computer Science Department Software Fee**
- Faculty: None
- Department: Computer Science
- Course: None
- Level: All
- Indigene Status: All
- Result: All Computer Science students pay this fee

**Scenario 4: Course-Specific Field Trip Fee**
- Faculty: None
- Department: None
- Course: Geology 301
- Level: 300
- Indigene Status: All
- Result: Only Geology 301 students at 300 level pay this fee

**Scenario 5: Indigene Discount**
- Faculty: None
- Department: None
- Course: None
- Level: All
- Indigene Status: indigene
- Amount: 50,000
- Result: Indigene students pay 50,000

- Faculty: None
- Department: None
- Course: None
- Level: All
- Indigene Status: non_indigene
- Amount: 75,000
- Result: Non-indigene students pay 75,000

---

## Important Instructions & Warnings

The page includes critical instructions displayed in a yellow warning alert:

### Key Instructions:

1. **"You can click on any of the scope to add amount"**
   - Refers to the three scope buttons (Faculty, Department, Course)
   - Each opens a modal dialog for fee configuration

2. **"Note that faculty scope will apply to all the departments and same for department scope"**
   - Faculty-level fees cascade to all departments within that faculty
   - Department-level fees cascade to all courses within that department
   - Understanding this hierarchy prevents duplicate or conflicting fees

3. **"Leave the level empty if you want the fee to be applicable to all levels"**
   - Empty level field = applies to all student levels (100, 200, 300, etc.)
   - Useful for fees that don't vary by level

4. **"Enter 0 if you want the level to be ignored (For items such as applications)"**
   - Level = 0 means level is not applicable
   - Used for fees that aren't tied to student level
   - Example: Application fees (applicants don't have a level yet)

---

## Practical Use Cases

### Use Case 1: Setting Up Basic School Fees for New Session
**Scenario:** Configure standard school fees for all students in the School of Sciences for 2025/2026 session.

**Steps:**
1. Navigate to `/fees_setup` (adminfeesSetup.jsp)
2. Select "School of Sciences" from Schools dropdown
3. Select "SCHOOL FEES" from Payment Item dropdown
4. Select "2025/2026" from Session dropdown
5. Select "Session" from Semester dropdown
6. Click "View" button
7. On the details page, click "Faculty Scope" button
8. In the modal:
   - Select "None (Applicable across all faculties)"
   - Select "Tuition" from Sub Item
   - Leave Level empty (applies to all levels)
   - Select "All" for Indigene Status
   - Leave Effective Date empty (effective immediately)
   - Enter Amount: 150000
   - Click "Add" button
9. Verify the fee appears in the Faculty Scope accordion table
10. Repeat for other fee items (Library Fee, Sports Fee, etc.)

---

### Use Case 2: Setting Up Differential Fees for Indigenes and Non-Indigenes
**Scenario:** Indigene students pay 100,000 while non-indigene students pay 150,000 for tuition.

**Steps:**
1. Navigate to fees setup and select context (School, Session, Semester, Fee Group)
2. Click "Faculty Scope" button
3. Add indigene fee:
   - Faculty: None
   - Sub Item: Tuition
   - Level: (empty - all levels)
   - Indigene Status: indigene
   - Amount: 100000
   - Click "Add"
4. Click "Faculty Scope" button again
5. Add non-indigene fee:
   - Faculty: None
   - Sub Item: Tuition
   - Level: (empty - all levels)
   - Indigene Status: non_indigene
   - Amount: 150000
   - Click "Add"
6. Verify both fees appear in the Faculty Scope table
7. System will automatically charge students based on their indigene status

---

### Use Case 3: Setting Up Level-Specific Fees
**Scenario:** Final year students (500 level) have an additional project fee of 25,000.

**Steps:**
1. Navigate to fees setup and select context
2. Click "Faculty Scope" button (or Department/Course depending on scope)
3. In the modal:
   - Faculty: None (or specific faculty if applicable)
   - Sub Item: Project Fee
   - Level: 500
   - Indigene Status: All
   - Amount: 25000
   - Click "Add"
4. Verify the fee appears with Level = 500
5. Only 500-level students will be charged this fee

---

### Use Case 4: Setting Up Department-Specific Lab Fees
**Scenario:** Computer Science department students pay an additional 15,000 for lab equipment.

**Steps:**
1. Navigate to fees setup and select context
2. Click "Department Scope" button
3. In the modal:
   - Department: Computer Science
   - Sub Item: Lab Fee
   - Level: (empty - all levels)
   - Indigene Status: All
   - Amount: 15000
   - Click "Add"
4. Verify the fee appears in the Department Scope accordion
5. Only Computer Science students will be charged this fee

---

### Use Case 5: Setting Up Course-Specific Fees
**Scenario:** Students taking "Marine Biology Field Study" course pay an additional 30,000 for field trips.

**Steps:**
1. Navigate to fees setup and select context
2. Click "Course Scope" button
3. In the modal:
   - Course: Marine Biology Field Study
   - Sub Item: Field Trip Fee
   - Level: (empty or specific level)
   - Indigene Status: All
   - Amount: 30000
   - Click "Add"
4. Verify the fee appears in the Course Scope accordion
5. Only students enrolled in this specific course will be charged

---

### Use Case 6: Setting Up Future-Dated Fee Increases
**Scenario:** Fees will increase by 10% starting March 1, 2026.

**Steps:**
1. Navigate to fees setup and select context
2. Click appropriate scope button (Faculty/Department/Course)
3. In the modal:
   - Configure all fields as needed
   - Effective Date: Select "2026-03-01"
   - Enter new (increased) amount
   - Click "Add"
4. The new fee will not take effect until March 1, 2026
5. Students registering before March 1 will pay the old rate
6. Students registering on or after March 1 will pay the new rate

---

### Use Case 7: Setting Up Application Fees (Level = 0)
**Scenario:** Configure application fees for prospective students who don't have a level yet.

**Steps:**
1. Navigate to fees setup
2. Select School, "APPLICATION FEES" as Payment Item, Session, Semester
3. Click "View"
4. Click "Faculty Scope" button
5. In the modal:
   - Faculty: None
   - Sub Item: Application Processing Fee
   - Level: 0 (not applicable)
   - Indigene Status: All
   - Amount: 5000
   - Click "Add"
6. Applicants will be charged this fee regardless of their intended level

---

### Use Case 8: Removing Incorrect Fee Configuration
**Scenario:** A fee was configured with the wrong amount and needs to be removed.

**Steps:**
1. Navigate to fees setup and select the same context used when creating the fee
2. Expand the appropriate accordion (Faculty/Department/Course Scope)
3. Locate the incorrect fee in the table (use search if needed)
4. Click the red "Delete" button in the Delete column
5. Page refreshes and displays: "Records has been removed from fees setup"
6. Verify the fee no longer appears in the table
7. Add the correct fee configuration using the appropriate scope button

---

### Use Case 9: Exporting Fee Configuration for Review
**Scenario:** Management wants to review all configured fees before the session starts.

**Steps:**
1. Navigate to fees setup and select context
2. Expand each accordion (Faculty, Department, Course Scope)
3. For each table:
   - Click "Excel" button to export to spreadsheet
   - Or click "PDF" button for formal documentation
4. Save the exported files with descriptive names
5. Send to management for review
6. Make adjustments based on feedback

---

### Use Case 10: Configuring Fees for Multiple Semesters
**Scenario:** First semester and second semester have different fee structures.

**Steps:**
1. Configure First Semester fees:
   - Navigate to fees setup
   - Select School, Fee Group, Session, "First" Semester
   - Click "View"
   - Configure all fees for first semester
2. Configure Second Semester fees:
   - Click "Back" button to return to selection page
   - Keep School, Fee Group, Session the same
   - Change Semester to "Second"
   - Click "View"
   - Configure all fees for second semester
3. Each semester maintains its own independent fee structure

---

## Technical Features

### AJAX Dynamic Loading
The page uses asynchronous JavaScript to provide a seamless user experience:

1. **loadItems() Function:**
   - Triggered when school is selected
   - Fetches payment items and sessions for the selected school
   - Updates two dropdowns simultaneously
   - Prevents page reload

2. **loadSesssem() Function:**
   - Triggered when payment item is selected
   - Fetches semester options based on fee group configuration
   - Updates semester dropdown
   - Ensures data consistency

### Session Management
- Selected context (school, session, semester, fee group) is stored in HTTP session
- Allows seamless navigation between pages
- Prevents data loss during workflow
- Validates session data before displaying details page

### Data Validation
- **Client-side:** HTML5 form validation (required fields, min/max values)
- **Server-side:** Validates all inputs before database insertion
- **Amount Validation:** Minimum 300, must be numeric
- **Level Validation:** 0-900 range, 3-digit format
- **Date Validation:** Cannot be in the past

### Database Operations
The page performs the following database operations:
- `sess.getAllSchoos()` - Retrieves all schools
- `sess.getAllFeesitems()` - Retrieves all fee items
- `sess.getAllFacultiesDirectorates()` - Retrieves all faculties
- `sess.getAllDepartments()` - Retrieves all departments
- `sess.getCoursesBySchool()` - Retrieves courses for selected school
- `sess.getFeessetup()` - Retrieves configured fees for display
- `sess.newEntry(Feessetup)` - Creates new fee configuration
- `sess.removeFeessetup()` - Deletes fee configuration
- `sess.getSingleObject()` - Retrieves specific entities by ID

### Security Mechanisms
- **Authentication Check:** Redirects unauthenticated users
- **URL Encryption:** All fee setup IDs in URLs are encrypted
- **Parameter Decryption:** Server-side decryption before processing
- **Session Validation:** Validates required session attributes
- **SQL Injection Prevention:** Uses parameterized queries

### User Interface Elements
- **Modal Dialogs:** Three separate modals for different scopes
- **Accordion Layout:** Collapsible sections for organized display
- **DataTables Integration:** Advanced table features for all three scopes
- **Responsive Design:** Works on different screen sizes
- **Bootstrap Styling:** Professional, consistent appearance
- **Alert Messages:** Color-coded feedback (success, danger, warning)

---

## Fee Configuration Best Practices

### 1. Planning Phase
- **Document Fee Structure:** Create a spreadsheet of all fees before configuration
- **Get Approval:** Obtain management approval for fee amounts
- **Consider Hierarchy:** Plan which fees go at which scope level
- **Check for Overlaps:** Ensure fees don't conflict or duplicate

### 2. Configuration Phase
- **Start Broad:** Configure universal fees first (Faculty scope with "None")
- **Then Specific:** Add department and course-specific fees
- **Test Calculations:** Verify total fees are calculated correctly
- **Use Effective Dates:** For planned fee changes, use future dates

### 3. Verification Phase
- **Export and Review:** Export all configurations to Excel
- **Cross-check Amounts:** Verify amounts match approved fee schedule
- **Test with Sample Students:** Check fee calculation for different student types
- **Document Changes:** Keep records of all fee configurations

### 4. Maintenance Phase
- **Regular Audits:** Periodically review fee configurations
- **Update as Needed:** Adjust fees based on institutional decisions
- **Archive Old Fees:** Keep records of historical fee structures
- **Monitor Complaints:** Address student queries about fees promptly

---

## Common Scenarios & Solutions

### Scenario: Fee Appears Multiple Times in Different Scopes
**Problem:** The same fee item appears in Faculty, Department, and Course scopes.
**Solution:** 
- This is normal if fees are configured at multiple levels
- The system will apply the most specific fee (Course > Department > Faculty)
- Review if this is intentional or if duplicate fees should be removed
- Use the Delete button to remove unintended duplicates

### Scenario: Students Not Being Charged Correct Amount
**Problem:** Fee calculation doesn't match configured amounts.
**Solution:**
- Verify the student's level, indigene status, faculty, department, and course
- Check if there are multiple fee configurations that might conflict
- Ensure the effective date has passed
- Review the fee hierarchy to understand which fee is being applied
- Export fee configurations to identify conflicts

### Scenario: Need to Change Fee Amount
**Problem:** Fee amount was configured incorrectly and needs to be changed.
**Solution:**
- There is no "Edit" function for fees
- Delete the incorrect fee configuration
- Add a new fee configuration with the correct amount
- If fees have already been charged, consult with finance department

### Scenario: Fees Not Showing for Certain Students
**Problem:** Some students don't see fees that should apply to them.
**Solution:**
- Check the Level Scope: Ensure it's "All" or matches student's level
- Check Indigene Status: Ensure it's "All" or matches student's status
- Check Faculty/Department/Course Scope: Ensure student belongs to the scope
- Verify the session and semester match the student's registration period

### Scenario: Need to Apply Same Fees to Multiple Schools
**Problem:** Multiple schools have identical fee structures.
**Solution:**
- Unfortunately, fees must be configured separately for each school
- Use the export feature to document one school's fees
- Use the exported data as a reference to configure other schools
- Consider creating a standard fee template document for consistency

---

## Important Notes for Administrators

1. **No Edit Function:** Fee configurations cannot be edited. They must be deleted and recreated with correct values.

2. **No Confirmation on Delete:** Clicking the Delete button immediately removes the fee. Exercise caution.

3. **Hierarchy Matters:** Understanding Faculty > Department > Course hierarchy is crucial for correct fee application.

4. **Level = 0 vs Empty:** Empty level means "all levels", 0 means "not applicable". These are different.

5. **Indigene Status Impact:** Differential pricing based on indigene status is a powerful feature. Use it carefully.

6. **Effective Dates:** Future-dated fees allow planning ahead but require careful tracking.

7. **Session and Semester Specific:** Fees are tied to specific sessions and semesters. Changing session requires reconfiguring fees.

8. **Fee Groups Required:** Fees must belong to a fee group. Manage fee groups through the "Manage Fee Groups" button.

9. **Minimum Amount:** The system enforces a minimum fee of 300. This may need adjustment based on institutional policy.

10. **Export Regularly:** Export fee configurations regularly for backup and audit purposes.

---

## Training Summary

During today's training session, the client was introduced to the **Fees Setup** functionality, which serves as the comprehensive fee management system for the institution. The key takeaways include:

- Understanding the two-page workflow (selection and configuration)
- Ability to configure fees at three organizational levels (Faculty, Department, Course)
- Managing fee variations based on level and indigene status
- Using effective dates for future fee changes
- Understanding the fee hierarchy and precedence rules
- Viewing and managing configured fees through accordion tables
- Exporting fee data for review and documentation
- Following best practices for fee configuration and maintenance

This module is essential for financial management and ensuring students are charged correctly based on their academic program, level, and status. It requires careful planning and regular maintenance to ensure accuracy.

---

## Critical Warnings Recap

⚠️ **NO EDIT FUNCTION:** Fees cannot be edited, only deleted and recreated. Double-check before adding.

⚠️ **HIERARCHY UNDERSTANDING:** Faculty scope affects all departments, department scope affects all courses. Plan carefully.

⚠️ **IMMEDIATE DELETION:** No confirmation dialog when deleting fees. Deleted fees cannot be recovered.

⚠️ **EFFECTIVE DATES:** Future-dated fees require careful tracking to ensure they activate at the right time.

⚠️ **INDIGENE STATUS:** Differential pricing is powerful but must be used in compliance with institutional policy.

⚠️ **LEVEL SPECIFICATION:** Empty level ≠ Level 0. Understand the difference to avoid incorrect fee application.

---

**Report Prepared By:** Training Team  
**Pages Analyzed:** adminfeesSetup.jsp & adminFeesSetupDetails.jsp  
**System:** EduPortal v1.0  
**Classification:** Critical Financial Management Function
