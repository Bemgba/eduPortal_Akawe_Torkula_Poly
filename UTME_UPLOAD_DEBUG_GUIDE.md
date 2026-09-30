# UTME Applicants Upload Debug Guide

## Database Table Relationships

### Core Tables Involved in UTME Upload:

1. **`applicants`** - Main applicant information
   - Primary Key: `id` (JAMB Number)
   - Contains: personal info, course choices, session, status
   - Relationships:
     - `country` → `countries.id`
     - `course_1` → `courses.id` 
     - `lga` → `lgas.id`
     - `programme_id` → `programmes.id`
     - `school_id` → `schools.id`
     - `state_of_origin` → `states.id`

2. **`applicantsutme`** - UTME-specific data
   - Primary Key: `id` (same as applicants.id)
   - Contains: UTME scores, subjects
   - Relationship: `id` → `applicants.id` (One-to-One)

3. **`users`** - Login credentials
   - Primary Key: `id` (same as applicants.id)
   - Contains: username, password, role
   - Relationship: `id` = `applicants.id` (by convention, not FK)

4. **`coursesjambmapping`** - Maps JAMB course names to internal courses
   - Links Excel course names to `courses` table
   - Query: `SELECT * FROM coursesjambmapping WHERE LOWER(jamd_name) = ?`

## Excel File Structure (Column Order Matters!)

| Column | Header | Description | Example |
|--------|--------|-------------|---------|
| 0 | JAMB_NO | Unique identifier | 202440202794ef |
| 1 | NAME | Full name | ADAMU IBRAHIM |
| 2 | GENDER | M/F | M |
| 3 | STATE | State name | BAUCHI |
| 4 | AGGREGATE | Total UTME score | 280 |
| 5 | COURSE | JAMB course name | COMPUTER SCIENCE |
| 6 | LGA | Local Government | BAUCHI |
| 7 | SUBJ1 | First subject | MATHEMATICS |
| 8 | SUBJ1_SCORE | First subject score | 75 |
| 9 | SUBJ2 | Second subject | PHYSICS |
| 10 | SUBJ2_SCORE | Second subject score | 68 |
| 11 | SUBJ3 | Third subject | CHEMISTRY |
| 12 | SUBJ3_SCORE | Third subject score | 72 |
| 13 | ENG_SCORE | English score | 65 |

## Upload Process Flow

1. **File Upload** → `UploadUTMEApplicants` servlet
2. **Background Processing** → `processExcelFile()` method
3. **For each row:**
   - Parse Excel data
   - Validate scores (aggregate = sum of individual scores)
   - Check if applicant already exists
   - Lookup course mapping in `coursesjambmapping`
   - Lookup geographic data (country, state, LGA)
   - Create `Applicants` record
   - Create `Applicantsutme` record (linked via cascade)
   - Create `Users` record
   - Save to database

## Common Issues & Solutions

### 1. Course Mapping Not Found
**Problem:** "No matching course found on the portal"
**Solution:** 
- Check `coursesjambmapping` table has entries
- Ensure JAMB course names match exactly (case-insensitive)
- Add missing course mappings

### 2. Geographic Data Missing
**Problem:** State/LGA lookup fails
**Solution:**
- Verify `countries` table has "Nigeria" entry
- Check `states` table has correct state names
- Ensure `lgas` table has LGA entries linked to states

### 3. Score Validation Fails
**Problem:** "Aggregate scores does not match sum"
**Solution:**
- Verify Excel data: AGGREGATE = SUBJ1_SCORE + SUBJ2_SCORE + SUBJ3_SCORE + ENG_SCORE
- Check for empty cells or non-numeric values

### 4. Database Transaction Issues
**Problem:** Records not saving despite "Success" message
**Solution:**
- Check database connection
- Verify transaction management (@Transactional)
- Check for constraint violations
- Review server logs for SQL errors

## Debugging Steps

1. **Check Server Logs** - Look for detailed debug output
2. **Verify Prerequisites:**
   ```sql
   -- Check session manager exists
   SELECT * FROM sessionmanager WHERE school_id = 'S001' AND operation = 'APPLICATION';
   
   -- Check course mappings
   SELECT * FROM coursesjambmapping WHERE LOWER(jamd_name) LIKE '%computer%';
   
   -- Check geographic data
   SELECT * FROM countries WHERE name = 'Nigeria';
   SELECT * FROM states WHERE country = 'Nigeria';
   ```

3. **Test with Sample Data** - Use provided sample Excel file
4. **Monitor Database** - Check if records appear in tables after upload

## File Templates

- **Main Template:** `templates/applicants_list_utme.xls`
- **Sample Data:** `templates/utme_applicants_sample.xls`
- **O-Level:** `templates/utme_olevel.xls`
- **Post UTME:** `templates/utme_postutme.xls`

## Success/Error Messages

Messages now appear at the top of the upload page with detailed information about the upload status and any errors encountered.