# Training Activity Report - adminadmissionlist.jsp
**Date:** February 12, 2026  
**Client:** EduPortal  
**Pages/Modules:** 
- adminadmissionlist.jsp (UTME Admissions Overview)
- adminadmissionview.jsp (Admission List Details)

---

## Overview
The **adminadmissionlist.jsp** page is a critical administrative interface for managing UTME (Unified Tertiary Matriculation Examination) and Direct Entry (DE) admissions within the EduPortal system. This page serves as the central hub for processing student admissions, allowing administrators to:
1. View admission statistics by course
2. Add individual applicants to admission lists
3. Upload bulk admission lists via Excel
4. Monitor admission quotas and progress
5. View detailed admission lists by course

This module is essential for the admission process as it controls which applicants are offered admission to various academic programmes.

---

## Page Access & Security
- **Access Control:** The page is protected and requires user authentication
- **User Type:** Accessible only to staff members with appropriate administrative privileges
- **URL Paths:** 
  - Admissions Overview: `/adminssion_list`
  - Admission Details: `/adminssion_view`
- **Authorization Level:** High-level admissions administrative access required
- **Session Context:** Works with the current active application session

---

## Core Functionality

### 1. **View Admission Statistics by Course**

The page displays a comprehensive table showing admission statistics for all courses.

#### Table Columns:
- **# (Serial Number):** Sequential numbering
- **Course:** Full name of the academic programme
- **Total Applicants:** Number of applicants for the course (clickable to view details)
- **Total Admitted:** Number of students already admitted
- **Admission Quota:** Maximum number of students that can be admitted
- **Action:** "View" button to see detailed admission list

#### Table Features:
- DataTable integration with search, sort, and pagination
- Export options: Copy, CSV, Excel, PDF, Print
- Pagination: 25, 50, 100, 200, 500 records per page
- Responsive design
- Real-time statistics from database

#### Key Information Displayed:
- **Total Applicants:** Shows how many students applied for each course
  - Clickable link that opens applications view page
  - Includes UTME, DE, and other application types
  - Helps assess demand for each programme
  
- **Total Admitted:** Shows current admission count
  - Helps track admission progress
  - Compares against quota to prevent over-admission
  
- **Admission Quota:** Shows maximum allowed admissions
  - Defined in admission template
  - Includes all merit types (NM, SM, ELG, LM, SPECIAL)
  - Prevents exceeding institutional capacity

---

### 2. **Add Individual Applicant to Admission List**

Administrators can add applicants one by one through a modal dialog.

#### Modal Dialog: "Add to Admission" Button (Green/Success)

**Form Fields:**

**a) Enter Jamb Number** (Required)
- Text input for JAMB registration number
- Unique identifier for each applicant
- System uses this to retrieve applicant details
- Example: "12345678AB"

**b) Full Name** (Read-only)
- Automatically populated after entering JAMB number
- Displays applicant's full name
- Confirms correct applicant is selected
- Cannot be manually edited

**c) Course Applied** (Read-only)
- Automatically populated after entering JAMB number
- Shows the course the applicant originally applied for
- Helps verify applicant's original choice
- Cannot be manually edited

**d) Select Course Admitted into** (Required)
- Dropdown with all available courses
- Includes courses from:
  - School S001 (typically main undergraduate school)
  - School S003 (typically another undergraduate school)
- Programme type: Undergraduate (1001)
- Allows admitting to a different course than applied for

**e) Mode of Entry** (Required)
- Dropdown with options:
  - **UTME:** Unified Tertiary Matriculation Examination
  - **DE:** Direct Entry (for candidates with advanced qualifications)
- Determines admission pathway
- Affects registration requirements

**f) Select Merit Type** (Required)
- Dropdown with options:
  - **NM:** National Merit
  - **SM:** State Merit
  - **ELG:** Equality of LGA (Local Government Area)
  - **LM:** Locality (local to the institution)
  - **SPECIAL:** Special Merit (for special cases)
- Determines admission category
- Used for quota management and reporting

**Add to Admission Button:** Processes the admission

#### Admission Process:
1. Enter JAMB number
2. System retrieves and displays applicant details
3. Verify applicant information
4. Select course to admit into (can be different from applied course)
5. Select mode of entry (UTME or DE)
6. Select merit type
7. Click "Add to Admission"
8. Applicant is added to admission list
9. Admission status changes from application to admitted

---

### 3. **Upload Bulk Admission List**

Administrators can upload multiple admissions at once using an Excel file.

#### Modal Dialog: "Upload admission list" Button (Gray/Secondary)

**Form Fields:**

**a) Select Course Admitted into** (Required)
- Dropdown with all available courses
- Same course list as individual admission
- All applicants in the Excel file will be admitted to this course
- Upload is course-specific (one course at a time)

**b) Select admission file** (Required)
- File input accepting only .xls files
- Must be Microsoft Excel 97-2003 Workbook format (.xls)
- Template available for download
- Link: "Download template" (opens templates/admissionlist.xls)

**Upload Admission Button:** Processes the bulk upload

#### Upload Process:
1. Download the admission list template
2. Fill in applicant details in Excel:
   - JAMB numbers
   - Merit types
   - Mode of entry
   - Other required fields
3. Save file as .xls format (Excel 97-2003 Workbook)
4. Select course for admission
5. Choose the prepared Excel file
6. Click "Upload Admission"
7. System processes file and adds all applicants
8. Upload report is displayed for verification

#### Template Structure:
- Pre-formatted Excel file with required columns
- Ensures data consistency
- Prevents formatting errors
- Includes sample data for reference

#### Important Notes:
- **One Course at a Time:** Each upload is for a single course
- **File Format:** Must be .xls (not .xlsx)
- **Verification Required:** Always check upload report before leaving
- **No Undo:** Once uploaded, admissions must be removed individually

---

### 4. **View Detailed Admission List**

Each course has a "View" button that opens the detailed admission list.

#### Navigation Process:
1. Click "View" button for any course
2. System stores course ID and session in session attributes
3. Redirects to `/adminssion_view` (adminadmissionview.jsp)
4. Displays complete admission list for that course

#### Detailed Admission List Table Columns:
- **# (Serial Number):** Sequential numbering
- **FACULTY:** Faculty name
- **DEPARTMENT:** Department name
- **COURSE:** Course/Programme name
- **REG NO:** Registration number (admission ID)
- **SURNAME:** Student's surname
- **OTHER NAMES:** Student's other names
- **DATE OF BIRTH:** Student's date of birth
- **STATE OF ORIGIN:** Student's state
- **LGA:** Local Government Area
- **MOE:** Mode of Entry (UTME/DE)
- **MERIT TYPE:** Merit category (NM/SM/ELG/LM/SPECIAL)
- **STATUS:** Admission status (PENDING/ACCEPTED/etc.)
- **ACTION:** Remove button (for PENDING status only)

#### Table Features:
- Full DataTable functionality
- Export to Excel, PDF, CSV, etc.
- Search and filter capabilities
- Sortable columns
- Pagination

---

### 5. **Remove Applicant from Admission List**

Applicants with "PENDING" status can be removed from the admission list.

#### Remove Process:
1. Navigate to detailed admission list
2. Locate applicant with "PENDING" status
3. Click red "Remove" button
4. Applicant is removed from admission list
5. Applicant status reverts to "PAID" (application status)
6. Applicant can be re-admitted if needed

#### Status-Based Actions:
- **PENDING Status:** Shows "Remove" button
  - Admission not yet finalized
  - Can be removed without consequences
  - Applicant returns to application pool

- **Other Statuses:** No action button
  - Admission has been accepted/processed
  - Cannot be removed through this interface
  - Requires different administrative process

---

### 6. **View All Applications**

The "View All Applications" button provides access to all applicants.

#### Button: "View All Applications" (Blue/Info)
- Located in the header area
- Links to `/applications_view?id2=ALL`
- Shows all applications across all courses
- Useful for:
  - Reviewing application pool
  - Identifying qualified applicants
  - Checking application status
  - Preparing admission lists

---

### 7. **View Full Admission List**

The "View Full Admission List" button shows all admissions across courses.

#### Button: "View Full Admission List" (Blue/Primary)
- Located in the header area
- Links to `/adminssion_view` with course="ALL"
- Shows admissions for all courses combined
- Useful for:
  - Overall admission statistics
  - Cross-course analysis
  - Generating comprehensive reports
  - Monitoring total admissions

---

### 8. **Download Full Admission List**

The "Download Full List" button exports all admissions to a file.

#### Button: "Download Full List" (Yellow/Warning)
- Located in the header area
- Links to `/Downloadadmissionlist` servlet
- Downloads admission list for current session
- File format: Likely Excel or CSV
- Includes all courses and all admitted students
- Useful for:
  - Offline processing
  - Reporting to management
  - Archiving admission records
  - Sharing with other departments

---

## Session and Context Management

### Current Session Display
The page works with the current active application session:
- Automatically retrieves current session for school S001 (main school)
- Operation type: "APPLICATION"
- Session name displayed in instructions (e.g., "2024/2025")
- All admissions processed against this session
- Cannot process admissions for past or future sessions

### Important Session Note:
"Admission will be processed against the [Session Name] academic session. Note that only current session for application can be treated."

This ensures:
- Admissions are for the correct academic year
- No backdating or future-dating of admissions
- Consistency across the system
- Proper record-keeping



---

## Instructions and Guidelines

The page includes a collapsible instruction panel with important guidelines:

### Key Instructions:

1. **Scope of Processing:**
   - "This page allows you to process admission for only UTME and DE applicants."
   - Limited to undergraduate admissions
   - Does not handle postgraduate admissions
   - Focuses on JAMB-based admissions

2. **Admission Methods:**
   - "You can add one by one or upload an excel file one course at a time"
   - Two methods available: individual and bulk
   - Bulk upload is course-specific
   - Cannot upload multiple courses in one file

3. **File Format Requirement:**
   - "You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format"
   - Must use older Excel format (.xls)
   - Newer formats (.xlsx) not supported
   - Ensures compatibility with upload system

4. **Verification Requirement:**
   - "Always remember to confirm your upload report that it is what you intend to upload and in the desired course before leaving"
   - Critical step after bulk upload
   - Prevents errors and misplacements
   - Upload report shows what was processed
   - Verify course, numbers, and details

5. **Session Context:**
   - Displays current session being processed
   - Example: "Admission will be processed against the 2024/2025 academic session"
   - Reminder that only current session can be processed
   - Prevents confusion about which year's admissions

---

## Practical Use Cases

### Use Case 1: Adding a Single Applicant to Admission List
**Scenario:** An applicant with JAMB number 12345678AB needs to be admitted to Computer Science.

**Steps:**
1. Navigate to `/adminssion_list` (adminadmissionlist.jsp)
2. Click green "Add to Admission" button
3. Enter JAMB number: "12345678AB"
4. System auto-fills:
   - Full Name: "JOHN DOE"
   - Course Applied: "Computer Science"
5. Select Course Admitted into: "Computer Science" (or different course if needed)
6. Select Mode of Entry: "UTME"
7. Select Merit Type: "NM" (National Merit)
8. Click "Add to Admission" button
9. Applicant is added to admission list
10. Verify by clicking "View" button for Computer Science course

---

### Use Case 2: Admitting Applicant to Different Course
**Scenario:** An applicant applied for Computer Science but needs to be admitted to Information Technology.

**Steps:**
1. Click "Add to Admission" button
2. Enter applicant's JAMB number
3. System shows:
   - Course Applied: "Computer Science"
4. In "Select Course Admitted into" dropdown:
   - Select "Information Technology" (different from applied course)
5. Select Mode of Entry: "UTME"
6. Select Merit Type: "SM" (State Merit)
7. Click "Add to Admission"
8. Applicant is admitted to Information Technology
9. Original application remains for Computer Science
10. Admission record shows Information Technology

---

### Use Case 3: Bulk Upload of Admission List
**Scenario:** Need to admit 50 students to Electrical Engineering at once.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Click "Upload admission list" button
3. Click "Download template" link
4. Template file downloads (admissionlist.xls)
5. Open template in Excel
6. Fill in data for all 50 students:
   - JAMB numbers
   - Merit types
   - Mode of entry
   - Other required fields
7. Save file as .xls format (Excel 97-2003 Workbook)
8. Back in the upload modal:
   - Select Course: "Electrical Engineering"
   - Choose the prepared .xls file
9. Click "Upload Admission" button
10. System processes file
11. Upload report displays showing:
    - Number of records processed
    - Any errors or warnings
    - Successfully admitted students
12. Review report carefully
13. Click "View" for Electrical Engineering to verify admissions
14. Check that all 50 students appear in the list

---

### Use Case 4: Monitoring Admission Progress
**Scenario:** Need to check how many students have been admitted vs quota for each course.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Review the main table:
   - Look at "Total Admitted" column
   - Compare with "Admission Quota" column
3. Identify courses approaching quota:
   - Example: Computer Science shows 48 admitted, 50 quota (96% full)
4. Identify courses with low admissions:
   - Example: Physics shows 15 admitted, 40 quota (37.5% full)
5. Export table to Excel for detailed analysis:
   - Click "Excel" button in DataTable toolbar
6. Share report with management
7. Adjust admission strategy based on data

---

### Use Case 5: Reviewing Applications Before Admission
**Scenario:** Need to review all applicants for a course before processing admissions.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Locate desired course in the table
3. Click on the number in "Total Applicants" column
4. Applications view page opens
5. Review all applicants:
   - Check qualifications
   - Review JAMB scores
   - Verify eligibility
6. Note JAMB numbers of qualified applicants
7. Return to admission list page
8. Add qualified applicants using:
   - Individual addition for few applicants
   - Bulk upload for many applicants

---

### Use Case 6: Removing Incorrectly Admitted Applicant
**Scenario:** An applicant was admitted by mistake and needs to be removed.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Click "View" button for the relevant course
3. Detailed admission list opens
4. Locate the incorrectly admitted applicant
5. Check STATUS column:
   - If "PENDING": Remove button is available
   - If other status: Cannot remove through this interface
6. For PENDING status:
   - Click red "Remove" button
   - Applicant is removed from admission list
   - Status reverts to "PAID" (application status)
7. Verify removal by refreshing the page
8. Applicant no longer appears in admission list
9. Applicant can be re-admitted if needed later

---

### Use Case 7: Processing Direct Entry Admissions
**Scenario:** Need to admit Direct Entry candidates who have advanced qualifications.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Click "Add to Admission" button
3. Enter DE candidate's JAMB number
4. System displays candidate details
5. Select Course Admitted into
6. Select Mode of Entry: "DE" (Direct Entry)
7. Select Merit Type: "NM" or appropriate type
8. Click "Add to Admission"
9. DE candidate is admitted
10. Mode of Entry shows as "DE" in admission list
11. This affects:
    - Registration requirements
    - Entry level (may start at 200 level)
    - Course exemptions

---

### Use Case 8: Managing Merit Type Distribution
**Scenario:** Need to ensure proper distribution of merit types according to policy.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Click "View Full Admission List" button
3. Full admission list opens with all courses
4. Export to Excel for analysis
5. In Excel, create pivot table:
   - Rows: Merit Type
   - Values: Count of students
6. Analyze distribution:
   - NM (National Merit): Should be ~45%
   - SM (State Merit): Should be ~35%
   - ELG (Equality of LGA): Should be ~10%
   - LM (Locality): Should be ~10%
   - SPECIAL: As needed
7. Identify imbalances
8. Adjust future admissions to meet policy requirements
9. Document findings for management

---

### Use Case 9: Downloading Admission List for Reporting
**Scenario:** Management needs a complete admission list for the current session.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Click yellow "Download Full List" button
3. File downloads (Excel or CSV format)
4. Open downloaded file
5. File contains all admissions:
   - All courses
   - All merit types
   - All student details
6. Review data for completeness
7. Format as needed for presentation
8. Add summary statistics:
   - Total admissions
   - Breakdown by course
   - Breakdown by merit type
   - Breakdown by mode of entry
9. Submit to management

---

### Use Case 10: Verifying Admission Quota Compliance
**Scenario:** Need to ensure no course exceeds its admission quota.

**Steps:**
1. Navigate to adminadmissionlist.jsp
2. Review main table carefully
3. For each course, compare:
   - Total Admitted (column 4)
   - Admission Quota (column 5)
4. Identify any courses where:
   - Total Admitted > Admission Quota (over-admission)
5. For over-admitted courses:
   - Click "View" button
   - Review admission list
   - Identify most recent admissions
   - Consider removing some PENDING admissions
   - Or request quota increase from management
6. For under-admitted courses:
   - Review applications
   - Identify qualified applicants
   - Process additional admissions
7. Export table for documentation
8. Report findings to admissions committee

---

## Technical Features

### Data Retrieval and Counting
The page performs sophisticated data retrieval:

**Applicant Counting:**
- Counts applicants by multiple application types
- Handles both new and legacy application types:
  - "ug" (new undergraduate applications)
  - "UTME" (legacy UTME applications)
  - "DE" (Direct Entry applications)
  - "REM" (Remedial applications)
- Ensures backward compatibility with old data
- Provides accurate counts across different application systems

**Admission Counting:**
- Counts admissions by course and session
- Filters by status (ALL, PENDING, ACCEPTED, etc.)
- Includes all merit types
- Real-time data from database

**Quota Retrieval:**
- Fetches admission quota from admission template
- Shows maximum allowed admissions
- Helps prevent over-admission
- Based on institutional capacity

### Session Management
- Stores selected course and session in HTTP session
- Allows navigation between pages without losing context
- Validates session data before displaying details
- Ensures data consistency across workflow

### URL Encryption
- All course IDs and parameters are encrypted
- Prevents tampering with URLs
- Enhances security
- Decryption occurs server-side

### Database Operations
**Admission Management:**
- `sess.getCurrentSessionManagerBySchoolAndOperation()` - Gets current session
- `sess.getCoursesBySchoolAndProgramme()` - Retrieves courses
- `sess.getCountApplicantsByCourseAndTypes()` - Counts applicants
- `sess.getCountAdmissionsByCourseStatus()` - Counts admissions
- `sess.getAdmissiontemplate()` - Retrieves admission quota
- `sess.getAdmissionsByCourseStatus()` - Retrieves admission list
- `sess.deleteAdmissions()` - Removes admission
- `sess.changeApplicantStatus()` - Updates applicant status

### File Upload Processing
- Servlet: `UploadJambAdmissionlist`
- Accepts .xls files only
- Processes Excel data row by row
- Validates data before insertion
- Generates upload report
- Handles errors gracefully

### User Interface Elements
- **Modal Dialogs:** For adding admissions and uploading files
- **Collapsible Instructions:** Important guidelines
- **DataTables Integration:** Advanced table features
- **Responsive Design:** Works on different screen sizes
- **Bootstrap Styling:** Professional appearance
- **Alert Messages:** Color-coded feedback
- **Export Buttons:** Multiple format options

---

## Important Concepts

### UTME vs Direct Entry

**UTME (Unified Tertiary Matriculation Examination):**
- Standard entry route for undergraduate admission
- Requires JAMB examination
- Students start at 100 level
- Most common admission type
- Full programme duration

**Direct Entry (DE):**
- For candidates with advanced qualifications
- Examples: NCE, OND, A-Levels
- May start at 200 level or higher
- Shorter programme duration
- Course exemptions may apply

### Merit Types Explained

**NM (National Merit):**
- Based on national ranking
- Typically 45% of quota
- Highest JAMB scores
- Competitive across all states

**SM (State Merit):**
- Based on state ranking
- Typically 35% of quota
- Best candidates from each state
- Ensures state representation

**ELG (Equality of LGA):**
- Based on Local Government Area
- Typically 10% of quota
- Ensures LGA representation
- Promotes geographical diversity

**LM (Locality):**
- For candidates local to institution
- Typically 10% of quota
- Based on proximity to university
- Community engagement

**SPECIAL:**
- Special cases and circumstances
- Discretionary admissions
- May include:
  - Staff children
  - Special talents
  - Exceptional cases
  - Management decisions

### Admission Status

**PENDING:**
- Initial admission status
- Not yet finalized
- Can be removed
- Awaiting confirmation

**ACCEPTED:**
- Admission confirmed
- Cannot be easily removed
- Student has accepted offer
- Proceeding to registration

**Other Statuses:**
- May include REJECTED, WITHDRAWN, etc.
- Vary by institutional policy
- Affect available actions

---

## Best Practices & Recommendations

### Before Processing Admissions:
1. **Verify Session:** Ensure you're working with the correct academic session
2. **Check Quotas:** Review admission quotas for all courses
3. **Review Applications:** Examine applicant pool before admitting
4. **Coordinate:** Consult with admissions committee and departments
5. **Prepare Lists:** If bulk uploading, prepare Excel files carefully

### During Admission Processing:
1. **One Course at a Time:** Focus on one course when bulk uploading
2. **Verify Details:** Double-check JAMB numbers and names
3. **Correct Course:** Ensure admitting to intended course
4. **Appropriate Merit Type:** Select correct merit category
5. **Monitor Quota:** Watch admission counts vs quotas

### After Processing Admissions:
1. **Verify Upload:** Always check upload report after bulk upload
2. **Review Lists:** Click "View" to verify admissions
3. **Export Data:** Download lists for backup and reporting
4. **Check Totals:** Ensure counts match expectations
5. **Document:** Keep records of admission decisions

### File Management:
1. **Use Template:** Always start with the provided template
2. **Correct Format:** Save as .xls (Excel 97-2003)
3. **Clean Data:** Remove empty rows and invalid entries
4. **Backup:** Keep copies of upload files
5. **Name Files:** Use descriptive names (e.g., "CS_Admissions_2024.xls")

### Quality Control:
1. **Regular Monitoring:** Check admission progress daily
2. **Quota Compliance:** Ensure no over-admission
3. **Merit Distribution:** Maintain proper merit type ratios
4. **Error Correction:** Remove incorrect admissions promptly
5. **Reporting:** Generate regular reports for management

---

## Common Scenarios & Solutions

### Scenario: Cannot Find Applicant by JAMB Number
**Problem:** Entering JAMB number doesn't populate applicant details.
**Solution:** 
- Verify JAMB number is correct (check for typos)
- Ensure applicant has submitted application
- Check if applicant paid application fee
- Verify applicant applied for current session
- Contact applicant to confirm JAMB number
- Check if applicant is in the system at all

### Scenario: Admission Quota Exceeded
**Problem:** Course shows more admissions than quota allows.
**Solution:**
- Review admission list for the course
- Identify most recent admissions
- Remove PENDING admissions if possible
- Request quota increase from management
- Consider transferring some students to related courses
- Document over-admission with justification

### Scenario: Bulk Upload Fails
**Problem:** Excel file upload returns errors.
**Solution:**
- Verify file is .xls format (not .xlsx)
- Check template structure matches required format
- Remove empty rows from Excel file
- Verify all JAMB numbers are valid
- Ensure all required columns are filled
- Check for special characters or formatting issues
- Try uploading smaller batches
- Review upload report for specific error messages

### Scenario: Wrong Course Selected During Upload
**Problem:** Uploaded admissions to wrong course.
**Solution:**
- If admissions are still PENDING:
  - Navigate to admission list for wrong course
  - Remove all incorrectly placed admissions
  - Re-upload to correct course
- If admissions are ACCEPTED:
  - Contact system administrator
  - May require database correction
  - Document the error for audit trail

### Scenario: Need to Change Merit Type
**Problem:** Applicant admitted with wrong merit type.
**Solution:**
- No direct edit function available
- Must remove and re-add:
  - Remove admission (if PENDING)
  - Add again with correct merit type
- If not PENDING:
  - Contact system administrator
  - May require database update
- Document reason for change

### Scenario: Applicant Applied for Wrong Course
**Problem:** Applicant wants to change course choice.
**Solution:**
- Use "Select Course Admitted into" dropdown
- Admit to desired course (different from applied course)
- Original application remains unchanged
- Admission record shows new course
- Applicant registers for new course
- No need to modify original application

---

## Important Notes for Administrators

1. **Session Limitation:** Can only process admissions for current active session. Cannot backdate or future-date.

2. **Course Scope:** Limited to undergraduate courses from schools S001 and S003. Postgraduate handled separately.

3. **File Format Critical:** Must use .xls format. Newer .xlsx format not supported by upload system.

4. **One Course Per Upload:** Bulk upload processes one course at a time. Cannot upload multiple courses in one file.

5. **Verification Essential:** Always check upload report before leaving page. Errors may not be immediately obvious.

6. **PENDING Status Only:** Can only remove admissions with PENDING status. Other statuses require different process.

7. **No Edit Function:** Cannot edit admission details. Must remove and re-add with correct information.

8. **Quota Monitoring:** System shows quota but doesn't prevent over-admission. Manual monitoring required.

9. **Merit Type Distribution:** Ensure compliance with institutional policy on merit type percentages.

10. **Backup Important:** Keep copies of upload files and exported lists for audit and recovery purposes.

---

## Training Summary

During today's training session, the client was introduced to the **UTME Admissions** functionality, which serves as the central hub for processing undergraduate admissions. The key takeaways include:

- Understanding the admission statistics table and its columns
- Ability to add individual applicants to admission lists
- Using the bulk upload feature for efficient processing
- Understanding merit types and their significance
- Monitoring admission quotas and progress
- Viewing detailed admission lists by course
- Removing incorrectly admitted applicants
- Navigating between overview and detail pages
- Exporting admission data for reporting
- Following best practices for admission processing
- Understanding UTME vs Direct Entry distinctions
- Managing admission status and workflow

This module is essential for the admission process as it controls which applicants receive offers and ensures compliance with admission quotas and merit type distributions.

---

## Critical Warnings Recap

⚠️ **FILE FORMAT:** Must use .xls (Excel 97-2003) format. Newer .xlsx format will fail.

⚠️ **VERIFY UPLOADS:** Always check upload report after bulk upload. Errors may not be obvious.

⚠️ **ONE COURSE PER UPLOAD:** Each Excel upload is for a single course only.

⚠️ **QUOTA MONITORING:** System shows quota but doesn't prevent over-admission. Monitor manually.

⚠️ **PENDING STATUS ONLY:** Can only remove admissions with PENDING status through this interface.

⚠️ **NO EDIT FUNCTION:** Cannot edit admission details. Must remove and re-add.

⚠️ **CURRENT SESSION ONLY:** Can only process admissions for current active application session.

⚠️ **BACKUP FILES:** Keep copies of upload files and exported lists for audit purposes.

---

**Report Prepared By:** Training Team  
**Pages Analyzed:** 
- adminadmissionlist.jsp (UTME Admissions Overview)
- adminadmissionview.jsp (Admission List Details)  
**System:** EduPortal v1.0  
**Classification:** Critical Admissions Management Function
