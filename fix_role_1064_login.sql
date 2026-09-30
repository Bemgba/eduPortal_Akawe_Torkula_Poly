-- ============================================
-- FIX FOR ROLE 1064 (GENERAL APPLICANT) LOGIN ISSUE
-- ============================================
-- This script ensures Role 1064 and its associated page p0016 are properly configured
-- Run this script if new applicants with Role 1064 cannot login

-- Step 1: Ensure role 1064 exists with correct configuration
INSERT INTO public.roles (id, name, description, defaulthome, role_type)
VALUES (1064, 'GENERAL APPLICANT', 'GENERAL APPLICANT', 'p0016', NULL)
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    defaulthome = EXCLUDED.defaulthome,
    role_type = EXCLUDED.role_type;

-- Step 2: Ensure page p0016 exists and is properly configured
INSERT INTO public.pages (id, name, description, status, comment, roles, manu_id, alias)
VALUES ('p0016', 'genappDashboard.jsp', 'General Applicant Dashboard', 'ACTIVE', '', '1064;', NULL, 'gen_app_dashboard')
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    status = 'ACTIVE',
    roles = '1064;',
    alias = 'gen_app_dashboard';

-- Step 3: Verify the configuration
SELECT 
    r.id as role_id,
    r.name as role_name,
    r.defaulthome,
    p.id as page_id,
    p.name as page_name,
    p.alias as page_alias,
    p.status as page_status,
    p.roles
FROM public.roles r
LEFT JOIN public.pages p ON r.defaulthome = p.id
WHERE r.id = 1064;

-- Expected output:
-- role_id | role_name         | defaulthome | page_id | page_name            | page_alias        | page_status | roles
-- --------|-------------------|-------------|---------|----------------------|-------------------|-------------|-------
-- 1064    | GENERAL APPLICANT | p0016       | p0016   | genappDashboard.jsp  | gen_app_dashboard | ACTIVE      | 1064;

-- Step 4: Check existing users with role 1064
SELECT 
    u.id,
    u.username,
    u.email,
    u.default_role,
    u.email_verified_at,
    u.status,
    u.created_at
FROM public.users u
WHERE u.default_role = 1064
ORDER BY u.created_at DESC
LIMIT 10;

-- Step 5: If you want to test, you can temporarily update a test user to role 1064
-- UNCOMMENT ONLY FOR TESTING:
-- UPDATE public.users 
-- SET default_role = 1064 
-- WHERE email = 'test@example.com';  -- Replace with actual test email

COMMIT;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check all applicant roles and their default homes
SELECT 
    r.id,
    r.name,
    r.defaulthome,
    p.alias as home_page_alias,
    p.name as home_page_file
FROM public.roles r
LEFT JOIN public.pages p ON r.defaulthome = p.id
WHERE r.id IN (1063, 1064)
ORDER BY r.id;

-- Count users by role
SELECT 
    r.id as role_id,
    r.name as role_name,
    COUNT(u.id) as user_count
FROM public.roles r
LEFT JOIN public.users u ON u.default_role = r.id
WHERE r.id IN (1063, 1064)
GROUP BY r.id, r.name
ORDER BY r.id;
