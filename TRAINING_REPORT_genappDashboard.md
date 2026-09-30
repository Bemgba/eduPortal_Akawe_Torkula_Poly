# Training Activity Report - Application Dashboard & Process
**Date:** February 12, 2026  
**Client:** EduPortal  
**Page/Module:** genappDashboard.jsp (Application Dashboard & Information Collection)

---

## Overview
The **Application Dashboard (genappDashboard.jsp)** is the central hub for applicants after registration. This page serves multiple critical functions:
1. **Profile Management** - Creating and updating applicant biodata
2. **Application Creation** - Starting new applications for different programmes
3. **Application Tracking** - Viewing all applications and their completion status
4. **Information Collection** - Gathering comprehensive applicant information
5. **Payment Monitoring** - Tracking payment history
6. **Document Management** - Overview of uploaded documents

This is where applicants spend most of their time, managing their applications from initiation to submission.

---

## Page Access & Security
- **Access Control:** Requires authentication (login)
- **User Type:** Applicants only
- **URL Path:** `/gen_app_dashboard` or `/genappDashboard`
- **Authorization Level:** Applicant role required
- **Session Validation:** 
  - Checks if user session exists
  - Validates role assignment
  - Verifies default home page configuration
- **Security Features:**
  - Session expiry detection
  - Role-based access control
  - Automatic redirect to login if unauthorized

---

## PART 1: Initial Profile Setup (Biodata Creation)

### 1. **First-Time User Experience**

When a new user logs in for the first time after registration, they must complete their biodata profile.

#### Profile Creation Requirement:

**Check for Applicants Record:**
- System checks if user has an `Applicants` record
- If no record exists, user is a new registrant
- Must complete biodata form before accessing other features
- Biodata form is displayed automatically

**Biodata Form Fields:**
- Surname (Required, alphabetic only)
- Other Names (Required, alphabetic only)
- Gender (Male/Female dropdown)
- Date of Birth (Date picker, age 16-90 years)
- Phone Number (11-13 digits, read-only after creation)
- Contact Address (Text field)
- Home Town (Text field)
- Country (Dropdown, dynamically loaded)
- State of Origin (Dropdown, loads based on country)
- Local Government Area (Dropdown, loads based on state)
- Passport Photograph (Image upload, JPG/JPEG/PNG only)

---

### 2. **Biodata Form Validation**

The system performs comprehensive validation on biodata submission.

#### Name Validation:
**Pattern Matching:**
- Regex pattern: `^[A-Za-z]+(\\s[A-Za-z]+)*$`
- Only alphabetic characters allowed
- Spaces allowed between names
- No numbers or special characters
- Minimum 2 characters required

**Whitespace Handling:**
- Automatic trimming of leading/trailing spaces
- Multiple spaces replaced with single space
- Format: `surname.trim().replaceAll("\\s+", " ")`

**Error Messages:**
- "Your full name [name] does not look like a person's name"
- "Kindly review and resubmit"

#### Image Validation:
**Passport Photo Requirements:**
- Accepted formats: .jpg, .jpeg, .png
- Automatic resizing to standard dimensions
- Width: `settings.PASSPORT_WIDTH`
- Height: `settings.PASSPORT_HEIGHT`
- Stored in: `/home/jux1235/passports/[user_id][extension]`
- Database reference: `passports/[user_id][extension]`

---

### 3. **Dynamic Location Loading (AJAX)**

The form uses cascading dropdowns for location selection.

#### Country → State → LGA Hierarchy:

**Step 1: Select Country**
- Dropdown populated with all countries
- JavaScript function: `loadStates()` triggered on change
- AJAX request: `AjaxServlet?action=loadState&id=[country_id]`
- Response updates States dropdown

**Step 2: Select State**
- States dropdown populated based on selected country
- JavaScript function: `loadLgas()` triggered on change
- AJAX request: `AjaxServlet?action=loadlga&id=[state_id]`
- Response updates LGA dropdown

**Step 3: Select LGA**
- LGAs dropdown populated based on selected state
- Final selection for location hierarchy
- All three values required for submission

**Benefits:**
- Reduces page load time (lazy loading)
- Ensures data consistency
- Prevents invalid location combinations
- Improves user experience

---

### 4. **Biodata Submission Process**

After filling the form, applicants submit their biodata.

#### Creation Process:
1. User fills all required fields
2. Clicks "Submit" button (name="button")
3. System validates all inputs
4. Creates `Applicantsbiodata` object with user ID
5. Sets all biodata fields from form
6. Saves passport photo if provided
7. Stores record in database via `sess.newEntry(apb)`
8. Redirects to dashboard with success message

#### Success Response:
- Alert message: "Record added successfully"
- Profile now complete
- Can proceed to create applications
- Dashboard features unlocked

---

## PART 2: Application Creation

### 5. **Starting a New Application**

Once biodata is complete, applicants can create applications.

#### New Application Modal:

**Access:**
- Button: "New Application" on dashboard
- Opens modal dialog
- Shows application creation form

**Form Fields:**

1. **Select School** (Dropdown)
   - Lists all schools in the system
   - Shows session status for each school
   - Disabled if session is CLOSED
   - Label format: "School Name (application closed for Session)" or "(no active session)"
   - Only schools with OPEN sessions are selectable

2. **Select Programme Type** (Dropdown)
   - Dynamically loaded based on selected school
   - JavaScript function: `loadProgrammes()`
   - AJAX request: `AjaxServlet?action=loadSchoolProgrammes&id2=[school_id]`
   - Examples: Full-Time, Part-Time, TVET, Remedial

3. **Select Programme** (Dropdown)
   - Dynamically loaded based on school and programme type
   - JavaScript function: `loadCourses()`
   - AJAX request: `AjaxServlet?action=loadCourses&id2=[school_id]&id3=[programme_type]`
   - Shows available courses for the selected combination

**Submit Button:** "Start Application"

---

### 6. **Application Creation Logic**

When applicant submits the new application form, comprehensive processing occurs.

#### Duplicate Check:
**Before Creating Application:**
- System checks: `sess.hasDuplicateApplicationForCourse(email, course_id)`
- Prevents multiple applications for same course
- If duplicate found:
  - Shows warning alert
  - Displays existing application details
  - Provides link to view existing application
  - Does not create new application

**Duplicate Warning Message:**
- "Duplicate Application Detected"
- Shows existing Application ID
- Shows current status
- Shows session
- Option to view existing application

#### Session Validation:
**Check Active Session:**
- Retrieves session manager: `sess.getCurrentSessionManagerBySchoolAndOperation(school, "APPLICATION")`
- Validates session status is "OPEN"
- If CLOSED: Shows error "Session [name] for application has been closed"
- If no session: Shows error "No active session found"

#### Application ID Generation:

**Format:** `[school_abbr][year][random_5_digits]`

**Example:** `soe2401234`
- `soe` = School abbreviation (lowercase)
- `24` = Last 2 digits of session year (2024/2025 → 24)
- `01234` = Random 5-digit number

**Fallback:** If school abbreviation is null/empty, uses school ID

#### Application Record Creation:
**Fields Populated from Biodata:**
- Surname, Other names
- Gender, Date of Birth
- Email Address, Phone Number
- Contact Address, Home Town
- Country, State of Origin, LGA

**Fields Set from Selection:**
- Course (Course1)
- School ID
- Programme ID
- Application Type (from programme code)
- Session (from session manager)

**System-Generated Fields:**
- Application ID (unique identifier)
- Date Initiated (current timestamp)
- Status: "NOT SUBMITTED"

**Database Operation:**
- Creates `Applicants` object
- Saves via `sess.newEntry(app)`
- Commits to database

#### Success Response:
- Success alert displayed
- Shows application ID
- Shows course name
- Shows session
- Button to "View Application Details"
- Redirects to application details page

---

## PART 3: Dashboard Overview

### 7. **Dashboard Statistics Cards**

The dashboard displays key statistics for the applicant.

#### Statistics Displayed:

**Total Applications:**
- Count of all applications by user
- Color: Blue (bg-primary)
- Icon: File icon
- Shows total number

**Completed Applications:**
- Applications with status "COMPLETED" or "SUBMITTED"
- Color: Green (bg-success)
- Icon: Check circle
- Shows count of submitted applications

**Pending Applications:**
- Applications with status "NOT SUBMITTED" or "PENDING"
- Color: Orange (bg-warning)
- Icon: Clock
- Shows applications needing completion

**Total Payments:**
- Sum of all payment amounts
- Color: Green (bg-success)
- Icon: Money bill
- Shows total amount paid in Naira (₦)

**Interactive Features:**
- Hover effect: Cards lift slightly
- Box shadow increases on hover
- Smooth transitions
- Click to view details (some cards)

---

### 8. **Applications List Table**

The dashboard shows all applications created by the user.

#### Table Columns:

**#** - Serial number

**Application ID** - Unique identifier
- Format: Badge with info color
- Clickable to view details

**Course** - Programme applied for
- Full course name displayed

**Session** - Academic session
- Format: 2024/2025

**Status** - Application status
- Badge with color coding:
  - SUBMITTED: Green (success)
  - COMPLETED: Green (success)
  - NOT SUBMITTED: Orange (warning)
  - PENDING: Yellow (warning)
  - REGISTERED: Blue (info)

**Payment Status** - Payment completion
- Checks if payment exists for application
- Badge colors:
  - PAID: Green (success)
  - NOT PAID: Red (danger)
- Shows payment amount if paid

**Actions** - Available operations
- **View Details:** Eye icon button
  - Opens application details page
  - Shows complete application information
- **Continue Application:** Edit icon button
  - Opens appropriate application form
  - Allows completion of pending sections
- **Download Form:** Download icon button
  - Only for submitted applications
  - Generates PDF of application form

---

### 9. **Application Details View**

When viewing a specific application, comprehensive details are displayed.

#### Navigation:
**URL Format:** `/gen_app_dashboard?id=[encrypted_application_id]`
- ID parameter encrypted for security
- Decrypted on server side
- Loads specific application

**Back Button:** Returns to dashboard main view

#### Completion Progress:

**Progress Bar:**
- Shows percentage complete
- Color-coded:
  - 0-49%: Red (danger)
  - 50-99%: Orange (warning)
  - 100%: Green (success)
- Text: "X of Y sections complete (Z%)"

**Sections Tracked:**
1. Personal Details (including qualification, marital status)
2. Sponsor Information (guardian details)
3. UTME Details (exam scores)
4. O-Level Results (for remedial applications only)
5. Institutions Attended
6. Supporting Documents
7. Payment

**Completion Calculation:**
- Total sections: 6 (or 7 for remedial)
- Completed sections counted
- Percentage = (completed / total) × 100

#### Application Status Alert:

**Status Messages:**

**COMPLETED/SUBMITTED:**
- Alert color: Green (success)
- Message: "Your application has been submitted successfully"
- No action buttons

**READY TO SUBMIT:**
- Alert color: Blue (info)
- Message: "Your application details and payment are complete"
- Button: "Go to Confirm & Submit" (animated pulse)
- Redirects to submission page

**NOT COMPLETED:**
- Alert color: Orange (warning)
- Message: "Your application is not yet submitted"
- Shows missing sections list
- Button: "Complete Application"
- Redirects to application form

---

### 10. **Personal Details Section**

Displays comprehensive personal information from biodata and application.

#### Information Displayed:

**Left Column:**
- Full Name (Surname, Other names)
- Email Address
- Phone Number
- Gender
- Date of Birth
- Qualification

**Right Column:**
- State of Origin
- Local Government Area
- Home Town
- Contact Address
- Marital Status

**Completion Badge:**
- Green "Complete" if all fields filled
- Orange "Incomplete" if any field missin