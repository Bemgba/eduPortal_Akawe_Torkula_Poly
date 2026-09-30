# Fix for Applicant Login Issue - Role 1064

## Problem
New applicants (using Role 1064 - GENERAL APPLICANT) cannot login even with correct credentials.

## Root Cause Analysis

Role 1064 exists and is correctly configured in `roles_202602111032.sql`:
```sql
(1064,'GENERAL APPLICANT','GENERAL APPLICANT','p0016',NULL)
```

However, the login is failing because:
1. **Page p0016 might not exist in the pages table**
2. **The page alias might not be properly configured**
3. **The role-page relationship might be broken**

## Role Structure

| Role ID | Name | Default Home | Page File |
|---------|------|--------------|-----------|
| 1059 | STUDENTS | p001 | studentdashboard.jsp |
| 1063 | APPLICANTS | p003 | applicantsdashboard.jsp |
| 1064 | GENERAL APPLICANT | p0016 | genappDashboard.jsp |

## Verification Steps

### Step 1: Check if page p0016 exists
```sql
SELECT * FROM pages WHERE id = 'p0016';
```

Expected result:
```
id    | name                  | alias              | roles
------|----------------------|--------------------|---------
p0016 | genappDashboard.jsp  | gen_app_dashboard  | 1064;
```

### Step 2: Check if role 1064 exists
```sql
SELECT * FROM roles WHERE id = 1064;
```

Expected result:
```
id   | name              | defaulthome
-----|-------------------|-------------
1064 | GENERAL APPLICANT | p0016
```

### Step 3: Check if genappDashboard.jsp file exists
File should exist at: `src/main/webapp/genappDashboard.jsp`

## SQL Fix

If page p0016 doesn't exist, create it:

```sql
-- Insert page p0016 if it doesn't exist
INSERT INTO pages (id, name, description, status, comment, roles, manu_id, alias)
VALUES ('p0016', 'genappDashboard.jsp', 'General Applicant Dashboard', 'ACTIVE', '', '1064;', NULL, 'gen_app_dashboard')
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    status = EXCLUDED.status,
    roles = EXCLUDED.roles,
    alias = EXCLUDED.alias;
```

If role 1064 doesn't have proper defaulthome:

```sql
-- Update role 1064 to ensure it has correct defaulthome
UPDATE roles 
SET defaulthome = 'p0016', 
    name = 'GENERAL APPLICANT',
    description = 'GENERAL APPLICANT'
WHERE id = 1064;
```

## Complete Fix SQL Script

```sql
-- ============================================
-- FIX FOR ROLE 1064 (GENERAL APPLICANT) LOGIN
-- ============================================

-- Step 1: Ensure role 1064 exists with correct configuration
INSERT INTO roles (id, name, description, defaulthome, role_type)
VALUES (1064, 'GENERAL APPLICANT', 'GENERAL APPLICANT', 'p0016', NULL)
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    defaulthome = EXCLUDED.defaulthome,
    role_type = EXCLUDED.role_type;

-- Step 2: Ensure page p0016 exists
INSERT INTO pages (id, name, description, status, comment, roles, manu_id, alias)
VALUES ('p0016', 'genappDashboard.jsp', 'General Applicant Dashboard', 'ACTIVE', '', '1064;', NULL, 'gen_app_dashboard')
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    status = EXCLUDED.status,
    roles = EXCLUDED.roles,
    alias = EXCLUDED.alias;

-- Step 3: Verify the configuration
SELECT 
    r.id as role_id,
    r.name as role_name,
    r.defaulthome,
    p.id as page_id,
    p.name as page_name,
    p.alias as page_alias,
    p.status as page_status
FROM roles r
LEFT JOIN pages p ON r.defaulthome = p.id
WHERE r.id = 1064;

-- Step 4: Check if any users have role 1064
SELECT 
    u.id,
    u.username,
    u.email,
    u.default_role,
    u.email_verified_at,
    u.status
FROM users u
WHERE u.default_role = 1064;
```

## Application Code Status

✅ `applicationsRegister.jsp` - Correctly assigns Role 1064
✅ `MainSession.login()` - Properly loads role and defaulthome
✅ `index.jsp` - Correctly redirects to defaulthome alias
✅ `genappDashboard.jsp` - File exists in filesystem

## Testing After Fix

1. Run the SQL fix script above
2. Create a new test applicant account
3. Verify email
4. Login with credentials
5. Should redirect to `/gen_app_dashboard`

## Debugging Commands

If login still fails, check server logs for:

```
VALIDATION: User [email] is properly configured
  - Role: GENERAL APPLICANT
  - Home: gen_app_dashboard
```

If you see:
```
VALIDATION: User [email] role has no default home page
```

Then the database fix wasn't applied correctly.

## Alternative: Use Role 1063 Instead

If you prefer all applicants to use the same dashboard (applicantsdashboard.jsp), you can change the registration to use Role 1063:

```java
// In applicationsRegister.jsp line 219:
usdx.setDefaultRole(sess.getRoles(1063)); // Use APPLICANTS role instead
```

This would make all applicants use the same role and dashboard.

## Recommendation

**Option 1 (Current)**: Keep Role 1064 for general applicants
- Requires: Ensure page p0016 exists in database
- Benefit: Separate dashboard for general applicants
- File: genappDashboard.jsp

**Option 2 (Alternative)**: Use Role 1063 for all applicants
- Requires: Change applicationsRegister.jsp to use Role 1063
- Benefit: Simpler, all applicants use same dashboard
- File: applicantsdashboard.jsp

## Status

⚠️ **PENDING DATABASE FIX** - Run the SQL script above to fix the issue

---

**Date**: February 11, 2026
**Issue**: Role 1064 login failure
**Cause**: Missing or misconfigured page p0016 in database
**Solution**: Run SQL fix script to create/update page p0016
