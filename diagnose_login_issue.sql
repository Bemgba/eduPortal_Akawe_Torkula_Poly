-- ============================================
-- DIAGNOSTIC QUERIES FOR LOGIN ISSUE
-- ============================================
-- Run these queries to diagnose why a user cannot login

-- Step 1: Check if the user exists in the database
-- Replace 'user@example.com' with the actual email address
SELECT 
    id,
    username,
    email,
    password,
    default_role,
    status,
    email_verified_at,
    created_at,
    failed_login_attempts,
    locked_until
FROM public.users
WHERE email = 'user@example.com' OR username = 'user@example.com';

-- Step 2: Check the role configuration for the user
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    u.default_role,
    r.id as role_id,
    r.name as role_name,
    r.defaulthome,
    p.id as page_id,
    p.alias as page_alias,
    p.name as page_file
FROM public.users u
LEFT JOIN public.roles r ON u.default_role = r.id
LEFT JOIN public.pages p ON r.defaulthome = p.id
WHERE u.email = 'user@example.com' OR u.username = 'user@example.com';

-- Step 3: Check for case sensitivity issues
-- This will show if there are any case mismatches
SELECT 
    id,
    username,
    email,
    LOWER(username) as username_lower,
    LOWER(email) as email_lower,
    default_role
FROM public.users
WHERE LOWER(email) = LOWER('user@example.com') 
   OR LOWER(username) = LOWER('user@example.com');

-- Step 4: Check recent user registrations
SELECT 
    id,
    username,
    email,
    default_role,
    status,
    email_verified_at,
    created_at
FROM public.users
WHERE default_role = 1064
ORDER BY created_at DESC
LIMIT 5;

-- Step 5: Check if password field is populated
-- (This won't show the actual password for security, just checks if it exists)
SELECT 
    id,
    username,
    email,
    CASE 
        WHEN password IS NULL THEN 'NULL'
        WHEN password = '' THEN 'EMPTY'
        WHEN LENGTH(password) > 0 THEN 'SET (length: ' || LENGTH(password) || ')'
    END as password_status,
    default_role,
    email_verified_at
FROM public.users
WHERE email = 'user@example.com' OR username = 'user@example.com';

-- Step 6: Check for duplicate users
SELECT 
    email,
    COUNT(*) as count
FROM public.users
WHERE LOWER(email) = LOWER('user@example.com')
GROUP BY email
HAVING COUNT(*) > 1;

-- Step 7: Check account lock status
SELECT 
    id,
    username,
    email,
    failed_login_attempts,
    locked_until,
    CASE 
        WHEN locked_until IS NULL THEN 'Not Locked'
        WHEN locked_until > NOW() THEN 'LOCKED until ' || locked_until::text
        ELSE 'Lock Expired'
    END as lock_status
FROM public.users
WHERE email = 'user@example.com' OR username = 'user@example.com';

-- ============================================
-- COMMON ISSUES AND FIXES
-- ============================================

-- Issue 1: User exists but password doesn't match
-- Possible causes:
-- - Password was entered incorrectly during registration
-- - Password case sensitivity issue
-- - Password field is NULL or empty

-- Issue 2: User doesn't exist
-- Possible causes:
-- - Registration failed silently
-- - Transaction was rolled back
-- - User was created in wrong database/schema

-- Issue 3: Email verification required
-- Check if email_verified_at is NULL
-- User must verify email before login

-- Issue 4: Account is locked
-- Check if locked_until is in the future
-- Wait for lock to expire or manually unlock

-- ============================================
-- MANUAL FIXES (USE WITH CAUTION)
-- ============================================

-- Fix 1: Reset password for a user (set to 'Test@123')
-- UNCOMMENT TO USE:
-- UPDATE public.users 
-- SET password = 'Test@123'
-- WHERE email = 'user@example.com';

-- Fix 2: Verify email manually
-- UNCOMMENT TO USE:
-- UPDATE public.users 
-- SET email_verified_at = NOW()
-- WHERE email = 'user@example.com';

-- Fix 3: Unlock account
-- UNCOMMENT TO USE:
-- UPDATE public.users 
-- SET failed_login_attempts = 0,
--     locked_until = NULL
-- WHERE email = 'user@example.com';

-- Fix 4: Ensure role is set correctly
-- UNCOMMENT TO USE:
-- UPDATE public.users 
-- SET default_role = 1064
-- WHERE email = 'user@example.com';
