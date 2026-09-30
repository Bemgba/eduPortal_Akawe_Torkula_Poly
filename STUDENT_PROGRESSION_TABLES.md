# Student Progression - Database Tables Updated

## Overview
During student progression, the system updates records to track student advancement through academic levels and semesters.

## Tables Updated

### 1. **studentprogression** (Primary Table)
**Purpose**: Tracks each student's progression through sessions and semesters

**Operations**:
- **INSERT**: Creates new progression records for each session/semester combination
- Records created when a student doesn't have an existing progression entry for the current session/semester

**Fields Set**:
- `id` - Generated: `{session_year}{student_id}{random_4_digits}`
- `students_id` - Foreign key to students table
- `course_id` - Student's course
- `session_added` - Academic session (e.g., "2023/2024")
- `semester_added` - "First" or "Second"
- `level_added` - Academic level (100, 200, 300, etc.)
- `registration_status` - Initially "0" (not registered)
- `status` - Student's matric number
- `date_added` - Current timestamp

**When Records Are Created**:
- For each new session/semester that the student should be in
- Only if a record doesn't already exist for that session/semester combination

### 2. **students** (Secondary Table)
**Purpose**: Main student information table

**Operations**:
- **UPDATE**: Modifies student's current status and level

**Fields Updated**:
```sql
UPDATE students SET 
    added_by = ?,
    date_added = ?,
    exit_type = ?,
    othernames = ?,
    exit_comment = ?,
    session_exited = ?,
    current_class = ?
WHERE id = ?
```

**When Updated**:
- **Level Advancement** (First Semester only):
  - `current_class` - Incremented by 100 (e.g., 100 → 200)
  - `date_added` - Updated to current timestamp
  - `added_by` - Set to system user (s202410469)
  - `othernames` - Preserved or set to empty string if null

- **Suspension** (when max spillover exceeded):
  - `exit_type` - Set to "SUSPENDED"
  - `exit_comment` - "Auto suspension. Exhausted maximum spillover levels"
  - `session_exited` - Current session
  - `date_added` - Updated to current timestamp
  - `added_by` - Set to system user (s202410469)

## Progression Logic

### updateStudentProgression2() - Current Implementation
Used in batch processing for efficiency.

**Process**:
1. Get current session/semester from `sessionmanager` table
2. Check if progression record exists for current session/semester
3. If not exists:
   - Create new `studentprogression` record
   - If First Semester:
     - Check spillover count (max level + First semester records)
     - If exceeded max spillover → **SUSPEND student**
     - Otherwise → **ADVANCE student** to next level
   - If Second Semester:
     - Just create progression record (no level change)

### updateStudentProgression() - Legacy Implementation
Creates progression records for all sessions from admission to current.

**Process**:
1. Loops through all sessions from admission to current
2. Creates First and Second semester records for each session
3. Advances level every session (not just First semester)
4. More comprehensive but slower

## Key Business Rules

### Level Advancement
- Only happens in **First Semester**
- Student advances by 100 levels (100→200→300→400→500)
- Continues until reaching `default_max_level` from courses table

### Spillover Management
- `default_max_spill` from courses table defines maximum spillover semesters
- Divided by 2 to get spillover sessions (e.g., 4 semesters = 2 sessions)
- Counts how many times student has been at max level in First semester
- Auto-suspends when spillover limit exceeded

### Suspension Criteria
```
IF (next_level > max_level) AND (spillover_count >= max_spillover_sessions)
THEN suspend student
```

## Related Tables (Read Only)

### sessionmanager
**Purpose**: Determines current active session/semester
**Query**: Gets current session for student's school and "REGISTRATION" operation

### courses
**Purpose**: Provides course configuration
**Fields Used**:
- `default_min_level` - Starting level (usually 100)
- `default_max_level` - Maximum level (e.g., 500)
- `default_max_spill` - Maximum spillover semesters allowed

### users
**Purpose**: System user for audit trail
**Used**: Sets `added_by` field to system user (s202410469)

## Example Progression Flow

### Scenario: Student in 200 Level, First Semester 2023/2024

**Before**:
```
students.current_class = "200"
studentprogression records exist for:
  - 2022/2023 First (100)
  - 2022/2023 Second (100)
  - 2023/2024 First (200) ← Already exists
```

**After** (if record didn't exist):
```
students.current_class = "300" (advanced)
studentprogression new record:
  - 2023/2024 First (300)
```

### Scenario: Student at Max Level (500), Exceeded Spillover

**Before**:
```
students.current_class = "500"
Max level = 500
Max spillover = 2 sessions
Spillover count = 2 (already at 500 for 2 First semesters)
```

**After**:
```
students.exit_type = "SUSPENDED"
students.exit_comment = "Auto suspension. Exhausted maximum spillover levels"
students.session_exited = "2023/2024"
No new studentprogression record created
```

## Performance Considerations

The batch processing approach (`updateStudentProgression2`) is used because:
- Processes students in batches of 20
- Uses separate transactions (REQUIRES_NEW)
- More efficient than processing all sessions for each student
- Only creates records for current session/semester
- Reduces database load and transaction time
