# Email Collection Feature - Debug Guide

## Issue: "Submit Email Address" button not working

### Fixed Issues:

1. **JavaScript Scope Issue** ✅
   - `isValidEmail()` function was defined inside the "Forgot Password" event listener
   - Moved to global scope so it's accessible from "Email Collection" modal
   - Location: Before first `DOMContentLoaded` listener

2. **Database Update Issue** ✅
   - Changed from `updateUserEmail()` to `updateUserEmailDirect()`
   - Direct JPQL UPDATE query ensures immediate database update
   - Returns number of rows updated for verification

3. **Added Console Logging** ✅
   - Button click event
   - Email and username values
   - Validation results
   - API response status and data
   - Errors

## How to Debug

### Step 1: Open Browser Console
1. Open the login page
2. Press F12 (or right-click → Inspect)
3. Go to "Console" tab
4. Keep it open while testing

### Step 2: Trigger the Modal
1. Login with a user who has NULL email
2. Modal should appear automatically
3. Check console for any JavaScript errors

### Step 3: Test Button Click
1. Enter an email address in the modal
2. Click "Submit Email Address" button
3. Watch the console for these messages:

**Expected Console Output:**
```
Submit button clicked
Email: test@example.com
Username: testuser123
Validation passed, sending request...
Response status: 200
Response data: {status: 200, message: "...", data: {...}}
```

### Step 4: Check for Errors

**If you see "Username not found":**
- The hidden username field is empty
- Check if `request.getAttribute("loginUsername")` is set
- Verify login logic sets this attribute

**If you see "Network error":**
- API endpoint not accessible
- Check server logs
- Verify application is running
- Check URL: `/apis/user-email/update`

**If you see "Email address is already in use":**
- Another user has this email
- Try a different email address

**If button doesn't respond at all:**
- Check for JavaScript errors in console
- Verify `submitEmailBtn` element exists
- Check if event listener is attached

### Step 5: Verify Database Update

After successful submission, check database:

```sql
SELECT id, username, email 
FROM users 
WHERE username = 'testuser123';
```

Email should be updated to the value you entered.

### Step 6: Check Server Logs

Look for these log messages:

**Success:**
```
INFO: Email updated successfully for user: testuser123 (rows updated: 1)
```

**Failure:**
```
WARNING: No rows updated for user: testuser123
```

**Error:**
```
SEVERE: Error updating user email
```

## Common Issues & Solutions

### Issue 1: Modal doesn't appear
**Cause:** User has email already
**Solution:** Test with user who has NULL email

### Issue 2: Button click does nothing
**Cause:** JavaScript error
**Solution:** 
- Check browser console for errors
- Verify CoreUI library is loaded
- Check if `coreui` object exists: `console.log(coreui)`

### Issue 3: "Username not found" error
**Cause:** Hidden field is empty
**Solution:**
- Check login logic sets `request.setAttribute("loginUsername", username)`
- Verify JSP expression: `<%= request.getAttribute("loginUsername") %>`

### Issue 4: API returns 404
**Cause:** Endpoint not deployed or wrong URL
**Solution:**
- Verify application deployed successfully
- Check URL in browser: `http://yourserver/apis/user-email/update`
- Check REST resource is registered

### Issue 5: Database not updating
**Cause:** Transaction not committed
**Solution:**
- Now using `updateUserEmailDirect()` with JPQL UPDATE
- Check `@Transactional` annotation on method
- Verify EntityManager is injected

### Issue 6: "Email already in use"
**Cause:** Duplicate email check
**Solution:**
- Use a unique email address
- Or delete the duplicate email from database

## Testing Checklist

- [ ] Browser console open
- [ ] No JavaScript errors on page load
- [ ] Modal appears for user without email
- [ ] Button click logs "Submit button clicked"
- [ ] Email validation works
- [ ] Username validation works
- [ ] API request sent (check Network tab)
- [ ] API response received (status 200)
- [ ] Success message displayed
- [ ] Redirect happens after 2 seconds
- [ ] Database updated (check with SQL query)
- [ ] Server logs show success message

## Manual Test Steps

### Test 1: Complete Flow
1. Find a user with NULL email in database
2. Login with that user's credentials
3. Modal appears automatically
4. Enter email: `test@example.com`
5. Click "Submit Email Address"
6. See loading spinner
7. See success message
8. Wait 2 seconds
9. Redirected to login page
10. Login again
11. No modal appears (email exists now)
12. Verification email sent

### Test 2: Validation
1. Login with user without email
2. Modal appears
3. Click button without entering email
4. See error: "Please enter your email address"
5. Enter invalid email: `notanemail`
6. Click button
7. See error: "Please enter a valid email address"
8. Enter valid email
9. Click button
10. Success

### Test 3: Duplicate Email
1. Login with user without email
2. Modal appears
3. Enter email that exists for another user
4. Click button
5. See error: "Email address is already in use by another account"
6. Enter different email
7. Click button
8. Success

## Quick Fixes

### If button still not working after fixes:

**Option 1: Clear browser cache**
```
Ctrl + Shift + Delete
Clear cached images and files
Reload page
```

**Option 2: Hard refresh**
```
Ctrl + F5 (Windows)
Cmd + Shift + R (Mac)
```

**Option 3: Rebuild and redeploy**
```bash
mvn clean package -DskipTests
# Deploy new WAR file
# Restart server
```

**Option 4: Check REST endpoint manually**
```bash
curl -X POST http://localhost:8080/apis/user-email/update \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com"}'
```

## Verification Commands

### Check if user has email:
```sql
SELECT id, username, email, email_verified_at 
FROM users 
WHERE username = 'testuser123';
```

### Find users without email:
```sql
SELECT id, username, email 
FROM users 
WHERE email IS NULL OR email = '';
```

### Update email manually (for testing):
```sql
UPDATE users 
SET email = NULL 
WHERE username = 'testuser123';
```

### Check if email is unique:
```sql
SELECT COUNT(*) 
FROM users 
WHERE email = 'test@example.com';
```

## Contact for Support

If issue persists after following this guide:
1. Provide browser console output (screenshot)
2. Provide server logs (last 50 lines)
3. Provide database query results
4. Describe exact steps taken
5. Note any error messages

## Summary of Changes Made

1. **index.jsp**
   - Moved `isValidEmail()` to global scope
   - Added console.log statements for debugging
   - Added response status logging

2. **UserEmailUpdateResource.java**
   - Changed to use `updateUserEmailDirect()` method
   - Added rows updated check
   - Enhanced logging with row count

3. **MainSession.java**
   - Added `getUsersByUsername()` method
   - Already had `updateUserEmailDirect()` method

These changes ensure:
- JavaScript functions are accessible
- Database updates are committed immediately
- Detailed logging for troubleshooting
- Better error handling
