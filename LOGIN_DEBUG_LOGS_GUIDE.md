# Login Debug Logs Guide

## Overview
Comprehensive logging has been added to track every step of the login process. This will help identify exactly where and why login is failing.

---

## Where to Find Logs

**WildFly/JBoss Server Logs:**
- Location: `standalone/log/server.log`
- Or check your IDE console output

---

## What the Logs Show

### 1. Form Submission (index.jsp)
```
=== LOGIN FORM SUBMITTED ===
Raw username from form: User@Example.com
Raw password length: 10
Processed username (lowercase): user@example.com
Processed password length: 10
Calling sess.login()...
```

**What to check:**
- ✅ Username is converted to lowercase
- ✅ Password length is correct (not 0)
- ✅ No extra spaces or characters

---

### 2. Login Method Start (MainSession.java)
```
=== LOGIN ATTEMPT START ===
Username/Email entered: user@example.com
Password length: 10
IP Address: 127.0.0.1
Executing database query...
```

**What to check:**
- ✅ Username matches what was entered
- ✅ Password length is correct

---

### 3. Database Query Result

#### SUCCESS - User Found:
```
Query executed successfully
✓ User found in database
  - User ID: ABC123
  - Username: user@example.com
  - Email: user@example.com
  - Stored password length: 10
  - Default Role: 1064
```

**What to check:**
- ✅ User exists in database
- ✅ Username and email match
- ✅ Stored password has a length (not 0)
- ✅ Default role is set

#### FAILURE - User Not Found:
```
✗ No user found with username/email: user@example.com
  - This means the user doesn't exist in the database
```

**What this means:**
- ❌ User was never created during registration
- ❌ Registration failed silently
- ❌ User is searching with wrong email

**Solution:** User needs to register again

---

### 4. Password Comparison

#### SUCCESS - Password Matches:
```
Comparing passwords...
  - Exact match (case-sensitive): true
  - Case-insensitive match: true
  - Password matches: true
✓ Password validation successful
```

**What this means:**
- ✅ Password is correct
- ✅ Login will succeed

#### FAILURE - Password Doesn't Match:
```
Comparing passwords...
  - Exact match (case-sensitive): false
  - Case-insensitive match: false
  - Password matches: false
✗ Password validation FAILED
  - Entered password: [HIDDEN for security]
  - Stored password: [HIDDEN for security]
  - Hint: Check if password case matches
```

**What this means:**
- ❌ Password is incorrect
- ❌ User entered wrong password
- ❌ Password case doesn't match

**Possible causes:**
1. User typed wrong password
2. Password case mismatch (e.g., stored: `Test@123`, entered: `test@123`)
3. Password has extra spaces
4. Password was stored incorrectly during registration

**Solution:** 
- Try password reset
- Check for typos
- Check caps lock

---

### 5. Role and Home Page Loading

#### SUCCESS:
```
Loading user role...
  - Role name: GENERAL APPLICANT
  - Default home: gen_app_dashboard
```

**What this means:**
- ✅ User has valid role
- ✅ Role has default home page
- ✅ Login will proceed

#### FAILURE - No Role:
```
  - WARNING: User has no default role!
```

**What this means:**
- ❌ User's `default_role` is NULL
- ❌ Database configuration issue

**Solution:** Run SQL to fix:
```sql
UPDATE users SET default_role = 1064 WHERE email = 'user@example.com';
```

#### FAILURE - No Home Page:
```
  - WARNING: Role has no default home page!
```

**What this means:**
- ❌ Role's `defaulthome` is NULL
- ❌ Database configuration issue

**Solution:** Run SQL to fix:
```sql
UPDATE roles SET defaulthome = 'p0016' WHERE id = 1064;
```

---

### 6. Login Completion

#### SUCCESS:
```
Creating login audit log...
Updating user last login info...
✓ Login successful for user: user@example.com
=== LOGIN ATTEMPT END ===
Result: SUCCESS

Login method returned: User object (SUCCESS)
  - User ID: ABC123
  - Email: user@example.com
  - Has role: true
```

**What this means:**
- ✅ Login succeeded
- ✅ User will be redirected to dashboard

#### FAILURE:
```
=== LOGIN ATTEMPT END ===
Result: FAILED

Login method returned: NULL (FAILED)
```

**What this means:**
- ❌ Login failed
- ❌ User will see "Invalid username or password"

---

## Common Log Patterns and Solutions

### Pattern 1: User Not Found
```
✗ No user found with username/email: user@example.com
Result: FAILED
```

**Cause:** User doesn't exist in database  
**Solution:** Register again or check database

---

### Pattern 2: Password Mismatch
```
✓ User found in database
✗ Password validation FAILED
  - Exact match (case-sensitive): false
  - Case-insensitive match: false
Result: FAILED
```

**Cause:** Wrong password or case mismatch  
**Solution:** Reset password or check for typos

---

### Pattern 3: Case Mismatch Only
```
✓ User found in database
Comparing passwords...
  - Exact match (case-sensitive): false
  - Case-insensitive match: true
  - Password matches: true
✓ Password validation successful
```

**Cause:** Old user with lowercase password  
**Solution:** This is OK - backward compatibility working

---

### Pattern 4: Missing Role
```
✓ User found in database
✓ Password validation successful
  - WARNING: User has no default role!
Result: SUCCESS (but will fail later)
```

**Cause:** User's `default_role` is NULL  
**Solution:** Fix database:
```sql
UPDATE users SET default_role = 1064 WHERE email = 'user@example.com';
```

---

### Pattern 5: Missing Home Page
```
✓ User found in database
✓ Password validation successful
  - Role name: GENERAL APPLICANT
  - WARNING: Role has no default home page!
Result: SUCCESS (but redirect will fail)
```

**Cause:** Role's `defaulthome` is NULL  
**Solution:** Fix database:
```sql
UPDATE roles SET defaulthome = 'p0016' WHERE id = 1064;
```

---

## How to Use These Logs

### Step 1: Attempt Login
Try to login with the problematic account

### Step 2: Check Server Logs
Look for the section starting with:
```
=== LOGIN FORM SUBMITTED ===
```

### Step 3: Identify the Failure Point
Find where the ✗ (cross) appears:
- ✗ User not found → Registration issue
- ✗ Password validation FAILED → Password issue
- WARNING: No role → Database issue
- WARNING: No home page → Database issue

### Step 4: Apply the Solution
Based on the failure point, apply the appropriate fix from this guide

### Step 5: Test Again
Try login again and verify the logs show SUCCESS

---

## Example: Successful Login Logs

```
=== LOGIN FORM SUBMITTED ===
Raw username from form: test@example.com
Raw password length: 10
Processed username (lowercase): test@example.com
Processed password length: 10
Calling sess.login()...

=== LOGIN ATTEMPT START ===
Username/Email entered: test@example.com
Password length: 10
IP Address: 127.0.0.1
Executing database query...
Query executed successfully
✓ User found in database
  - User ID: ABC123
  - Username: test@example.com
  - Email: test@example.com
  - Stored password length: 10
  - Default Role: 1064
Comparing passwords...
  - Exact match (case-sensitive): true
  - Case-insensitive match: true
  - Password matches: true
✓ Password validation successful
Loading user role...
  - Role name: GENERAL APPLICANT
  - Default home: gen_app_dashboard
Creating login audit log...
Updating user last login info...
✓ Login successful for user: test@example.com
=== LOGIN ATTEMPT END ===
Result: SUCCESS

Login method returned: User object (SUCCESS)
  - User ID: ABC123
  - Email: test@example.com
  - Has role: true
```

---

## Example: Failed Login Logs (User Not Found)

```
=== LOGIN FORM SUBMITTED ===
Raw username from form: nonexistent@example.com
Raw password length: 10
Processed username (lowercase): nonexistent@example.com
Processed password length: 10
Calling sess.login()...

=== LOGIN ATTEMPT START ===
Username/Email entered: nonexistent@example.com
Password length: 10
IP Address: 127.0.0.1
Executing database query...
✗ No user found with username/email: nonexistent@example.com
  - This means the user doesn't exist in the database
=== LOGIN ATTEMPT END ===
Result: FAILED

Login method returned: NULL (FAILED)
```

---

## Example: Failed Login Logs (Wrong Password)

```
=== LOGIN FORM SUBMITTED ===
Raw username from form: test@example.com
Raw password length: 10
Processed username (lowercase): test@example.com
Processed password length: 10
Calling sess.login()...

=== LOGIN ATTEMPT START ===
Username/Email entered: test@example.com
Password length: 10
IP Address: 127.0.0.1
Executing database query...
Query executed successfully
✓ User found in database
  - User ID: ABC123
  - Username: test@example.com
  - Email: test@example.com
  - Stored password length: 10
  - Default Role: 1064
Comparing passwords...
  - Exact match (case-sensitive): false
  - Case-insensitive match: false
  - Password matches: false
✗ Password validation FAILED
  - Entered password: [HIDDEN for security]
  - Stored password: [HIDDEN for security]
  - Hint: Check if password case matches
=== LOGIN ATTEMPT END ===
Result: FAILED

Login method returned: NULL (FAILED)
```

---

## Files Modified

1. **`src/main/java/com/mnl/eduportal/sessions/MainSession.java`**
   - Added detailed logging to `login()` method
   - Logs every step of authentication process

2. **`src/main/webapp/index.jsp`**
   - Added logging for form submission
   - Logs raw and processed input
   - Logs login method result

---

## Next Steps

1. **Deploy the updated code** to your server
2. **Attempt login** with the problematic account
3. **Check server logs** for the detailed output
4. **Share the logs** so we can identify the exact issue
5. **Apply the fix** based on what the logs reveal

---

**Date Created:** February 11, 2026  
**Purpose:** Debug login failures  
**Log Level:** INFO (printed to System.out)
