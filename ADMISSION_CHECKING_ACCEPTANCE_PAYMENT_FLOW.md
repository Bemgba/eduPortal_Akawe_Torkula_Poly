# Admission Checking & Acceptance Letter Payment Flow

## Overview
This document explains how applicants pay for "Admission Checking" and "Acceptance Letter" fees, which are required before they can be cleared to become students.

---

## Payment Categories

The system has TWO payment categories:

### 1. Applicants Payments
- **Category:** "Applicants"
- **Page:** `website_epayment_applicants.jsp`
- **Who:** Prospective students (UTME, DE, PG, etc.)
- **When:** Before admission clearance

### 2. Students Payments
- **Category:** "Students"  
- **Page:** `website_epayment_student.jsp`
- **Who:** Cleared students
- **When:** After admission clearance

---

## Fee Group Visibility: PUBLIC vs PRIVATE

### PUBLIC Fee Groups
- **Accessible:** Without login (public payment page)
- **Method:** `sess.getFeesgroupBySchoolAndCategory(schoolId, category, "PUBLIC")`
- **Examples:** Application Fee, Admission Checking, Acceptance Letter

### PRIVATE Fee Groups
- **Accessible:** Only after login (requires authentication)
- **Method:** `sess.getFeesgroupBySchoolAndCategory(schoolId, category, "PRIVATE")`
- **Examples:** School Fees, Hostel Fees, Special Payments
- **Display:** Shows warning message with "Login Here" button

---

## Applicants Payment Flow (Admission Checking & Acceptance Letter)

### Step 1: Access Public Payment Page
**URL:** `/epayment` → Select "Applicants" → `/website_epayment_applicants.jsp`

### Step 2: Verify Identity
```jsp
<form action="" method="POST">
    <input type="text" name="appid" placeholder="Applicant ID" required />
    <input type="submit" name="button" value="Confirm Details"/>
</form>
```

**Backend:**
```jsp
String appid = request.getParameter("appid");
Applicants stdx = sess.getApplicants(appid);
if (stdx != null) {
    session.setAttribute("APPX", stdx);
}
```

### Step 3: Display Applicant Details
Shows:
- Full Name
- Applicant ID
- School
- Course
- Current Session

### Step 4: Select Payment Type
```jsp
<select name="feesgroup">
    <option value="">Select One</option>
    <%
        List<Feesgroup> feesg = sess.getFeesgroupBySchoolAndCategory(
            appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), 
            "Applicants",
            "PUBLIC"
        );
        for (Feesgroup fg : feesg) {
    %>
    <option value="<%=fg.getId()%>"><%=fg.getName()%></option>
    <%
        }
    %>
</select>
```

**Key Method:**
```java
sess.getFeesgroupBySchoolAndCategory(schoolId, "Applicants", "PUBLIC")
```

**Returns:** All PUBLIC fee groups for applicants in that school, including:
- Application Fee
- **Admission Checking** ⭐
- **Acceptance Letter** ⭐
- Screening Fee
- etc.

### Step 5: Generate Invoice
```jsp
<input type="submit" name="generate" value="Generate invoice"/>
```

**Backend Processing:**
```jsp
String feesgroup = request.getParameter("feesgroup");
String generate = request.getParameter("generate");

if (generate != null && generate.length() > 0) {
    PaymentreferenceDetail prd = sess.createApplicantsPayments(
        appx.getId(), 
        feesgroup, 
        sm.getName(), 
        "Session"
    );
    
    if (prd.getPayref().length() > 0) {
        // Store payment details in session
        session.setAttribute("FEESSETUP", feessetup);
        session.setAttribute("regno", appx.getId());
        session.setAttribute("fullname", appx.getSurname() + " " + appx.getOthernames());
        // ... more attributes
        
        // Redirect to invoice page
        response.sendRedirect("/invoice?return=" + returnurl);
    }
}
```

### Step 6: Pay Invoice
- Invoice page displays payment details
- Applicant makes payment via payment gateway
- Payment record created in `payments` table

---

## Students Payment Flow (After Clearance)

### Step 1: Access Public Payment Page
**URL:** `/epayment` → Select "Students" → `/website_epayment_student.jsp`

### Step 2: Verify Identity
```jsp
<input type="text" name="studentid" placeholder="Student ID" required />
```

**Backend:**
```jsp
String studentid = request.getParameter("studentid");
Students stdx = sess.getStudentsById(studentid);
if (stdx != null) {
    session.setAttribute("STDX", stdx);
}
```

### Step 3: Select Session
```jsp
<select name='sessions'>
    <%
        Collection<Studentprogression> cl = stdy.getStudentprogressionCollection();
        List<String> sessionsx = new ArrayList();
        for (Studentprogression sp : cl) {
            if (!sessionsx.contains(sp.getSessionAdded())) {
                sessionsx.add(sp.getSessionAdded());
            }
        }
        for (String sess : sessionsx) {
    %>
    <option value="<%=sess%>"><%=sess%></option>
    <%
        }
    %>
</select>
```

### Step 4: Select Payment Type
```jsp
<select name="feesgroup" id='feesgroup'>
    <%
        List<Feesgroup> feesg = sess.getFeesgroupBySchoolAndCategory(
            schoolId, 
            "Students",
            "PUBLIC"
        );
        for (Feesgroup fg : feesg) {
    %>
    <option value="<%=fg.getId()%>"><%=fg.getName()%></option>
    <%
        }
    %>
</select>
```

**Returns:** All PUBLIC fee groups for students, such as:
- School Fees
- Acceptance Fee (if applicable)
- Transcript Fee
- etc.

---

## The Key Method: getFeesgroupBySchoolAndCategory

```java
public List<Feesgroup> getFeesgroupBySchoolAndCategory(
    String schoolId, 
    String category, 
    String visibility
) {
    List<Feesgroup> list = new ArrayList();
    try {
        list = (List<Feesgroup>) em.createQuery(
            "SELECT f FROM Feesgroup f " +
            "WHERE f.schoolId.id = :schoolId " +
            "AND f.category = :category " +
            "AND f.visibility = :visibility " +
            "ORDER BY f.name ASC"
        )
        .setParameter("schoolId", schoolId)
        .setParameter("category", category)
        .setParameter("visibility", visibility)
        .getResultList();
    } catch (Exception k) {
    }
    return list;
}
```

**Parameters:**
- `schoolId`: e.g., "S001", "S002", "S003"
- `category`: "Applicants" or "Students"
- `visibility`: "PUBLIC" or "PRIVATE"

**SQL Equivalent:**
```sql
SELECT * FROM feesgroup 
WHERE school_id = ? 
AND category = ? 
AND visibility = ?
ORDER BY name ASC
```

---

## Fee Group Configuration

### Database Table: FEESGROUP

**Key Fields:**
- `id`: Primary key
- `name`: e.g., "Admission Checking", "Acceptance Letter"
- `school_id`: e.g., "S001"
- `category`: "Applicants" or "Students"
- `visibility`: "PUBLIC" or "PRIVATE"
- `amount`: Fee amount (optional, can be in FEESSETUP)

### Example Records:

```sql
-- Admission Checking (PUBLIC - accessible without login)
INSERT INTO feesgroup (id, name, school_id, category, visibility) 
VALUES ('FG001', 'Admission Checking', 'S001', 'Applicants', 'PUBLIC');

-- Acceptance Letter (PUBLIC - accessible without login)
INSERT INTO feesgroup (id, name, school_id, category, visibility) 
VALUES ('FG002', 'Acceptance Letter', 'S001', 'Applicants', 'PUBLIC');

-- School Fees (PRIVATE - requires login)
INSERT INTO feesgroup (id, name, school_id, category, visibility) 
VALUES ('FG003', 'School Fees', 'S001', 'Students', 'PRIVATE');
```

---

## Settings Configuration

### Settings.java or Configuration File

```java
public class Settings {
    // Fee group names used for clearance validation
    public String admissionChecking = "Admission Checking";
    public String acceptanceLetter = "Acceptance Letter";
}
```

These values are used in `adminclearApplicantS001b.jsp`:
```jsp
Feesgroup check = sess.getFeesgroupByNameAndSchool(settings.admissionChecking, data.getSchoolId().getId());
Feesgroup accep = sess.getFeesgroupByNameAndSchool(settings.acceptanceLetter, data.getSchoolId().getId());
```

---

## Complete Payment Workflow

### For Applicants (Before Clearance):

```
1. Applicant uploads UTME data
    ↓
2. Admin adds to ADMISSIONS table (status = "PENDING")
    ↓
3. Applicant goes to /epayment → Applicants
    ↓
4. Enters Applicant ID
    ↓
5. Selects "Admission Checking" from dropdown
    ↓
6. Generates invoice
    ↓
7. Makes payment
    ↓
8. Payment record created in PAYMENTS table
    ↓
9. Repeats steps 5-8 for "Acceptance Letter"
    ↓
10. Admin goes to clearance page
    ↓
11. System checks: pay1.size() > 0 && pay2.size() > 0
    ↓
12. If TRUE: Shows "CLEAR" button
    ↓
13. Admin clicks "CLEAR"
    ↓
14. clearApplicant() method executes
    ↓
15. STUDENTS and STUDENTPROGRESSION created
    ↓
16. User role changes to STUDENT
    ↓
17. Applicant is now a STUDENT!
```

---

## Troubleshooting

### Issue: "No Checking and/or acceptance" message

**Possible Causes:**

1. **Fee groups don't exist**
   ```sql
   SELECT * FROM feesgroup 
   WHERE name IN ('Admission Checking', 'Acceptance Letter')
   AND school_id = 'S001';
   ```
   
2. **Fee groups not PUBLIC**
   ```sql
   SELECT * FROM feesgroup 
   WHERE name IN ('Admission Checking', 'Acceptance Letter')
   AND visibility = 'PUBLIC';
   ```

3. **Fee groups wrong category**
   ```sql
   SELECT * FROM feesgroup 
   WHERE name IN ('Admission Checking', 'Acceptance Letter')
   AND category = 'Applicants';
   ```

4. **Payments not made**
   ```sql
   SELECT * FROM payments 
   WHERE regno = '202440027349eahh2'
   AND feesgroup_id IN (
       SELECT id FROM feesgroup 
       WHERE name IN ('Admission Checking', 'Acceptance Letter')
   );
   ```

5. **Session mismatch**
   ```sql
   -- Check admission session
   SELECT session FROM admissions WHERE id = '202440027349eahh2';
   
   -- Check payment session
   SELECT session FROM payments WHERE regno = '202440027349eahh2';
   ```

---

## Summary

**Admission Checking & Acceptance Letter payments are:**

1. ✅ **PUBLIC** fee groups (accessible without login)
2. ✅ **Category: "Applicants"** (not "Students")
3. ✅ **Paid via** `/website_epayment_applicants.jsp`
4. ✅ **Required before** clearance
5. ✅ **Checked by** clearance page before showing "CLEAR" button
6. ✅ **Both must be paid** for clearance to proceed

**The payment flow:**
- Applicant → Public Payment Page → Select Fee Group → Generate Invoice → Pay → Record in PAYMENTS table → Admin can clear applicant
