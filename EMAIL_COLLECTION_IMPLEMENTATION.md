# Email Collection for JAMB Applicants - Implementation Guide

## Overview
This implementation adds a mandatory email collection step during login for users who were uploaded without email addresses (e.g., JAMB applicants via `admuploadutmeapplicants.jsp`).

## Problem Solved
- JAMB applicants are uploaded without email addresses
- Email is required for account verification
- Users cannot complete verification without an email
- Login should not proceed without a valid email address

## Implementation Details

### 1. Backend Changes

#### A. MainSession.java
**New Method Added:**
```java
public Users getUsersByUsername(String username)
```
- Retrieves user by username (similar to `getUsersByEmail`)
- Used to identify which user record to update
- Located after `getUsersByEmail` method (around line 1260)

#### B. UserEmailUpdateResource.java (NEW FILE)
**REST API Endpoint:**
- Path: `/apis/user-email/update`
- Method: POST
- Request Body:
  ```json
  {
    "username": "user123",
    "email": "user@example.com"
  }
  ```
- Response:
  ```json
  {
    "status": 200,
    "data": {
      "success": true,
      "message": "Email address updated successfully. Please login again."
    }
  }
  ```

**Validations:**
- Username and email are required
- Email format validation
- Checks if email is already in use by another user
- Updates `users.email` using existing `updateUserEmail` method

### 2. Frontend Changes

#### A. index.jsp - Login Flow Modification

**New Login Flow:**
1. **Step 1**: Validate username & password (existing)
2. **Step 2**: Check if `users.email` is NULL/EMPTY (NEW)
   - If NULL/EMPTY → Show email collection modal
   - If exists → Proceed to Step 3
3. **Step 3**: Email verification check (existing)
4. **Step 4**: Redirect to dashboard (existing)

**Code Location:** Lines 149-167 in index.jsp

#### B. Email Collection Modal

**Features:**
- Beautiful, user-friendly design with CoreUI styling
- Single email input field with validation
- Cannot be dismissed (backdrop: static, keyboard: false)
- Auto-shows when user has no email
- AJAX submission to backend API
- Success message and auto-redirect to login page

**Modal Structure:**
- Header: Primary color with icon
- Body: Info alert + email input field
- Footer: Large submit button
- Hidden field stores username from login form

**JavaScript Functionality:**
- Email format validation
- AJAX POST to `/apis/user-email/update`
- Loading state during submission
- Success/error message display
- Auto-redirect after successful update

### 3. User Experience Flow

**Scenario: JAMB Applicant First Login**

1. User enters username and password
2. System validates credentials ✓
3. System detects email is NULL
4. Modal appears: "Email Address Required"
5. User enters email address
6. System validates and updates email
7. Success message: "Email updated successfully"
8. Auto-redirect to login page (2 seconds)
9. User logs in again
10. System sends verification email
11. User verifies email via link
12. User can now access dashboard

### 4. Security Features

- Email format validation (frontend & backend)
- Duplicate email check (prevents email reuse)
- Username validation (ensures correct user update)
- Modal cannot be dismissed (forces email entry)
- HTTPS recommended for production

### 5. Database Changes

**No schema changes required** - uses existing `users.email` field

**Update Query:**
```sql
UPDATE users SET email = ? WHERE id = ?
```

### 6. Testing Checklist

- [ ] User with NULL email sees modal on login
- [ ] User with empty email sees modal on login
- [ ] User with valid email bypasses modal
- [ ] Invalid email format shows error
- [ ] Duplicate email shows error
- [ ] Successful update redirects to login
- [ ] After update, user can login normally
- [ ] Verification email is sent after update
- [ ] Modal cannot be dismissed without submitting

### 7. Files Modified

1. `src/main/java/com/mnl/eduportal/sessions/MainSession.java`
   - Added `getUsersByUsername` method

2. `src/main/java/com/mnl/eduportal/resources/UserEmailUpdateResource.java` (NEW)
   - REST API endpoint for email updates

3. `src/main/webapp/index.jsp`
   - Added email NULL/EMPTY check in login logic
   - Added email collection modal HTML
   - Added JavaScript for modal functionality

### 8. Configuration Notes

**No additional configuration required**

The implementation uses:
- Existing EJB sessions
- Existing database connection
- Existing REST API infrastructure
- Existing CoreUI framework

### 9. Future Enhancements

Potential improvements:
- Send welcome email after email update
- Add email confirmation field
- Allow admin to bulk update emails
- Add email change history log
- Implement rate limiting on email updates

### 10. Troubleshooting

**Modal doesn't appear:**
- Check browser console for JavaScript errors
- Verify CoreUI library is loaded
- Check if `requireEmail` attribute is set

**Email update fails:**
- Check server logs for exceptions
- Verify REST API endpoint is accessible
- Check database connection
- Verify user exists in database

**Redirect doesn't work:**
- Check JavaScript console for errors
- Verify `window.location.href` is not blocked
- Check for conflicting JavaScript

## Summary

This implementation ensures all users have valid email addresses before accessing the system, enabling proper account verification and communication. The solution is user-friendly, secure, and integrates seamlessly with the existing authentication flow.
