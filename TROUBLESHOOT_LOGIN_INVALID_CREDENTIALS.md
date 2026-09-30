# Troubleshooting: "Invalid username or password" Error

## Problem
A user just signed up but cannot login. The error message is "Invalid username or password" even though the credentials are correct.

## Possible Causes

### 1. **User Record Not Created in Database**
The registration might have failed silently without creating the user record.

**Check:**
```sql
SELECT * FROM users WHERE email = 'user@example.com';
```

**If no record found:**
- Registration transaction was rolled back
- Database connection issue during registration
- Exception was caught but not properly handled

### 2. **Password Mismatch**
The password stored in database doesn't match what user is entering.

**Possible reasons:**
- Password was modified during storage (trimmed, case changed, etc.)
- Special characters were not properly encoded
- Password field is NULL or empty

**Check:**
```sql
SELECT id, email, 
       CASE WHEN password IS NULL THEN 'NULL'
            WHEN password = '' THEN 'EMPTY'  
            ELSE 'SET'
       END as password_status,
       LENGTH(password) as password_length
FROM users WHERE email = 'user@example.com';
```

### 3. **Email/Username Case Sensitivity**
PostgreSQL is case-sensitive by default for string comparisons.

**During Registration:**
```java
emailadd = emailadd.toLowerCase(); // Line 139 in applicationsRegister.jsp
usdx.setUsername(emailadd);        // Username set to lowercase email
usdx.setEmail(emailadd);           // Email set to lowercase email
```

**During Login:**
```java
username = username.trim().toLowerCase(); // Line 106 in index.jsp
```

**JPA Query:**
```java
SELECT u FROM Users u WHERE u.username = :username OR u.email = :email
```

**Issue:** If the database has mixed case emails but login converts to lowercase, the query won't find the user.

**Check:**
```sql
-- Check for case mismatches
SELECT id, username, email, 
       LOWER(username) as username_lower,
       LOWER(email) as email_lower
FROM users 
WHERE LOWER(email) = LOWER('User@Example.com');
```

### 4. **Email Verification Required**
User must verify email before login.

**Check:**
```sql
SELECT id, email, email_verified_at, status
FROM users WHERE email = 'user@example.com';
```

**If `email_verified_at` is NULL:**
- User hasn't clicked verification link
- Verification email wasn't sent
- Email went to spam folder

**Note:** The login code checks email verification AFTER password validation, so this wouldn't cause "Invalid username or password" error. It would show "Email not verified" instead.

### 5. **Account Locked**
Too many failed login attempts.

**Check:**
```sql
SELECT id, email, failed_login_attempts, locked_until
FROM users WHERE email = 'user@example.com';
```

**Note:** Like email verification, this is checked AFTER password validation.

### 6. **JPA Query Not Finding User**
The JPA query might not be matching the user record.

**Login Query:**
```java
SELECT u FROM Users u WHERE u.username = :username OR u.email = :email
```

**Both parameters are set to the same value:**
```java
.setParameter("email", username)
.setParameter("username", username)
```

**This should work, but check:**
- Is the Users entity properly mapped?
- Are the column names correct?
- Is there a database connection issue?

### 7. **Transaction/Commit Issue**
User was created but transaction wasn't committed.

**Check server logs for:**
```
Transaction failed
Rollback
Database error
```

## Diagnostic Steps

### Step 1: Verify User Exists
```sql
SELECT id, username, email, password, default_role, status, email_verified_at, created_at
FROM users 
WHERE email = 'user@example.com' OR username = 'user@example.com';
```

**Expected:** One record found

### Step 2: Check Password Field
```sql
SELECT id, email,
       CASE WHEN password IS NULL THEN 'NULL'
            WHEN password = '' THEN 'EMPTY'
            ELSE 'SET (length: ' || LENGTH(password) || ')'
       END as password_status
FROM users WHERE email = 'user@example.com';
```

**Expected:** password_status = 'SET (length: 6 or more)'

### Step 3: Check Role Configuration
```sql
SELECT u.id, u.email, u.default_role, r.name as role_name, r.defaulthome
FROM users u
LEFT JOIN roles r ON u.default_role = r.id
WHERE u.email = 'user@example.com';
```

**Expected:** 
- default_role = 1064
- role_name = 'GENERAL APPLICANT'
- defaulthome = 'p0016'

### Step 4: Test Login Query Manually
```sql
-- Simulate the JPA query
SELECT * FROM users 
WHERE username = 'user@example.com' OR email = 'user@example.com';
```

**Expected:** One record found

### Step 5: Check Server Logs
Look for these messages in the server logs:
```
Login error for: user@example.com - [error message]
Applicant saved
Creating applicant with UTME data for ID: [id]
```

## Common Solutions

### Solution 1: User Not Created - Re-register
If user doesn't exist in database, they need to register again.

### Solution 2: Password Reset
If password doesn't match, reset it:
```sql
UPDATE users 
SET password = 'NewPassword123!'
WHERE email = 'user@example.com';
```

Then tell user to login with the new password.

### Solution 3: Manual Email Verification
If email verification is blocking:
```sql
UPDATE users 
SET email_verified_at = NOW()
WHERE email = 'user@example.com';
```

### Solution 4: Unlock Account
If account is locked:
```sql
UPDATE users 
SET failed_login_attempts = 0,
    locked_until = NULL
WHERE email = 'user@example.com';
```

### Solution 5: Fix Case Sensitivity
If there's a case mismatch:
```sql
UPDATE users 
SET username = LOWER(username),
    email = LOWER(email)
WHERE id = 'user_id';
```

## Testing the Fix

1. Run diagnostic queries from `diagnose_login_issue.sql`
2. Identify the specific issue
3. Apply the appropriate fix
4. Test login with the user's credentials
5. Check server logs for any errors

## Prevention

To prevent this issue in the future:

1. **Add Better Error Handling in Registration**
   - Log all exceptions
   - Show specific error messages to user
   - Verify user was created before showing success message

2. **Add Registration Verification**
   ```java
   sess.newEntry(usdx);
   
   // Verify user was created
   Users verifyUser = sess.getUsersByEmail(emailadd);
   if (verifyUser == null) {
       throw new Exception("User creation failed");
   }
   ```

3. **Add Debug Logging in Login**
   ```java
   System.out.println("Login attempt for: " + username);
   System.out.println("User found: " + (tmp != null));
   if (tmp != null) {
       System.out.println("Password match: " + passwordMatches);
   }
   ```

4. **Test Registration Flow**
   - Create test account
   - Verify in database
   - Test login immediately
   - Check all error paths

## Files to Check

1. **`src/main/webapp/applicationsRegister.jsp`** - Registration logic
2. **`src/main/webapp/index.jsp`** - Login logic
3. **`src/main/java/com/mnl/eduportal/sessions/MainSession.java`** - login() method
4. **Server logs** - Look for exceptions and errors
5. **Database** - Verify user records

## Quick Diagnostic Command

Run this SQL to get all relevant information:
```sql
SELECT 
    u.id,
    u.username,
    u.email,
    CASE WHEN u.password IS NULL THEN 'NULL' ELSE 'SET' END as has_password,
    u.default_role,
    r.name as role_name,
    r.defaulthome,
    u.email_verified_at,
    u.status,
    u.failed_login_attempts,
    u.locked_until,
    u.created_at
FROM users u
LEFT JOIN roles r ON u.default_role = r.id
WHERE u.email = 'user@example.com' OR u.username = 'user@example.com';
```

This will show you everything you need to diagnose the issue.

---

**Next Steps:**
1. Run the diagnostic SQL queries
2. Share the results
3. I'll help identify the exact issue and provide the fix
