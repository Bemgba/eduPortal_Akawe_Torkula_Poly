# Training Activity Report - UTME Applicants Upload
**Date:** February 12, 2026  
**Client:** EduPortal  
**Page/Module:** UTME Applicants Upload (admuploadutmeapplicants.jsp)

---

## Overview
The **admuploadutmeapplicants.jsp** page is a comprehensive administrative interface for managing UTME (Unified Tertiary Matriculation Examination) applicants within the EduPortal system. This page serves as the central hub for importing applicant data from JAMB CAPS (Central Admissions Processing System) into the university portal. It provides administrators with powerful tools to upload applicant information, passports, O-Level results, and Post-UTME scores, as well as view and filter uploaded applicants.

---

## Page Access & Security
- **Access Control:** The page is protected and requires user authentication
- **User Type:** Accessible only to staff members with appropriate administrative privileges
- **URL Path:** `/app_adm_upload`
- **Authorization Level:** High-level admissions administrative access required
- **Session-Based:** All uploads are tied to the current active application session

---

## Core Functionality

### 1. **Upload UTME Applicants Data**

The primary function is to import applicant records from JAMB CAPS into the university system.

#### Upload Form:

**File Selection:**
- File input field accepting .xls format only
- Microsoft Excel 97-2003 Workbook format required
- Template provided for download: `templates/applicants_list_utme.xls`

**Upload Button:** Processes the Excel file and imports applicant records

#### Data Imported:
- JAMB Registration Number (unique identifier)
- Surname and Other Names
- Course Applied For (First Choice)
- Gender
- State of Origin
- Local Government Area (LGA)
- Application Type (UTME)
- Session (automatically set to current application session)
- UTME Subject Scores (English and 3 other subjects)
- Total UTME Score

#### Upload Process:
1. Select Excel file (.xls format)
2. Click "Upload" button
3. System displays animated progress bar
4. File is uploaded (0-40% progress)
5. Data is processed and validated (40-95% progress)
6. Records are inserted into database
7. Upload report is generated (95-100% progress)
8. Success message displays with statistics
9. Report auto-downloads showing successful and failed records

#### Validation Rules:
- JAMB number must be unique
- Course code must exist in the system
- State and LGA must be valid
- UTME subjects must exist in database
- Gender must be valid (Male/Female)
- All required fields must be present

#### Success/Error Handling:
- **Success Message:** "Applicants Upload: [X] records uploaded successfully, [Y] errors/skipped"
- **Error Message:** "Upload Error: [specific error details]"
- **Upload Summary:** Displays total records, successful uploads, and errors
- **Detailed Report:** Auto-downloads Excel file with row-by-row results

---

### 2. **Upload Applicant Passports**

Upload passport photographs for multiple applicants simultaneously.

#### Upload Form:

**File Selection:**
- Multiple file input (can select multiple images at once)
- Accepts .jpg format only
- No template needed

**File Naming Convention:**
- Files must be named with JAMB registration numbers
- Format: `[JAMB_NUMBER].jpg`
- Example: `202440202794ef.jpg`
- Case-insensitive

**Upload Button:** Processes all selected image files

#### Upload Process:
1. Select multiple .jpg files
2. System reads filename to extract JAMB number
3. Matches JAMB number to existing applicant
4. Uploads and stores passport image
5. Associates image with applicant record

#### Validation Rules:
- File must be .jpg format
- Filename must match existing JAMB number
- Image file size limits apply
- Only one passport per applicant

#### Success/Error Handling:
- Success message shows number of passports uploaded
- Error message lists files that couldn't be processed
- Unmatched JAMB numbers are reported

---

### 3. **Upload O-Level Results**

Import O-Level examination results for applicants.

#### Upload Form:

**File Selection:**
- File input accepting .xls format only
- Template provided: `templates/utme_olevel.xls`

**Upload Button:** Processes O-Level results file

#### Data Imported:
- JAMB Registration Number
- Examination Type (WAEC, NECO, NABTEB, etc.)
- Examination Year
- Examination Number
- Subject and Grade pairs (multiple subjects per applicant)
- Sitting Number (First or Second sitting)

#### Upload Process:
1. Select Excel file with O-Level data
2. Click "Upload" button
3. System validates JAMB numbers against existing applicants
4. Processes subject-grade combinations
5. Creates O-Level result records
6. Links results to applicant profiles

#### Validation Rules:
- JAMB number must exist in system
- Examination type must be valid
- Subjects must be valid O-Level subjects
- Grades must be valid (A1, B2, B3, C4, C5, C6, D7, E8, F9)
- Minimum 5 subjects required

#### Success/Error Handling:
- **Success Message:** "O-Level Upload: [X] records uploaded successfully"
- Error message shows records that failed validation
- Report indicates missing or invalid data

---

### 4. **Upload Post-UTME Results**

Import Post-UTME screening test scores for applicants.

#### Upload Form:

**File Selection:**
- File input accepting .xls format only
- Template provided: `templates/utme_postutme.xls`

**Upload Button:** Processes Post-UTME scores

#### Data Format:
Excel file must contain only 3 columns:
- **S/NO:** Serial number
- **JAMB_NO:** JAMB registration number
- **SCORE:** Post-UTME score

#### Upload Process:
1. Select Excel file with Post-UTME scores
2. Click "Upload" button
3. System validates JAMB numbers
4. Updates applicant records with Post-UTME scores
5. Calculates aggregate scores if needed

#### Validation Rules:
- JAMB number must exist
- Score must be numeric
- Score must be within valid range (typically 0-100)
- Only 3 columns allowed in Excel file

#### Success/Error Handling:
- Success message shows number of scores uploaded
- Error message lists invalid JAMB numbers
- Report shows which scores were updated

---

### 5. **View Uploaded Applicants**

Display and filter uploaded UTME applicants with comprehensive filtering options.

#### Filter Options:

**a) All Applicants** (Blue button)
- Shows all UTME applicants for current session
- No filtering applied
- Displays regardless of payment or completion status
- Default view for initial data verification

**b) With Payment** (Yellow button)
- Shows applicants who have made any payment
- Payment can be for any session
- Less strict than "Fully Qualified"
- Useful for identifying applicants who have started the process

**c) Fully Qualified** (Green button - Default)
- Most strict filter
- Shows only applicants meeting ALL criteria:
  - Session matches current application session
  - Application type is UTME
  - Payment record exists with completion date
  - Payment session matches applicant session
  - UTME record exists with total score > 0
- These are applicants ready for admission processing

#### Filter Explanation Display:
- Shows current filter level with badge
- Displays session name
- Provides explanation of what each filter shows
- Includes "View Qualification Rules" button for detailed criteria

---

### 6. **View Applicant List Table**

Comprehensive table displaying applicant information.

#### Table Columns:
- **# (Serial Number):** Sequential numbering
- **UTME No:** JAMB registration number (uppercase)
- **Full Name:** Surname + Other names
- **Course:** Programme applied for
- **Aggregate:** Total UTME score
- **Gender:** Male/Female
- **State:** State of origin
- **More:** View button for detailed information

#### Table Features:
- DataTable integration with search and sort
- Export options: Copy, CSV, Excel, PDF, Print
- Pagination: 25, 50, 100, 200, 500 records per page
- Responsive design
- Real-time filtering

#### Pagination:
- Displays 2000 records per page
- Multiple page buttons for large datasets
- Current page highlighted in gray
- Other pages shown in yellow
- Click page number to navigate

---

### 7. **View Individual Applicant Details**

Click "View" button on any applicant to see comprehensive details.

#### Basic Information Section:
- JAMB Number (uppercase)
- Full Name
- Course Applied
- Gender
- State of Origin
- Local Government Area
- Application Type (badge)

#### UTME Details Section:
- Total UTME Score (large badge)
- English Score
- Subject 2 with score
- Subject 3 with score
- Subject 4 with score
- Subject names resolved from database

#### Payment Status Section:
Shows one of four states:

**1. Payment Completed (Green Alert)**
- Payment found for current session
- Shows number of payments for the session
- Applicant is financially cleared

**2. Payment for Different Session (Yellow Alert)**
- Payment exists but not for current application session
- Indicates payment mismatch
- May need manual verification

**3. Payment Pending (Blue Alert)**
- Payment records exist but no completion date
- Payment initiated but not confirmed
- Awaiting payment confirmation

**4. No Payment (Red Alert)**
- No payment records found
- Applicant has not paid application fee
- Cannot proceed with admission

#### O-Level Status Section:
Shows one of three states:

**1. O-Level Uploaded (Green Alert)**
- O-Level results exist
- Shows number of subjects uploaded
- Results are complete

**2. O-Level Record Exists (Yellow Alert)**
- O-Level record created but no subject details
- Incomplete upload
- Needs re-upload

**3. No O-Level (Blue Alert)**
- No O-Level results uploaded yet
- Awaiting O-Level data

#### Navigation:
- "Back to List" button returns to applicant list
- Maintains filter and pagination state

