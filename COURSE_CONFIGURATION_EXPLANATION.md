# Course Configuration System Explanation

## Overview
This document explains how courses are configured as CORE or ELECTIVE, how carry-over courses work, and how credit unit controls are managed in the system.

---

## 1. How Core/Elective Course Categories Work

### Entity Hierarchy
The system uses a multi-level entity structure:

```
Semestercourses (Course Template)
    ↓ (has property: semestercourseCategory)
    ↓
Semesterregistrationcourses (Course Assignment to Programme)
    ↓ (has properties: courseType, courseCategory)
    ↓
Semesterregistration (Student's Actual Registration)
```

### Key Entities

#### A. **Semestercourses** (Course Template)
- **Location**: `src/main/java/com/mnl/eduportal/entities/Semestercourses.java`
- **Purpose**: Defines the base course template for a programme
- **Key Field**: `semestercourseCategory` (String)
- **Possible Values**:
  - `CORE` - Core Course
  - `ELECTIVE` - Elective Course
  - `GENERAL` - General Studies
  - `PRACTICAL` - Practical Course

**Configuration Location**: `adminListSemCourses.jsp` (Add/Edit Semester Course modal)
```jsp
<select class="form-select" id="semestercourseCategory" name="semestercourseCategory">
    <option value="">Select Category</option>
    <option value="CORE">Core Course</option>
    <option value="ELECTIVE">Elective Course</option>
    <option value="GENERAL">General Studies</option>
    <option value="PRACTICAL">Practical Course</option>
</select>
```

#### B. **Semesterregistrationcourses** (Course-Programme Assignment)
- **Location**: `src/main/java/com/mnl/eduportal/entities/Semesterregistrationcourses.java`
- **Purpose**: Links a semester course to a specific programme/course with additional context
- **Key Fields**:
  - `semesterCourseId` → References `Semestercourses`
  - `courseId` → References `Courses` (the programme)
  - `courseType` (String) - Determines how the course appears to students
  - `courseCategory` (String) - Additional categorization
  - `level` - Which level (100, 200, 300, etc.)
  - `semester` - Which semester (First, Second)
  - `courseStatus` - ACTIVE or INACTIVE

**Possible `courseType` Values**:
- `CORE` - Mandatory course for the programme
- `ELECTIVE` - Optional course for the programme
- `GST` - General Studies/EPS courses
- `CARRY OVER` - Failed courses from previous sessions

---

## 2. How a Course Becomes CORE in One Programme but ELECTIVE in Another

### The Configuration Process

1. **Step 1: Create Semester Course Template** (`adminListSemCourses.jsp`)
   - Admin creates a `Semestercourses` record
   - Sets `semestercourseCategory` (e.g., "CORE")
   - This is just a template, not yet assigned to any programme

2. **Step 2: Assign Course to Programme** (`admineditsemestercourses.jsp`)
   - Admin navigates to a specific programme (e.g., Computer Science)
   - Selects level (e.g., 200) and semester (e.g., First)
   - Adds the semester course to that programme
   - Creates a `Semesterregistrationcourses` record with:
     - `semesterCourseId` → The template course
     - `courseId` → Computer Science programme
     - `courseType` → "CORE" (admin decides this)
     - `level` → "200"
     - `semester` → "First"

3. **Step 3: Same Course, Different Programme**
   - Admin navigates to another programme (e.g., Information Technology)
   - Adds the SAME semester course
   - Creates another `Semesterregistrationcourses` record with:
     - `semesterCourseId` → Same template course
     - `courseId` → Information Technology programme
     - `courseType` → "ELECTIVE" (admin decides differently)
     - `level` → "200"
     - `semester` → "First"

### Example Scenario
**Course**: "Database Management Systems" (DMS 201)

**In Computer Science Programme**:
```
Semesterregistrationcourses:
  - semesterCourseId: DMS 201
  - courseId: Computer Science
  - courseType: CORE
  - level: 200
  - semester: First
```

**In Information Technology Programme**:
```
Semesterregistrationcourses:
  - semesterCourseId: DMS 201
  - courseId: Information Technology
  - courseType: ELECTIVE
  - level: 200
  - semester: First
```

---

## 3. How Core Courses Are Determined for a Student

### Location: `stdmyregdet.jsp`

When a student views their registration page, the system:

1. **Retrieves Student's Programme Context**:
   ```java
   Studentprogression sp = (Studentprogression) session.getAttribute("sp");
   // sp contains: courseId, levelAdded, semesterAdded, sessionAdded
   ```

2. **Fetches Available Courses**:
   ```java
   List<Semesterregistrationcourses> regcourses = sess.getSemesterRegistrationCourses(
       sp.getCourseId().getId(),    // Student's programme
       sp.getLevelAdded(),           // Student's current level
       sp.getSemesterAdded(),        // Current semester
       "ACTIVE"                      // Only active courses
   );
   ```

3. **Filters by Course Type**:
   ```java
   // Core courses
   List<Semesterregistrationcourses> coursesCORE = regcourses.stream()
       .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("CORE"))
       .collect(Collectors.toList());
   
   // Elective courses
   List<Semesterregistrationcourses> coursesELECTIVE = regcourses.stream()
       .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("ELECTIVE"))
       .collect(Collectors.toList());
   
   // GST courses
   List<Semesterregistrationcourses> coursesGST = regcourses.stream()
       .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("GST"))
       .collect(Collectors.toList());
   
   // Carry-over courses
   List<Semesterregistrationcourses> coursesCO = regcourses.stream()
       .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("CARRY OVER"))
       .collect(Collectors.toList());
   ```

4. **Displays Courses by Category**:
   - Carry-Over Courses (if any)
   - GST/EPS Courses
   - Core Courses
   - Elective Courses

### Key Point
**Core courses are determined by the `courseType` field in `Semesterregistrationcourses` for that specific programme, level, and semester.**

---

## 4. How Carry-Over Courses Are Configured

### Automatic Configuration (NOT Manual)

Carry-over courses are **NOT manually configured**. They are **dynamically determined** based on student performance.

### How It Works

#### A. **Student Fails a Course**
When a student's result is processed and they fail a course:
```java
Semesterregistration record:
  - studentId: Student's ID
  - semesterRegistrationCourseId: The course they registered
  - passStatus: "1" (indicates FAILED)
  - semester: The semester they took it
  - session: The session they took it
```

#### B. **System Identifies Carry-Overs**
Method: `MainSession.getCarryoversByStudentsAndSemester()`
```java
public List<Semesterregistration> getCarryoversByStudentsAndSemester(String regno, String semester) {
    // Query to find all failed courses for this student in this semester
    ali = em.createQuery(
        "SELECT s FROM Semesterregistration s " +
        "WHERE s.studentId.id = :registrationno " +
        "AND s.semester = :semester " +
        "AND s.passStatus = '1' " +  // passStatus = '1' means FAILED
        "ORDER BY s.session DESC"
    )
    .setParameter("registrationno", regno)
    .setParameter("semester", semester)
    .getResultList();
    
    // Remove duplicates (if student failed same course multiple times)
    for (Semesterregistration de : ali) {
        if (!COExist(ali2, de.getSemesterRegistrationCourseId().getId())) {
            ali2.add(de);
        }
    }
    return ali2;
}
```

#### C. **Carry-Overs Appear in Registration**
When the student registers for the next session:
1. System checks for failed courses (`passStatus = '1'`)
2. Creates `Semesterregistrationcourses` records with `courseType = "CARRY OVER"`
3. These appear at the top of the registration page
4. Student MUST register these courses again

### Key Points About Carry-Overs
- **Automatic**: System automatically identifies based on `passStatus = '1'`
- **Dynamic**: Generated per student based on their performance
- **Priority**: Always shown first in registration interface
- **Mandatory**: Students typically must clear carry-overs before progressing

---

## 5. Credit Unit Controls (Min/Max)

### Configuration Location: `adminCreditUnitControls.jsp`

### Entity: `Semesterregistrationcucontrol`
**Fields**:
- `courseId` → References the programme
- `level` → Level (100, 200, 300, etc.)
- `semester` → Semester (First, Second)
- `mincu` → Minimum credit units allowed
- `maxcu` → Maximum credit units allowed

### How It's Configured

1. **Admin Navigates to Credit Unit Controls**:
   - URL: `/credit_unit_controls`
   - Selects School, Faculty, Course (Programme)

2. **Sets Min/Max for Level and Semester**:
   ```jsp
   <input type="number" name="minCu" id="minCu" min="0" required>
   <input type="number" name="maxCu" id="maxCu" min="0" required>
   ```

3. **System Saves Configuration**:
   ```java
   Semesterregistrationcucontrol control = new Semesterregistrationcucontrol(id);
   control.setCourseId(course);
   control.setLevel("200");
   control.setSemester("First");
   control.setMincu(15);  // Minimum 15 credits
   control.setMaxcu(24);  // Maximum 24 credits
   sess.newEntry(control);
   ```

### How It's Enforced During Registration

**Location**: `stdmyregdet.jsp`

1. **System Retrieves Control Settings**:
   ```java
   Semesterregistrationcucontrol minmax = sess.getSemesterregistrationcucontrol(
       sp.getCourseId().getId(),
       sp.getLevelAdded(),
       sp.getSemesterAdded()
   );
   ```

2. **Displays to Student**:
   ```jsp
   <h6>Minimum Required</h6>
   <h4><%=minmax != null ? minmax.getMincu() : "Not Set"%></h4>
   
   <h6>Maximum Allowed</h6>
   <h4><%=minmax != null ? minmax.getMaxcu() : "Not Set"%></h4>
   ```

3. **Validates on Submission**:
   ```java
   if (minmax != null) {
       if (totalcu >= minmax.getMincu() && totalcu <= minmax.getMaxcu()) {
           // Allow registration
           sess.registerSemesterCourses(sp, ids);
       } else {
           // Reject registration
           msd = "Total credit units " + totalcu + " is out of allowable range (" 
                 + minmax.getMincu() + " and " + minmax.getMaxcu() + ")";
       }
   }
   ```

4. **JavaScript Real-Time Validation**:
   ```javascript
   // Hidden inputs store the limits
   <input type="hidden" id="minCreditsValue" value="<%=minmax.getMincu()%>">
   <input type="hidden" id="maxCreditsValue" value="<%=minmax.getMaxcu()%>">
   
   // JavaScript calculates selected credits and shows status
   // Updates progress bar and status indicator
   ```

### Key Points About Credit Unit Controls
- **Dynamic**: Configured per programme, level, and semester
- **Flexible**: Different limits for different programmes/levels
- **Enforced**: Both client-side (JavaScript) and server-side (Java) validation
- **Optional**: If not configured, system allows any number of credits

---

## Summary

### 1. **Core vs Elective Configuration**
- Configured at the `Semesterregistrationcourses` level
- Same `Semestercourses` template can be CORE in one programme, ELECTIVE in another
- Admin decides `courseType` when assigning course to programme

### 2. **Core Course Determination for Students**
- Based on `Semesterregistrationcourses.courseType` field
- Filtered by student's programme, level, and semester
- Displayed in categories: Carry-Over, GST, Core, Elective

### 3. **Carry-Over Configuration**
- **NOT manually configured**
- **Automatically determined** from failed courses (`passStatus = '1'`)
- Dynamically generated per student based on performance
- Method: `getCarryoversByStudentsAndSemester()`

### 4. **Credit Unit Controls**
- Configured in `adminCreditUnitControls.jsp`
- Stored in `Semesterregistrationcucontrol` entity
- Enforced during student registration
- Validated both client-side and server-side

---

## Files Referenced

### JSP Files
- `adminListSemCourses.jsp` - Configure semester course categories
- `admineditsemestercourses.jsp` - Assign courses to programmes
- `stdmyregdet.jsp` - Student registration interface
- `adminCreditUnitControls.jsp` - Configure min/max credit units

### Entity Classes
- `Semestercourses.java` - Course template
- `Semesterregistrationcourses.java` - Course-programme assignment
- `Semesterregistration.java` - Student's actual registration
- `Semesterregistrationcucontrol.java` - Credit unit limits

### Session Methods
- `getSemesterRegistrationCourses()` - Fetch courses for programme/level/semester
- `getCarryoversByStudentsAndSemester()` - Identify failed courses
- `getSemesterregistrationcucontrol()` - Get credit unit limits
- `registerSemesterCourses()` - Register student for courses
