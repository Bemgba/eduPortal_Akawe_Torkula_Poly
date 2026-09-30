-- Reset Account Lock for Specific User
-- Replace 'your_username_or_email' with the actual username or email

-- Option 1: Reset by username
UPDATE users 
SET failed_login_attempts = 0, 
    locked_until = NULL 
WHERE username = 'your_username_here';

-- Option 2: Reset by email
UPDATE users 
SET failed_login_attempts = 0, 
    locked_until = NULL 
WHERE email = 'your_email_here';

-- Option 3: Reset ALL locked accounts (use with caution)
UPDATE users 
SET failed_login_attempts = 0, 
    locked_until = NULL 
WHERE failed_login_attempts > 0 OR locked_until IS NOT NULL;

-- Check current lock status for a specific user
-- Replace 'your_username_or_email' with actual value
SELECT id, username, email, failed_login_attempts, locked_until, 
       CASE 
           WHEN locked_until IS NULL THEN 'Not Locked'
           WHEN locked_until > CURRENT_TIMESTAMP THEN 'Locked'
           ELSE 'Lock Expired'
       END as lock_status
FROM users 
WHERE username = 'your_username_here' OR email = 'your_email_here';

-- Check all locked accounts
SELECT id, username, email, failed_login_attempts, locked_until,
       CASE 
           WHEN locked_until IS NULL THEN 'Not Locked'
           WHEN locked_until > CURRENT_TIMESTAMP THEN 'Locked'
           ELSE 'Lock Expired'
       END as lock_status
FROM users 
WHERE failed_login_attempts > 0 OR locked_until IS NOT NULL
ORDER BY locked_until DESC;