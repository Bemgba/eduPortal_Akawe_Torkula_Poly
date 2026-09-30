# Admission List Upload - Tables Updated

## Overview
When an admission list Excel file is uploaded via `adminadmissionlist.jsp`, the system processes each row and updates multiple database tables.

---

## Upload Process Flow

### 1. User Action
- Admin navigates to `adminadmissionlist.jsp`
- Clicks "Upload admission list" button
- Selects a course from dropdown
- Uploads Excel file (.xls format)
- Clicks "Upload Admission" button

### 2. Form Submission
```jsp
<form action='UploadJambAdmissionlist' method='post' enctype="multipart/form-data">
    <select name="courses">...</select>
    <input type="file" name="uploadfile" accept=".xls" />
    <input type="submit" name="button3" value="Upload Admission"/>
</form>
```

### 3. Backend Processing
Servlet: `UploadJambAdmissionlist.java`

---

## Tables Updated

### Table 1: **ADMISSIONS** (Primary Table)

**Operation:** INSERT or UPDATE

**Method:** `sess.addUpdateAdmission(adm)`

**Fields Populated:**
```java
Admissions adm = new Admissions(appno);
adm.setAdmissionStatus("PENDING");              // admission_status
adm.setAdmissionStatusComment("");              // admission_status_comment
adm.setDateAdded(settings.getCurrentDateTime()); // date_added
adm.setCourseId(cos);                           // course_id
adm.setDateOfBirth(app.getDateOfBirth());       // date_of_birth
adm.setGender(app.getGender());                 // gender
adm.setLgaId(app.getLga());                     // lga_id
adm.setMaritalStatus(app.getMaritalStatus());   // marital_status
adm.setMeritType(meritstatus);                  // merit_type (from Excel)
adm.setModeOfEntry(moe);                        // mode_of_entry (from Excel)
adm.setNationalityId(app.getCountry());         // nationality_id
adm.setOthernames(app.getOthernames());         // othernames
adm.setProgrammeId(app.getProgrammeId());       // programme_id
adm.setRegistrationNo(app.getId());             // registration_no
adm.setReligion("");                            // religion
adm.setSchoolId(app.getSchoolId());             // school_id
adm.setSession(sessmanx.getName());             // session
adm.setStateOfOriginId(app.getStateOfOrigin()); // state_of_origin_id
adm.setSurname(app.getSurname());               // surname
```

**SQL Equivalent:**
```sql
INSERT INTO admissions (
    id,
    admission_status,
    admission_status_comment,
    date_added,
    course_id,
    date_of_birth,
    gender,
    lga_id,
    marital_status,
    merit_type,
    mode_of_entry,
    nationality_id,
    othernames,
    programme_id,
    registration_no,
    religion,
    school_id,
    session,
    state_of_origin_id,
    surname
) VALUES (?, 'PENDING', '', NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '', ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE
    admission_status = 'PENDING',
    course_id = ?,
    merit_type = ?,
    mode_of_entry = ?,
    ...
```

**Data Source:**
- Most fields copied from `applicants` table
- `merit_type` from Excel column 4 (e.g., "NM", "SM", "ELG", "LM", "SPECIAL")
- `mode_of_entry` from Excel column 3 (e.g., "UTME", "DE")
- `course_id` from form selection (course admitted into)
- `admission_status` set to "PENDING"
- `session` from current session manager

---

### Table 2: **APPLICANTS** (Status Update)

**Operation:** UPDATE

**Method:** `sess.changeApplicantStatus(appno, "ADMITTED")`

**Field Updated:**
```java
Applicants ss = em.find(Applicants.class, appno);
if (ss != null) {
    ss.setStatus("ADMITTED");  // status field
}
```

**SQL Equivalent:**
```sql
UPDATE applicants 
SET status = 'ADMITTED' 
WHERE id = ?
```

**Purpose:**
- Marks the applicant as "ADMITTED" in the applicants table
- Changes status from previous value (e.g., "PENDING", "SUBMITTED") to "ADMITTED"
- This prevents the applicant from appearing in pending applications lists

---

## Excel File Structure

### Required Columns:
1. **Column 0 (A):** Serial Number (SNO)
2. **Column 1 (B):** Application Number / JAMB Number (e.g., "pg2024001")
3. **Column 2 (C):** Mode of Entry (e.g., "UTME", "DE")
4. **Column 3 (D):** Merit Status (e.g., "NM", "SM", "ELG", "LM", "SPECIAL")

### Example Excel Data:
```
| SNO | JAMB NO    | MODE OF ENTRY | MERIT STATUS |
|-----|------------|---------------|--------------|
| 1   | pg2024001  | UTME          | NM           |
| 2   | pg2024002  | DE            | SM           |
| 3   | pg2024003  | UTME          | ELG          |
```

---

## Processing Logic for Each Row

### Step 1: Read Excel Row
```java
String sno = sheet.getCell(0, row).getContents();        // Serial number
String appno = sheet.getCell(1, row).getContents();      // Application number
String moe = sheet.getCell(2, row).getContents();        // Mode of entry
String meritstatus = sheet.getCell(3, row).getContents(); // Merit status
```

### Step 2: Find Applicant
```java
appno = appno.trim().toLowerCase();
Applicants app = sess.getApplicantsById(appno);
```

### Step 3: Validate Session
```java
if (app.getSession().equalsIgnoreCase(sessmanx.getName())) {
    // Process admission
}
```

### Step 4: Create Admission Record
```java
Admissions adm = new Admissions(appno);
// Set all fields from applicant + Excel data
sess.addUpdateAdmission(adm);
```

### Step 5: Update Applicant Status
```java
sess.changeApplicantStatus(appno, "ADMITTED");
```

---

## Summary of Database Changes

### For Each Successful Row in Excel:

1. **ADMISSIONS Table:**
   - 1 new record inserted (or existing record updated)
   - Contains applicant details + course admitted + merit type + mode of entry
   - Status set to "PENDING"

2. **APPLICANTS Table:**
   - 1 record updated
   - Status changed from previous value to "ADMITTED"

### Example: Upload 100 Applicants

**Database Changes:**
- **ADMISSIONS table:** 100 new records inserted
- **APPLICANTS table:** 100 records updated (status changed to "ADMITTED")

**Total:** 200 database operations (100 inserts + 100 updates)

---

## Validation Rules

### 1. Applicant Must Exist
```java
Applicants app = sess.getApplicantsById(appno);
if (app != null) {
    // Process
} else {
    remarks = "Application records does not exist";
}
```

### 2. Applicant Must Be in Current Session
```java
if (app.getSession().equalsIgnoreCase(sessmanx.getName())) {
    // Process
} else {
    remarks = "Applicant not in current session";
}
```

### 3. Course Must Be Selected
```java
String courseId = request.getParameter("courses");
if (courseId == null || courseId.isEmpty()) {
    response.getWriter().println("Error: Please select a course.");
    return;
}
```

---

## Upload Report

After processing, the system generates an Excel report with:

### Report Columns:
1. **SNO:** Serial number
2. **JAMB NO:** Application number
3. **FULLNAME:** Applicant's full name
4. **COURSE APPLIED:** Original course applied for
5. **COURSE ADMITTED:** Course admitted into
6. **CRITERIA:** Merit type (NM, SM, ELG, LM, SPECIAL)
7. **REMARKS:** Success or error message

### Possible Remarks:
- **"SUCCESS"** - Admission record created successfully
- **"Application records does not exist"** - Applicant not found
- **"Applicant not in current session"** - Session mismatch

### Report File:
- **Filename:** `AdmissionUploadReport_[courseId].xls`
- **Type:** Excel file (.xls)
- **Download:** Automatically downloaded after upload

---

## Data Flow Diagram

```
Excel File Upload
    ↓
Read Excel Rows (skip header)
    ↓
For Each Row:
    ↓
1. Extract: appno, moe, meritstatus
    ↓
2. Find Applicant (applicants table)
    ↓
3. Validate Session
    ↓
4. Create Admission Record
   ↓
   INSERT INTO admissions (...)
    ↓
5. Update Applicant Status
   ↓
   UPDATE applicants SET status = 'ADMITTED'
    ↓
6. Add to Report
    ↓
Generate Excel Report
    ↓
Download Report to Admin
```

---

## Tables NOT Updated

The following tables are NOT updated during admission list upload:

1. **USERS** - Not updated (user accounts remain unchanged)
2. **STUDENTS** - Not created yet (created later when applicant is "cleared")
3. **STUDENTPROGRESSION** - Not created yet
4. **PAYMENTS** - Not affected
5. **COURSES** - Not modified (only referenced)
6. **SESSIONMANAGER** - Not modified (only referenced)

**Note:** The `STUDENTS` table is only populated when an admin "clears" the admitted applicant (changes status from "PENDING" to "CLEARED"). This is done via the `clearApplicant()` method, which is a separate process.

---

## Key Points

1. **Two Tables Updated:**
   - `admissions` (INSERT/UPDATE)
   - `applicants` (UPDATE status only)

2. **Admission Status:**
   - Initially set to "PENDING"
   - Must be changed to "CLEARED" later to create student record

3. **Applicant Status:**
   - Changed from previous status to "ADMITTED"
   - Prevents duplicate processing

4. **Data Source:**
   - Most data copied from `applicants` table
   - Merit type and mode of entry from Excel file
   - Course admitted from form selection

5. **Validation:**
   - Applicant must exist
   - Applicant must be in current session
   - Course must be selected

6. **Report:**
   - Excel report generated for verification
   - Shows success/failure for each row
   - Downloaded automatically

---

## Related Processes

### After Upload:
1. **View Admission List** - Admin reviews uploaded admissions
2. **Clear Applicants** - Admin changes status to "CLEARED"
3. **Create Student Records** - System creates entries in `students` table
4. **Generate Admission Letters** - System creates admission letters

### Methods Involved:
- `sess.addUpdateAdmission()` - Inserts/updates admissions table
- `sess.changeApplicantStatus()` - Updates applicants status
- `sess.clearApplicant()` - Creates student record (separate process)

---

## Conclusion

When an admission list Excel file is uploaded via `adminadmissionlist.jsp`:

**Tables Updated:**
1. ✅ **ADMISSIONS** - New records inserted with status "PENDING"
2. ✅ **APPLICANTS** - Status updated to "ADMITTED"

**Tables NOT Updated:**
- ❌ USERS
- ❌ STUDENTS (created later during "clearing")
- ❌ STUDENTPROGRESSION (created later during "clearing")
- ❌ PAYMENTS
- ❌ COURSES
- ❌ SESSIONMANAGER

**Total Operations Per Row:**
- 1 INSERT (admissions)
- 1 UPDATE (applicants)
- **Total: 2 database operations per applicant**
