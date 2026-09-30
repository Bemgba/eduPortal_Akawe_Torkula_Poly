# Complete Admission to Student Workflow

## Overview
This document explains the complete journey from uploading admission list to creating student records.

---

## The Complete Workflow

### Stage 1: Upload Admission List
**Page:** `adminadmissionlist.jsp`  
**Servlet:** `UploadJambAdmissionlist.java`

**Tables Updated:**
1. **ADMISSIONS** - INSERT (status = "PENDING")
2. **APPLICANTS** - UPDATE (status = "ADMITTED")

**Result:** Applicants are now in ADMISSIONS table with status "PENDING"

---

### Stage 2: View Applicants for Clearance
**Page:** `adminclearApplicantS001.jsp`

**Purpose:** Shows courses with admitted vs cleared statistics

**Display:**
- Total Admitted (from ADMISSIONS table)
- Total Cleared (from STUDENTS table)
- Quota (from ADMISSIONTEMPLATE table)

**Action:** Admin clicks "View" to see applicants for a specific course

---

### Stage 3: Clear Individual Applicants
**Page:** `adminclearApplicantS001b.jsp`

**Display:** List of applicants with status "PENDING" or "CLEARED"

**AJAX Function:**
```javascript
async function clearApplicant(appid) {
    const url = "AjaxServlet?action=clearApplicant&id2=" + escape(appid);
    // Calls backend to clear applicant
}
```

**Action:** Admin clicks "CLEAR" button for each applicant

---

### Stage 4: The Clearing Process (THE KEY STAGE)
**Method:** `MainSession.clearApplicant(id, user)`

This is where STUDENTS and STUDENTPROGRESSION are created!


## The clearApplicant() Method - Complete Breakdown

```java
public void clearApplicant(String id, Users user) {
    Admissions adm = this.getAdmissions(id);
    if (adm != null) {
        // STEP 1: Update Admission Status
        adm.setAdmissionStatus("CLEARED");
        this.addUpdateAdmission(adm);
        
        // STEP 2: Update User Role
        Users usd = this.getUsers(id);
        if (usd != null) {
            this.updateUserRole(adm.getId(), 1059); // Change to STUDENT role
        }
        
        // STEP 3: Create STUDENTS Record
        Students std = this.getStudentsById(id);
        if (std != null) {
            // Student already exists, skip
        } else {
            std = new Students(id);
            std.setAddedBy(user);
            std.setClassAdmitted(adm.getCourseId().getDefaultMinLevel() + "");
            std.setCourseId(adm.getCourseId());
            std.setCurrentClass(adm.getCourseId().getDefaultMinLevel() + "");
            std.setDateAdded(settings.getCurrentDateTime());
            std.setDateOfBirth(adm.getDateOfBirth());
            std.setGender(adm.getGender());
            std.setLga(adm.getLgaId());
            std.setModeOfEntry(adm.getModeOfEntry());
            std.setNationality(adm.getNationalityId());
            std.setOthernames(adm.getOthernames());
            std.setRegistrationNo(adm.getId());
            std.setSessionAdmitted(adm.getSession());
            std.setStateOfOrigin(adm.getStateOfOriginId());
            std.setSurname(adm.getSurname());
            this.newStudent(std);
            
            // STEP 4: Create STUDENTPROGRESSION Record
            String idd = adm.getSession().split("/")[0] + adm.getId() + settings.generateId("", 4);
            Studentprogression proggSecond = new Studentprogression(idd);
            proggSecond.setCourseId(adm.getCourseId());
            proggSecond.setDateAdded(settings.getCurrentDateTime());
            proggSecond.setLevelAdded(adm.getCourseId().getDefaultMinLevel() + "");
            proggSecond.setRegistrationStatus("0");
            proggSecond.setSemesterAdded("First");
            proggSecond.setSessionAdded(adm.getSession());
            proggSecond.setStatus(adm.getId());
            proggSecond.setStudentsId(std);
            this.newEntry(proggSecond);
        }
        
        // STEP 5: Generate Admission Letter
        if (adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S006")) {
            this.generateAdmissionLetterSW(adm.getId(), "s202410818");
        } else if (adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S002")) {
            this.generateAdmissionLetterPG(adm.getId(), "s202410818");
        } else {
            this.generateAdmissionLetter(adm.getId(), "s202410818");
        }
    }
}
```

---

## Tables Updated During Clearing

### 1. ADMISSIONS Table (UPDATE)
**Field Updated:**
- `admission_status` = "CLEARED" (changed from "PENDING")

**SQL:**
```sql
UPDATE admissions 
SET admission_status = 'CLEARED' 
WHERE id = ?
```

---

### 2. USERS Table (UPDATE)
**Field Updated:**
- `default_role` = 1059 (STUDENT role, changed from 1063 APPLICANT role)

**SQL:**
```sql
UPDATE users 
SET default_role = 1059 
WHERE id = ?
```

**Impact:** User can now login as STUDENT and access student dashboard

---

### 3. STUDENTS Table (INSERT) ⭐ NEW RECORD CREATED

**Fields Populated:**
```java
id = admission_id
added_by = current_user
class_admitted = course.defaultMinLevel (e.g., "100")
course_id = admission.course_id
current_class = course.defaultMinLevel (e.g., "100")
date_added = NOW()
date_of_birth = admission.date_of_birth
gender = admission.gender
lga = admission.lga_id
mode_of_entry = admission.mode_of_entry
nationality = admission.nationality_id
othernames = admission.othernames
registration_no = admission.id
session_admitted = admission.session
state_of_origin = admission.state_of_origin_id
surname = admission.surname
```

**SQL:**
```sql
INSERT INTO students (
    id,
    added_by,
    class_admitted,
    course_id,
    current_class,
    date_added,
    date_of_birth,
    gender,
    lga,
    mode_of_entry,
    nationality,
    othernames,
    registration_no,
    session_admitted,
    state_of_origin,
    surname
) VALUES (?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

---

### 4. STUDENTPROGRESSION Table (INSERT) ⭐ NEW RECORD CREATED

**Fields Populated:**
```java
id = session_year + admission_id + random_4_digits (e.g., "2024pg2024001ABCD")
course_id = admission.course_id
date_added = NOW()
level_added = course.defaultMinLevel (e.g., "100")
registration_status = "0" (not registered yet)
semester_added = "First"
session_added = admission.session
status = admission.id
students_id = student_record
```

**SQL:**
```sql
INSERT INTO studentprogression (
    id,
    course_id,
    date_added,
    level_added,
    registration_status,
    semester_added,
    session_added,
    status,
    students_id
) VALUES (?, ?, NOW(), ?, '0', 'First', ?, ?, ?)
```

**Purpose:** Tracks student's academic progression through levels/semesters

---

## Summary of Database Changes

### Before Clearing:
- **ADMISSIONS:** status = "PENDING"
- **APPLICANTS:** status = "ADMITTED"
- **USERS:** default_role = 1063 (APPLICANT)
- **STUDENTS:** No record
- **STUDENTPROGRESSION:** No record

### After Clearing:
- **ADMISSIONS:** status = "CLEARED" ✅
- **APPLICANTS:** status = "ADMITTED" (unchanged)
- **USERS:** default_role = 1059 (STUDENT) ✅
- **STUDENTS:** New record created ✅
- **STUDENTPROGRESSION:** New record created ✅

---

## Complete Timeline

### 1. Upload Admission List
**When:** Admin uploads Excel file  
**Tables:** ADMISSIONS (INSERT), APPLICANTS (UPDATE to "ADMITTED")  
**Status:** Applicant is now "ADMITTED" but not yet a student

### 2. Admin Reviews Applicants
**When:** Admin views clearance page  
**Action:** Reviews list of admitted applicants  
**Status:** Still "PENDING" in ADMISSIONS table

### 3. Admin Clears Applicant (THE TRANSFORMATION)
**When:** Admin clicks "CLEAR" button  
**Method:** `clearApplicant(id, user)`  
**Tables Updated:**
- ADMISSIONS: status → "CLEARED"
- USERS: default_role → 1059 (STUDENT)
- STUDENTS: NEW RECORD CREATED
- STUDENTPROGRESSION: NEW RECORD CREATED

**Status:** Applicant is now a STUDENT!

### 4. Student Can Now Login
**When:** Immediately after clearing  
**Access:** Student dashboard  
**Role:** STUDENT (1059)  
**Features:** Can register for courses, view results, make payments

---

## Key Points

1. **STUDENTS table is created during CLEARING, not during admission upload**

2. **STUDENTPROGRESSION is created at the same time as STUDENTS**

3. **User role changes from APPLICANT (1063) to STUDENT (1059)**

4. **Admission status changes from "PENDING" to "CLEARED"**

5. **Student starts at level defined by course.defaultMinLevel (usually "100")**

6. **Registration status is initially "0" (not registered)**

7. **Admission letter is generated automatically**

---

## The Reverse Process: unClearApplicant()

If admin needs to reverse the clearing:

```java
public void unClearApplicant(String id, Users user) {
    // 1. Change admission status back to PENDING
    adm.setAdmissionStatus("PENDING");
    
    // 2. Change user role back to APPLICANT
    this.updateUserRole(adm.getId(), 1063);
    
    // 3. Delete STUDENTPROGRESSION records
    List<Studentprogression> plist = this.getStudentprogression(id);
    for (Studentprogression da : plist) {
        this.deleteStudentprogression(da.getId());
    }
    
    // 4. Delete STUDENTS record
    this.deleteStudent(id);
}
```

**Result:** Student becomes applicant again

---

## Workflow Diagram

```
ADMISSION LIST UPLOAD
    ↓
ADMISSIONS Table (status = "PENDING")
APPLICANTS Table (status = "ADMITTED")
    ↓
ADMIN REVIEWS APPLICANTS
    ↓
ADMIN CLICKS "CLEAR" BUTTON
    ↓
clearApplicant() METHOD EXECUTES
    ↓
┌─────────────────────────────────────┐
│ 1. ADMISSIONS: status = "CLEARED"  │
│ 2. USERS: role = 1059 (STUDENT)    │
│ 3. STUDENTS: NEW RECORD ⭐          │
│ 4. STUDENTPROGRESSION: NEW RECORD ⭐│
│ 5. ADMISSION LETTER: GENERATED      │
└─────────────────────────────────────┘
    ↓
APPLICANT IS NOW A STUDENT
    ↓
CAN LOGIN TO STUDENT DASHBOARD
CAN REGISTER FOR COURSES
CAN VIEW RESULTS
CAN MAKE PAYMENTS
```

---

## Conclusion

**Answer to your questions:**

1. **After applicants status is updated to "ADMITTED":**
   - They appear in the clearance page
   - Admin reviews and clicks "CLEAR" button
   - `clearApplicant()` method is called

2. **STUDENTS table is created:**
   - During the CLEARING process
   - When admin clicks "CLEAR" button
   - Inside `clearApplicant()` method
   - NOT during admission list upload

3. **STUDENTPROGRESSION is created:**
   - At the same time as STUDENTS
   - Inside `clearApplicant()` method
   - Immediately after STUDENTS record is created
   - Tracks student's level and semester

**The key insight:** Admission upload creates ADMISSIONS records, but STUDENTS and STUDENTPROGRESSION are only created when admin explicitly CLEARS the applicant!
