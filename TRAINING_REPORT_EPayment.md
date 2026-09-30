# Training Activity Report - E-Payment System
**Date:** February 12, 2026  
**Client:** EduPortal  
**Pages/Modules:** 
- website_epayment_applicants.jsp (Applicant Payment)
- website_epayment_student.jsp (Student Payment)

---

## Overview
The **E-Payment System** consists of two interconnected pages that handle online payment processing for applicants and students. These pages serve as the gateway to the payment system, allowing users to:
1. Verify their identity using ID numbers
2. View their personal and academic details
3. Select payment types (fee groups)
4. Generate payment invoices
5. Proceed to payment gateway
6. Complete fee payments online

The system integrates with the fees setup module to calculate amounts based on multiple factors including school, course, level, semester, indigene status, and fee categories configured in the adminfeesSetup module.

---

## Page Access & Security
- **Access Control:** Public pages (no authentication required)
- **User Types:** 
  - Applicants (prospective students)
  - Students (admitted/registered students)
- **URL Paths:** 
  - Applicants: `/website_epayment_applicants` or `/epayment_applicants`
  - Students: `/website_epayment_student` or `/epayment_students`
- **Authorization Level:** Open to public with ID verification
- **Purpose:** Fee payment processing

---

## PART 1: Applicant Payment System (website_epayment_applicants.jsp)

### 1. **Applicant Identity Verification**

The page requires applicants to verify their identity before proceeding.

#### Verification Form:

**Applicant ID Field** (Required)
- Text input for applicant identification
- Accepts multiple ID formats:
  - UTME registration number
  - Application number
  - JAMB number
- Automatically converted to lowercase
- Trimmed of whitespace
- Pattern validation: alphanumeric, hyphens, underscores
- Maximum length: 50 characters
- Security: Input sanitization to prevent injection attacks

**Confirm Details Button:** Validates and retrieves applicant information

**Alternative Entry:**
- Encrypted ID parameter in URL
- Auto-confirms without manual entry
- Format: `?id=[encrypted-applicant-id]`
- Useful for direct links from emails or portals

---

### 2. **Applicant Details Display**

After successful verification, the system displays comprehensive applicant information.

#### Information Displayed:

**Personal Information:**
- **Full Name:** Surname and other names
- **Applicant ID:** Unique identifier

**Academic Information:**
- **School:** School/faculty name
- **Course:** Programme applied for
- **Current Session:** Active application session

**Session Status:**
- **OPEN:** Payments can be processed
- **CLOSED:** Payments blocked with warning message

---

### 3. **Fee Group Selection for Applicants**

Applicants can select from available payment types.

#### Payment Categories:

**PUBLIC Fee Groups:**
- Visible to all applicants
- Can be paid without login
- Examples:
  - Application Fees
  - Screening Fees
  - Acceptance Fees
  - Registration Fees

**PRIVATE Fee Groups:**
- Require login to access
- Not shown on public payment page
- Warning message displayed
- Link to login page provided
- Examples:
  - Special fees
  - Conditional payments
  - Restricted fee types

#### Fee Group Dropdown:
- Populated based on:
  - Applicant's school
  - Category: "Applicants"
  - Visibility: "PUBLIC"
- Dynamic loading from database
- Shows fee group names
- Required selection before invoice generation

---

### 4. **Applicant Fee Calculation Process**

The system calculates fees based on multiple factors from the fees setup.

#### Calculation Factors:

**School-Based:**
- Applicant's school ID
- School-specific fee structures

**Course-Based:**
- Applicant's chosen course
- Course-specific fees
- Faculty-level fees
- Department-level fees

**Session-Based:**
- Current application session
- Session-specific rates
- Semester: "Session" (full year)

**Fee Group:**
- Selected payment type
- Associated fee items
- Configured amounts

**Level:**
- Set to "None" for applicants
- Applicants don't have levels yet
- Level-specific fees not applied

**Indigene Status:**
- From applicant's profile
- State of origin
- LGA (Local Government Area)
- Differential pricing if configured

#### Fee Retrieval Process:
1. System calls `sess.createApplicantsPayments()`
2. Parameters passed:
   - Applicant ID
   - Fee group ID
   - Session name
   - Semester: "Session"
3. Backend retrieves all applicable fees from `Feessetup` table
4. Filters by:
   - School match
   - Course/Department/Faculty scope
   - Fee group match
   - Session match
   - Semester match
   - Indigene status match
   - Level scope (None or All)
5. Sums all applicable fee amounts
6. Creates payment reference
7. Returns payment reference details

---

### 5. **Invoice Generation for Applicants**

After selecting fee group, applicants can generate payment invoices.

#### Generation Process:

**Generate Invoice Button:**
- Validates fee group selection
- Calls payment creation method
- Creates payment reference
- Stores session data
- Redirects to invoice page

**Session Data Stored:**
- `FEESSETUP`: List of applicable fees
- `level`: "None" (applicants don't have levels)
- `sessions`: Current session name
- `feesgroup`: Selected fee group ID
- `sesssem`: "Session"
- `regno`: Applicant ID
- `fullname`: Applicant's full name
- `coursename`: Applied course name
- `phoneno`: Applicant's phone number
- `email`: Applicant's email address
- `id`: Applicant ID
- `pr`: Payment reference object

**Payment Reference Creation:**
- Unique reference number generated
- Links to applicant
- Links to fee group
- Records session and semester
- Stores total amount
- Status: PENDING
- Timestamp recorded

**Redirect to Invoice:**
- URL: `/invoice?return=[encrypted-return-url]`
- Return URL: `/epayment` (encrypted)
- Invoice page displays:
  - Applicant details
  - Fee breakdown
  - Total amount
  - Payment reference
  - Payment gateway options

---

### 6. **Session Status Validation**

The system checks if the application session is open for payments.

#### Status Checks:

**OPEN Session:**
- Payments allowed
- Fee groups displayed
- Invoice generation enabled
- Normal payment flow

**CLOSED Session:**
- Payments blocked
- Warning message displayed:
  - "Sorry, session [Session Name] is marked closed hence no payment can be made on it."
  - "Kindly check back later to see if a new session is opened"
- Fee group selection hidden
- Invoice generation disabled

**No Session Configured:**
- Warning message:
  - "Your session has not been set by the institution management."
  - "Kindly check back later."
- Payment interface hidden
- Applicant must wait for session setup

---

## PART 2: Student Payment System (website_epayment_student.jsp)

### 7. **Student Identity Verification**

Similar to applicants but with different ID formats.

#### Verification Form:

**Student ID Field** (Required)
- Accepts multiple ID formats:
  - UTME registration number
  - Application number
  - Matriculation number (Matric No)
  - University email address
- Automatically converted to lowercase
- Trimmed of whitespace
- Flexible matching

**Confirm Details Button:** Validates and retrieves student information

---

### 8. **Student Details Display**

After successful verification, comprehensive student information is displayed.

#### Information Displayed:

**Personal Information:**
- **Full Name:** Surname and other names
- **Student ID:** Matric number or registration number

**Academic Information:**
- **School:** School/faculty name
- **Course:** Programme enrolled in
- **Current Level:** Student's academic level (100, 200, 300, etc.)

**Session Selection:**
- Dropdown with student's progression sessions
- Shows all sessions student has been registered
- Sorted in reverse order (most recent first)
- Allows payment for current or past sessions

---

### 9. **Fee Group Selection for Students**

Students can select from available payment types.

#### Payment Categories:

**PUBLIC Fee Groups:**
- Visible to all students
- Can be paid without login
- Examples:
  - School Fees
  - Acceptance Fees
  - Hostel Fees
  - Medical Fees
  - Library Fees

**PRIVATE Fee Groups:**
- Require login to access
- Not shown on public payment page
- Warning message displayed
- Link to login page provided
- Examples:
  - Penalty fees
  - Special charges
  - Conditional payments

#### Fee Group Dropdown:
- Populated based on:
  - Student's school
  - Category: "Students"
  - Visibility: "PUBLIC"
- Dynamic loading from database
- Shows fee group names

---

### 10. **Session/Semester Selection**

Students must select session and semester for payment.

#### Dynamic Semester Loading:

**Fee Group Selection Triggers:**
- JavaScript function `loadSesssem()` called
- AJAX request to server
- Parameters: Fee group ID
- Returns applicable semesters

**Semester Options:**
- Based on fee group configuration
- Options may include:
  - First Semester
  - Second Semester
  - Session (full year)
  - Both Semesters
- Dynamically populated dropdown

**Purpose:**
- Different fees for different semesters
- Allows semester-specific payments
- Ensures correct fee calculation

---

### 11. **Student Fee Calculation Process**

The system calculates fees based on comprehensive factors.

#### Calculation Factors:

**School-Based:**
- Student's school ID
- School-specific fee structures

**Course-Based:**
- Student's enrolled course
- Course-specific fees
- Faculty-level fees
- Department-level fees

**Level-Based:**
- Student's current level
- Level-specific fees
- Spillover considerations
- Year-specific rates

**Session-Based:**
- Selected session
- Session-specific rates
- Historical sessions supported

**Semester-Based:**
- Selected semester
- Semester-specific fees
- Prorated amounts if applicable

**Fee Group:**
- Selected payment type
- Associated fee items
- Configured amounts

**Indigene Status:**
- From student's profile
- State of origin
- LGA (Local Government Area)
- Differential pricing if configured

**Programme Type:**
- Full-time, Part-time, etc.
- Programme-specific rates

**On-Campus Status:**
- Residential or non-residential
- Hostel-related fees

#### Fee Retrieval Process:
1. System calls `sess.createStudentsPayments()`
2. Parameters passed:
   - Student ID
   - Fee group ID
   - Session name
   - Semester selection
3. Backend retrieves student's level for selected session
4. Queries `Feessetup` table with filters:
   - School match
   - Course/Department/Faculty scope
   - Fee group match
   - Session match
   - Semester match
   - Level match or "All"
   - Indigene status match
   - Programme type match
   - On-campus status match
5. Applies fee hierarchy (Course > Department > Faculty > School)
6. Sums all applicable fee amounts
7. Creates payment reference
8. Returns payment reference details

---

### 12. **Invoice Generation for Students**

After selecting all parameters, students can generate invoices.

#### Generation Process:

**Generate Invoice Button:**
- Validates all selections:
  - Session selected
  - Fee group selected
  - Semester selected
- Calls payment creation method
- Retrieves student's level for selected session
- Creates payment reference
- Stores session data
- Redirects to invoice page

**Session Data Stored:**
- `FEESSETUP`: List of applicable fees
- `STDY`: Student object
- `level`: Student's level for selected session
- `sessions`: Selected session
- `feesgroup`: Selected fee group ID
- `sesssem`: Selected semester
- `regno`: Matric number or registration number
- `fullname`: Student's full name
- `coursename`: Enrolled course name
- `phoneno`: Student's phone number
- `email`: University or personal email
- `id`: Student ID
- `pr`: Payment reference object

**Level Determination:**
- Searches student's progression records
- Finds level for selected session
- Uses "None" if not found
- Critical for correct fee calculation

**Redirect to Invoice:**
- URL: `/invoice?return=[encrypted-return-url]`
- Return URL: `/epayment` (encrypted)
- Invoice page displays:
  - Student details
  - Fee breakdown by item
  - Total amount
  - Payment reference
  - Payment gateway options

---

## Fee Calculation Examples

### Example 1: Applicant Application Fee

**Scenario:** UTME applicant paying application fee for Computer Science

**Applicant Details:**
- School: School of Sciences
- Course: Computer Science
- Session: 2024/2025
- Indigene Status: Non-indigene

**Fee Setup Configuration:**
- Fee Group: "APPLICATION FEES"
- Fee Items:
  1. Application Processing Fee
     - Scope: All faculties (None)
     - Level: None (not applicable)
     - Indigene: All
     - Amount: ₦5,000
  
  2. Screening Fee
     - Scope: School of Sciences
     - Level: None
     - Indigene: All
     - Amount: ₦3,000

**Calculation:**
- Application Processing Fee: ₦5,000 (applies to all)
- Screening Fee: ₦3,000 (applies to Sciences)
- **Total: ₦8,000**

---

### Example 2: Student School Fees (Indigene)

**Scenario:** 200-level indigene student paying school fees

**Student Details:**
- School: School of Engineering
- Course: Electrical Engineering
- Level: 200
- Session: 2024/2025
- Semester: First Semester
- Indigene Status: Indigene
- State: Same as institution

**Fee Setup Configuration:**
- Fee Group: "SCHOOL FEES"
- Fee Items:
  1. Tuition Fee
     - Scope: All faculties
     - Level: All
     - Indigene: Indigene
     - Amount: ₦50,000
  
  2. Lab Fee
     - Scope: Engineering Faculty
     - Level: All
     - Indigene: All
     - Amount: ₦15,000
  
  3. Department Fee
     - Scope: Electrical Engineering Dept
     - Level: 200
     - Indigene: All
     - Amount: ₦5,000

**Calculation:**
- Tuition Fee: ₦50,000 (indigene rate)
- Lab Fee: ₦15,000 (Engineering faculty)
- Department Fee: ₦5,000 (specific to EE, 200 level)
- **Total: ₦70,000**

---

### Example 3: Student School Fees (Non-Indigene)

**Scenario:** Same student but non-indigene

**Student Details:**
- Same as Example 2 except:
- Indigene Status: Non-indigene
- State: Different from institution

**Fee Setup Configuration:**
- Fee Group: "SCHOOL FEES"
- Fee Items:
  1. Tuition Fee
     - Scope: All faculties
     - Level: All
     - Indigene: Non-indigene
     - Amount: ₦75,000 (higher rate)
  
  2. Lab Fee
     - Scope: Engineering Faculty
     - Level: All
     - Indigene: All
     - Amount: ₦15,000
  
  3. Department Fee
     - Scope: Electrical Engineering Dept
     - Level: 200
     - Indigene: All
     - Amount: ₦5,000

**Calculation:**
- Tuition Fee: ₦75,000 (non-indigene rate - ₦25,000 more)
- Lab Fee: ₦15,000 (same)
- Department Fee: ₦5,000 (same)
- **Total: ₦95,000**

**Difference:** Non-indigene pays ₦25,000 more

---

### Example 4: Course-Specific Fee

**Scenario:** Student in special programme with course-specific fees

**Student Details:**
- School: School of Sciences
- Course: Marine Biology
- Level: 300
- Session: 2024/2025
- Semester: Second Semester

**Fee Setup Configuration:**
- Fee Group: "SCHOOL FEES"
- Fee Items:
  1. Tuition Fee
     - Scope: All
     - Level: All
     - Amount: ₦60,000
  
  2. Field Trip Fee
     - Scope: Marine Biology (Course-specific)
     - Level: 300
     - Semester: Second
     - Amount: ₦30,000

**Calculation:**
- Tuition Fee: ₦60,000 (all students)
- Field Trip Fee: ₦30,000 (only Marine Biology 300-level, 2nd semester)
- **Total: ₦90,000**

**Note:** Other courses don't pay field trip fee

---

## Technical Features

### Security Implementations

**Input Sanitization:**
- Removes special characters
- Prevents SQL injection
- Limits input length
- Pattern validation
- XSS prevention

**URL Encryption:**
- Return URLs encrypted
- Payment references encrypted
- Prevents tampering
- Secure redirects

**Session Management:**
- Secure session storage
- Timeout handling
- Data validation
- Clean session data

### Database Operations

**Applicant Payment Creation:**
```
sess.createApplicantsPayments(applicantId, feeGroupId, session, semester)
```
- Retrieves applicant details
- Gets fee group configuration
- Queries fees setup table
- Filters applicable fees
- Calculates total
- Creates payment reference
- Returns reference details

**Student Payment Creation:**
```
sess.createStudentsPayments(studentId, feeGroupId, session, semester)
```
- Retrieves student details
- Gets student's level for session
- Gets fee group configuration
- Queries fees setup table
- Applies complex filters
- Calculates total
- Creates payment reference
- Returns reference details

**Fee Group Retrieval:**
```
sess.getFeesgroupBySchoolAndCategory(schoolId, category, visibility)
```
- Filters by school
- Filters by category (Applicants/Students)
- Filters by visibility (PUBLIC/PRIVATE)
- Returns list of fee groups

**Session Manager Retrieval:**
```
sess.getCurrentSessionManagerBySchoolAndOperation(schoolId, operation)
```
- Gets current active session
- Filters by school
- Filters by operation (APPLICATION/REGISTRATION)
- Returns session details

### AJAX Functionality

**Dynamic Semester Loading:**
```javascript
function loadSesssem() {
    const feeGroupId = document.getElementById("feesgroup").value;
    fetch("AjaxServlet?action=loadsesssem&id=" + feeGroupId)
        .then(response => response.text())
        .then(data => {
            document.getElementById("sesssem").innerHTML = data;
        });
}
```
- Triggered when fee group selected
- Fetches applicable semesters
- Updates semester dropdown
- Seamless user experience

### User Interface Features

**Auto-Scroll:**
- Scrolls to details card after verification
- Smooth animation
- Highlight effect
- Improves user experience

**Responsive Design:**
- Two-column layout
- Mobile-friendly
- Touch-optimized
- Adaptive spacing

**Visual Feedback:**
- Success messages
- Error messages
- Warning alerts
- Loading states



---

## Practical Use Cases

### Use Case 1: Applicant Paying Application Fee
**Scenario:** A UTME applicant needs to pay application fee.

**Steps:**
1. Navigate to `/website_epayment_applicants`
2. See verification form
3. Enter Applicant ID: "2024/12345678"
4. Click "Confirm Details"
5. System retrieves applicant information
6. Details displayed:
   - Name: JOHN DOE
   - School: School of Sciences
   - Course: Computer Science
   - Session: 2024/2025
7. Session status: OPEN
8. Fee group dropdown shows:
   - APPLICATION FEES
   - SCREENING FEES
9. Select "APPLICATION FEES"
10. Click "Generate invoice"
11. System calculates fees:
    - Application Processing: ₦5,000
    - Screening Fee: ₦3,000
    - Total: ₦8,000
12. Payment reference created
13. Redirected to invoice page
14. Invoice shows breakdown
15. Proceed to payment gateway
16. Complete payment

---

### Use Case 2: Student Paying School Fees
**Scenario:** A 200-level student needs to pay first semester school fees.

**Steps:**
1. Navigate to `/website_epayment_student`
2. Enter Student ID: "ENG/2023/001"
3. Click "Confirm Details"
4. System retrieves student information
5. Details displayed:
   - Name: JANE SMITH
   - School: School of Engineering
   - Course: Electrical Engineering
   - Current Level: 200
6. Session dropdown shows:
   - 2024/2025 (current)
   - 2023/2024 (previous)
7. Select "2024/2025"
8. Fee group dropdown shows:
   - SCHOOL FEES
   - HOSTEL FEES
   - MEDICAL FEES
9. Select "SCHOOL FEES"
10. Semester dropdown loads dynamically
11. Shows: First Semester, Second Semester
12. Select "First Semester"
13. Click "Generate invoice"
14. System calculates fees based on:
    - Level: 200
    - Indigene status
    - Course: Electrical Engineering
    - Faculty: Engineering
15. Total calculated: ₦70,000
16. Payment reference created
17. Redirected to invoice
18. Complete payment

---

### Use Case 3: Non-Indigene Student Paying Higher Fees
**Scenario:** Non-indigene student pays higher tuition rate.

**Steps:**
1. Student verifies identity
2. Details show: Non-indigene status
3. Selects school fees
4. System calculates with non-indigene rate:
   - Tuition: ₦75,000 (vs ₦50,000 for indigene)
   - Other fees: Same
5. Total: ₦95,000 (₦25,000 more than indigene)
6. Invoice shows breakdown
7. Student sees differential pricing
8. Proceeds with payment

---

### Use Case 4: Applicant with Closed Session
**Scenario:** Applicant tries to pay but session is closed.

**Steps:**
1. Applicant verifies identity
2. Details displayed correctly
3. Session status shows: CLOSED
4. Warning message appears:
   - "Sorry, session 2024/2025 is marked closed"
   - "No payment can be made on it"
   - "Check back later"
5. Fee group dropdown hidden
6. Generate invoice button disabled
7. Applicant must wait for new session
8. Or contact administration

---

### Use Case 5: Student Paying for Previous Session
**Scenario:** Student needs to clear previous session fees.

**Steps:**
1. Student verifies identity
2. Session dropdown shows:
   - 2024/2025 (current)
   - 2023/2024 (previous - unpaid)
3. Select "2023/2024"
4. Select fee group
5. System retrieves student's level for 2023/2024:
   - Was 100 level then
6. Calculates fees based on 100 level rates
7. Generates invoice
8. Student pays outstanding fees
9. Can now proceed with current session

---

### Use Case 6: Private Fee Group Warning
**Scenario:** Student sees private fee groups are available.

**Steps:**
1. Student verifies identity
2. Details displayed
3. Warning message appears:
   - "Private Payments Available: PENALTY FEES, LATE REGISTRATION"
   - "To pay for these items, please login to your student account"
   - Login button provided
4. Public fee groups still shown
5. Student can:
   - Pay public fees without login
   - Or login to access private fees
6. Clicks "Login Here" if needs private fees
7. Redirected to login page
8. After login, accesses full payment portal

---

### Use Case 7: Course-Specific Field Trip Fee
**Scenario:** Marine Biology student pays field trip fee.

**Steps:**
1. Student verifies identity
2. Course: Marine Biology
3. Level: 300
4. Selects school fees
5. Selects Second Semester
6. System calculates:
   - Regular tuition: ₦60,000
   - Field Trip Fee: ₦30,000 (course-specific)
   - Total: ₦90,000
7. Other courses don't see field trip fee
8. Only Marine Biology 300-level, 2nd semester
9. Invoice shows breakdown
10. Student proceeds with payment

---

### Use Case 8: Direct Link from Email
**Scenario:** Applicant receives payment link in email.

**Steps:**
1. Email contains link:
   - `/website_epayment_applicants?id=[encrypted-id]`
2. Applicant clicks link
3. Page loads with encrypted ID
4. System auto-decrypts ID
5. Auto-confirms applicant details
6. Details displayed immediately
7. No manual ID entry needed
8. Applicant proceeds directly to fee selection
9. Convenient, secure process

---

### Use Case 9: Invalid ID Entry
**Scenario:** User enters wrong ID format.

**Steps:**
1. User enters ID: "INVALID123@#$"
2. Clicks "Confirm Details"
3. Input validation fails
4. Pattern validation prevents submission
5. Or server-side validation catches it
6. Error message: "Invalid applicant ID format"
7. User corrects ID
8. Enters valid format
9. Verification succeeds

---

### Use Case 10: Multiple Fee Items Calculation
**Scenario:** Student with multiple applicable fees.

**Steps:**
1. Student: 400-level Engineering
2. Selects school fees
3. System finds applicable fees:
   - Tuition (All students): ₦60,000
   - Lab Fee (Engineering): ₦15,000
   - Department Fee (Electrical Eng): ₦5,000
   - Project Fee (400-level): ₦20,000
   - Library Fee (All): ₦3,000
4. Total calculated: ₦103,000
5. Invoice shows all items
6. Student sees complete breakdown
7. Understands what each fee is for
8. Proceeds with payment

---

## Important Concepts

### Fee Hierarchy and Precedence

**Scope Levels (Most Specific to Least Specific):**
1. **Course Scope** - Applies to specific course only
2. **Department Scope** - Applies to all courses in department
3. **Faculty Scope** - Applies to all departments in faculty
4. **School Scope** - Applies to entire school
5. **"None" Scope** - Applies universally

**How It Works:**
- System checks all scopes
- Applies fees from all matching scopes
- More specific fees don't override less specific
- All applicable fees are summed
- Example: Student pays both faculty-wide lab fee AND course-specific field trip fee

### Level-Based Fee Calculation

**For Students:**
- Level determined from progression records
- Fees filtered by level match
- "All" level fees apply to everyone
- "None" level fees not applicable to students
- Specific level fees (100, 200, etc.) apply only to that level

**For Applicants:**
- Level set to "None"
- Only fees with level "None" or "All" apply
- Level-specific fees excluded
- Simpler calculation

### Indigene Status Impact

**Differential Pricing:**
- Indigene: Lower rates (local students)
- Non-indigene: Higher rates (non-local students)
- "All": Same rate for both
- "None": Status not considered

**Determination:**
- Based on state of origin
- Compared with institution's state
- Stored in student/applicant profile
- Applied automatically in calculation

### Session and Semester Specificity

**Session-Based:**
- Fees tied to specific sessions
- Historical sessions supported
- Allows payment for past sessions
- Current session rates applied

**Semester-Based:**
- First Semester fees
- Second Semester fees
- Session (full year) fees
- Prorated amounts possible

### Public vs Private Fee Groups

**PUBLIC:**
- Visible without login
- Can be paid on public page
- Examples: Application fees, School fees
- Accessible to all

**PRIVATE:**
- Require login to access
- Not shown on public page
- Examples: Penalty fees, Special charges
- Restricted access

---

## Best Practices & Recommendations

### For Applicants:

1. **Verify ID Carefully:** Ensure correct JAMB/Application number
2. **Check Session Status:** Confirm session is OPEN
3. **Select Correct Fee Group:** Choose appropriate payment type
4. **Save Payment Reference:** Keep reference number for tracking
5. **Complete Payment Promptly:** Don't delay after invoice generation
6. **Keep Receipt:** Save payment confirmation
7. **Contact Support:** If issues arise during payment

### For Students:

1. **Use Correct ID:** Matric number or registration number
2. **Select Right Session:** Ensure paying for correct academic year
3. **Choose Correct Semester:** First, Second, or Session
4. **Verify Level:** Check level matches your current status
5. **Review Breakdown:** Understand what each fee is for
6. **Pay on Time:** Avoid late payment penalties
7. **Keep Records:** Save all payment receipts

### For Administrators:

1. **Configure Fees Properly:** Ensure fees setup is correct
2. **Set Session Status:** Open/close sessions appropriately
3. **Monitor Payments:** Track payment processing
4. **Update Fee Groups:** Keep fee groups current
5. **Test Calculations:** Verify fee calculations are accurate
6. **Provide Support:** Assist users with payment issues
7. **Maintain Gateway:** Ensure payment gateway is operational

---

## Common Scenarios & Solutions

### Scenario: Fee Calculation Seems Wrong
**Problem:** Student thinks fees are incorrect.
**Solution:**
- Review fee breakdown on invoice
- Check student's level for selected session
- Verify indigene status
- Check course/department/faculty fees
- Compare with fees setup configuration
- Contact administration if still unclear

### Scenario: Cannot Generate Invoice
**Problem:** Generate button doesn't work.
**Solution:**
- Ensure all fields selected:
  - Session (for students)
  - Fee group
  - Semester (for students)
- Check session status is OPEN
- Verify fee group has configured fees
- Try different browser
- Contact support if persistent

### Scenario: Private Fees Not Visible
**Problem:** User needs to pay private fee.
**Solution:**
- Private fees require login
- Click "Login Here" button
- Login to student/applicant account
- Access payment portal from dashboard
- Private fees will be visible
- Complete payment from portal

### Scenario: Wrong Session Selected
**Problem:** Generated invoice for wrong session.
**Solution:**
- Don't proceed with payment
- Go back to payment page
- Re-verify identity
- Select correct session
- Generate new invoice
- Previous reference will expire

### Scenario: Session Marked Closed
**Problem:** Cannot make payment, session closed.
**Solution:**
- Session closed by administration
- Cannot process payments
- Wait for new session to open
- Or contact administration
- May need special approval
- Check back regularly

---

## Training Summary

During today's training session, the client was introduced to the **E-Payment System** functionality, which handles online fee payments for both applicants and students. The key takeaways include:

- Understanding the two-page payment system (applicants and students)
- Identity verification process using ID numbers
- Fee group selection and categorization (PUBLIC vs PRIVATE)
- Comprehensive fee calculation based on multiple factors:
  - School, Course, Faculty, Department
  - Level, Session, Semester
  - Indigene status
  - Fee group configuration
- Integration with fees setup module (adminfeesSetup.jsp)
- Invoice generation and payment reference creation
- Session status validation (OPEN vs CLOSED)
- Dynamic semester loading based on fee group
- Payment gateway integration
- Security features and input validation

This module is critical for revenue collection and ensures accurate fee calculation based on the complex fee structures configured in the fees setup module. Proper understanding of fee calculation factors ensures students and applicants are charged correctly.

---

## Critical Warnings Recap

⚠️ **FEE CALCULATION COMPLEXITY:** Fees calculated based on multiple factors. Verify fees setup is correct.

⚠️ **SESSION STATUS:** Payments only possible when session is OPEN. Closed sessions block payments.

⚠️ **LEVEL DETERMINATION:** Student fees depend on level for selected session. Wrong level = wrong fees.

⚠️ **INDIGENE STATUS:** Significant price differences between indigene and non-indigene. Verify status.

⚠️ **PRIVATE FEE GROUPS:** Require login to access. Not visible on public payment page.

⚠️ **PAYMENT REFERENCE:** Once generated, reference is tied to specific fees. Don't generate multiple times.

⚠️ **SEMESTER SELECTION:** Critical for students. Wrong semester = wrong fees.

⚠️ **FEE HIERARCHY:** All applicable fees from all scopes are summed. Not just most specific.

---

**Report Prepared By:** Training Team  
**Pages Analyzed:** 
- website_epayment_applicants.jsp (Applicant Payment)
- website_epayment_student.jsp (Student Payment)  
**System:** EduPortal v1.0  
**Classification:** Critical Payment Processing Function
