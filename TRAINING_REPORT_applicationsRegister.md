# Training Activity Report - applicationsRegister.jsp
**Date:** February 12, 2026  
**Client:** EduPortal  
**Page/Module:** Application Registration (applicationsRegister.jsp)

---

## Overview
The **applicationsRegister.jsp** page is the public-facing registration interface for prospective students (applicants) to create accounts on the EduPortal system. This page serves as the entry point for the application process, allowing prospective students to:
1. Create new user accounts with email and password
2. Set secure passwords with strength validation
3. Receive email verification for account security
4. Access the application portal after registration

This page is critical as it is the first interaction prospective students have with the system and sets the foundation for their entire application journey.

---

## Page Access & Security
- **Access Control:** Public page (no authentication required)
- **User Type:** Prospective students/applicants
- **URL Path:** `/register` or `/applicationsRegister.jsp`
- **Authorization Level:** Open to public
- **Purpose:** Account creation for application process

---

## Core Functionality

### 1. **Account Registration Form**

The page provides a comprehensive registration form with security features.

#### Form Fields:

**a) Email Address** (Required)
- Text input with email validation
- Automatically converted to lowercase
- Used as both username and email
- Must be unique in the system
- Format validation: standard email format
- Example: "john.doe@example.com"

**b) Choose Password** (Required)
- Password input field
- Minimum 6 characters
- Complex validation requirements
- Real-time strength indicator
- Pattern validation enforced
- Case-sensitive (preserves original case)

**c) Retype Password** (Required)
- Password confirmation field
- Must match the first password
- Real-time match validation
- Visual feedback on match/mismatch

**Create Account Button:** Submits the registration

---

### 2. **Password Strength Requirements**

The system enforces strict password security requirements.

#### Required Password Criteria:

1. **Minimum Length:** At least 6 characters
2. **Uppercase Letter:** At least one uppercase letter (A-Z)
3. **Lowercase Letter:** At least one lowercase letter (a-z)
4. **Number:** At least one digit (0-9)
5. **Special Character:** At least one special character (@$!%*?&)

#### Password Strength Levels:

**Weak (Score 0-1):**
- Red indicator bar (25% width)
- Text: "Weak password"
- Missing multiple requirements
- Not acceptable for registration

**Fair (Score 2):**
- Orange indicator bar (50% width)
- Text: "Fair password"
- Missing some requirements
- Not acceptable for registration

**Good (Score 3-4):**
- Yellow indicator bar (75% width)
- Text: "Good password"
- Most requirements met
- Close to acceptable

**Strong (Score 5):**
- Green indicator bar (100% width)
- Text: "Strong password"
- All requirements met
- Required for successful registration

---

### 3. **Real-Time Password Validation**

The page provides interactive, real-time feedback as users type their password.

#### Visual Indicators:

**Password Strength Meter:**
- Horizontal bar that fills based on password strength
- Color-coded: Red → Orange → Yellow → Green
- Updates instantly as user types
- Shows percentage of requirements met

**Requirements Checklist:**
- Appears when user starts typing password
- Five checkboxes for each requirement:
  - ✗ Red circle: Requirement not met
  - ✓ Green circle: Requirement met
- Updates in real-time
- Helps users understand what's missing

**Text Feedback:**
- Below the strength meter
- Shows current strength level
- Color-coded to match meter
- Clear, simple language

---

### 4. **Password Match Validation**

The system validates that both password fields match.

#### Match Validation Features:

**Real-Time Checking:**
- Validates as user types in second field
- Compares with first password field
- Instant visual feedback

**Visual Feedback:**
- Green border: Passwords match
- Red border: Passwords don't match
- Error message: "Passwords do not match"

**Form Submission Prevention:**
- Cannot submit if passwords don't match
- Alert message displayed
- User must correct before proceeding

---

### 5. **Email Verification System**

After successful registration, the system sends a verification email.

#### Verification Process:

**Automatic Email Sending:**
- Triggered immediately after account creation
- Sent to the registered email address
- Contains verification link
- Required before login

**Verification Email Contents:**
- Verification link (unique to user)
- Instructions for verification
- Link expiration information
- Support contact details

**Success Messages:**
- "✅ Account Created Successfully!"
- "📧 Verification Required: A verification email has been sent to [email]"
- Instructions to check spam folder
- Option to resend verification email

**Email Verification Status:**
- New accounts: email_verified_at is NULL
- Must verify before login
- Verification link updates this field
- Login blocked until verified

---

### 6. **Duplicate Email Detection**

The system prevents duplicate registrations with the same email.

#### Duplicate Handling:

**Detection:**
- Checks database for existing email
- Case-insensitive comparison
- Occurs before account creation

**Error Message:**
- "❌ Email Already Registered"
- Shows the email address
- Provides helpful next steps:
  - Login link if it's their account
  - Password reset link if forgotten
  - Clear, user-friendly guidance

**User Options:**
- Login with existing account
- Reset password if forgotten
- Use different email address
- Contact support if needed

---

### 7. **Server-Side Validation**

All validation is performed on both client and server sides.

#### Server-Side Checks:

**Password Validation:**
- Length check (minimum 6 characters)
- Uppercase letter check
- Lowercase letter check
- Number check
- Special character check
- Detailed error messages for each failure

**Email Validation:**
- Format validation
- Uniqueness check
- Lowercase conversion
- Trimming whitespace

**Password Match:**
- Compares both password fields
- Prevents submission if mismatch
- Clear error message

**Error Handling:**
- Catches database errors
- Handles connection issues
- Provides user-friendly messages
- Logs technical details for debugging

---

### 8. **Account Creation Process**

When all validations pass, the system creates the user account.

#### Account Creation Steps:

1. **Generate Unique ID:**
   - Format: [Year][10-digit random number]
   - Example: "20242345678901"
   - Ensures uniqueness

2. **Set User Properties:**
   - Username: Email address
   - Password: Original case preserved (not lowercased)
   - Email: Email address
   - Default Role: Applicant role (ID: 1064)
   - Status: ACTIVE
   - Created At: Current timestamp
   - Updated At: Current timestamp
   - Created By: SYSTEM
   - Failed Login Attempts: 0
   - Deleted: false
   - Email Verified At: NULL (pending verification)

3. **Save to Database:**
   - Insert new user record
   - Commit transaction
   - Handle any errors

4. **Send Verification Email:**
   - Call email verification service
   - Generate verification token
   - Send email with link
   - Log result

5. **Display Success Message:**
   - Confirm account creation
   - Show verification instructions
   - Provide login link
   - Offer resend option

---

### 9. **Error Handling and User Feedback**

The page provides comprehensive error handling with clear messages.

#### Error Types and Messages:

**Password Requirements Not Met:**
- Lists all unmet requirements
- Red alert box
- Specific details for each issue
- Prevents form submission

**Email Already Registered:**
- Clear error message
- Shows the duplicate email
- Provides login link
- Offers password reset option

**Password Mismatch:**
- "❌ Password Mismatch"
- Explains the issue
- Asks user to verify both fields
- Prevents submission

**Database Errors:**
- Generic error message for security
- Specific handling for known issues:
  - Duplicate constraint violations
  - Connection errors
  - Timeout errors
- Suggestion to contact support
- Technical details logged server-side

**Email Sending Failures:**
- "Account created but verification email could not be sent"
- Instructs to contact support
- Account still created (can be verified later)
- Warning message displayed

---

### 10. **User Interface Features**

The page includes several UI enhancements for better user experience.

#### Layout Features:

**Two-Column Design:**
- Left: Registration form
- Right: Instructions and information
- Responsive: Stacks on mobile devices

**Branding:**
- Institution logo displayed
- Full institution name in header
- Professional appearance
- Consistent with portal theme

**Instructions Panel (Right Side):**
- "Registration Instructions" heading
- Information about who should register
- Clarification about account types
- Login link for existing users
- Blue background for visibility

**Form Styling:**
- Input groups with labels
- Clear field identification
- Adequate spacing
- Professional appearance
- Accessible design

---

### 11. **Navigation Options**

The page provides clear navigation for different user scenarios.

#### Navigation Links:

**Already Have Account:**
- "Already have account? Login here" link
- Located below form
- Redirects to login page (/)
- Prevents duplicate registrations

**Login After Registration:**
- "Login" button in success message
- Appears after successful registration
- Redirects to login page
- Clear call-to-action

**Password Reset:**
- "Forgot your password? Reset it here" link
- Appears in duplicate email error
- Redirects to password reset page
- Helpful for users who forgot credentials

**Resend Verification:**
- Link in success message
- Allows resending verification email
- Helpful if email not received
- Includes email address in URL



---

## Practical Use Cases

### Use Case 1: New Applicant Creating Account
**Scenario:** A prospective student wants to apply for admission and needs to create an account.

**Steps:**
1. Navigate to registration page
2. Enter email address: "john.doe@example.com"
3. Enter password in "Choose Password" field
4. Watch password strength indicator:
   - Initially shows "Weak password" (red)
   - Add uppercase: "Fair password" (orange)
   - Add number: "Good password" (yellow)
   - Add special character: "Strong password" (green)
5. Example strong password: "MyPass123!"
6. Retype same password in "Retype Password" field
7. Green border appears (passwords match)
8. Click "Create Account" button
9. Success message appears:
   - "✅ Account Created Successfully!"
   - "📧 Verification Required: A verification email has been sent to john.doe@example.com"
10. Check email inbox
11. Click verification link in email
12. Return to portal and login
13. Begin application process

---

### Use Case 2: Handling Weak Password
**Scenario:** User tries to register with a weak password.

**Steps:**
1. Navigate to registration page
2. Enter email address
3. Enter weak password: "password"
4. Password strength indicator shows:
   - Red bar (25% width)
   - "Weak password" text
   - Requirements checklist shows:
     - ✓ At least 6 characters (met)
     - ✗ One uppercase letter (not met)
     - ✓ One lowercase letter (met)
     - ✗ One number (not met)
     - ✗ One special character (not met)
5. Try to submit form
6. Browser validation prevents submission
7. Alert message: "Please ensure your password meets all requirements"
8. User improves password: "Password123!"
9. All requirements turn green
10. "Strong password" indicator appears
11. Form can now be submitted

---

### Use Case 3: Password Mismatch Error
**Scenario:** User enters different passwords in the two fields.

**Steps:**
1. Navigate to registration page
2. Enter email address
3. Enter password: "MyPass123!"
4. Password strength shows "Strong password" (green)
5. In "Retype Password" field, enter: "MyPass123" (missing !)
6. Red border appears on second field
7. Error message: "Passwords do not match"
8. Try to submit form
9. Alert message: "Passwords do not match. Please check and try again."
10. Correct the second password to match: "MyPass123!"
11. Green border appears (match confirmed)
12. Form can now be submitted

---

### Use Case 4: Duplicate Email Registration Attempt
**Scenario:** User tries to register with an email that's already in the system.

**Steps:**
1. Navigate to registration page
2. Enter email: "existing.user@example.com"
3. Enter strong password
4. Retype password correctly
5. Click "Create Account"
6. Error message appears:
   - "❌ Email Already Registered"
   - "An account with email address existing.user@example.com already exists"
   - "If this is your account, please Login here to continue your application"
   - "Forgot your password? Reset it here"
7. User has three options:
   - Click "Login here" if they remember password
   - Click "Reset it here" if password forgotten
   - Use different email address if this isn't their account

---

### Use Case 5: Verification Email Not Received
**Scenario:** User registered successfully but didn't receive verification email.

**Steps:**
1. Complete registration successfully
2. Success message shows:
   - "Account created successfully"
   - "Verification email sent to [email]"
   - "Didn't receive the email? Check your spam folder or resend verification email"
3. User checks inbox - no email
4. User checks spam/junk folder - no email
5. Click "resend verification email" link
6. System sends new verification email
7. User receives email
8. Click verification link
9. Email verified successfully
10. User can now login

---

### Use Case 6: Creating Strong Password
**Scenario:** User wants to create a secure password and needs guidance.

**Steps:**
1. Navigate to registration page
2. Enter email address
3. Click in password field
4. Requirements checklist appears
5. Start typing: "pass"
   - ✓ At least 6 characters (not yet - only 4)
   - ✗ One uppercase letter
   - ✓ One lowercase letter
   - ✗ One number
   - ✗ One special character
6. Add more: "Password"
   - ✓ At least 6 characters (now met)
   - ✓ One uppercase letter (now met)
   - ✓ One lowercase letter (met)
   - ✗ One number
   - ✗ One special character
7. Add number: "Password1"
   - All previous still met
   - ✓ One number (now met)
   - ✗ One special character
8. Add special character: "Password1!"
   - ✓ All requirements met
   - Green bar at 100%
   - "Strong password" text
9. Password is now acceptable

---

### Use Case 7: Mobile Device Registration
**Scenario:** User registers from a mobile phone.

**Steps:**
1. Open registration page on mobile browser
2. Page layout adjusts:
   - Form and instructions stack vertically
   - Full width on small screen
   - Touch-friendly buttons
3. Enter email address
4. Mobile keyboard shows email layout (@, .com keys)
5. Enter password
6. Password strength indicator visible
7. Requirements checklist readable
8. Retype password
9. Submit button easily tappable
10. Success message displays properly
11. All links accessible
12. User can proceed to email verification

---

### Use Case 8: Registration with Special Characters in Email
**Scenario:** User has email with special characters or numbers.

**Steps:**
1. Navigate to registration page
2. Enter email: "john.doe+test@example.com"
3. System accepts the email (valid format)
4. Email is converted to lowercase: "john.doe+test@example.com"
5. Enter strong password
6. Retype password
7. Click "Create Account"
8. Account created successfully
9. Verification email sent to exact address entered
10. User receives email at john.doe+test@example.com
11. Verification proceeds normally

---

### Use Case 9: Handling Database Connection Error
**Scenario:** Database is temporarily unavailable during registration.

**Steps:**
1. Navigate to registration page
2. Enter email and passwords correctly
3. Click "Create Account"
4. Database connection fails
5. Error message appears:
   - "❌ Registration Failed"
   - "Database connection error. Please try again later or contact support."
   - "If you continue to experience issues, please contact support"
6. User waits a few minutes
7. Tries registration again
8. Database is back online
9. Registration succeeds
10. Account created successfully

---

### Use Case 10: Returning User Trying to Register Again
**Scenario:** User forgot they already have an account and tries to register again.

**Steps:**
1. Navigate to registration page
2. Enter their existing email
3. Enter new password
4. Click "Create Account"
5. Error message appears:
   - "❌ Email Already Registered"
   - "An account with email address [email] already exists"
   - "If this is your account, please Login here"
6. User realizes they already registered
7. Clicks "Login here" button
8. Redirected to login page
9. Enters email and password
10. If password forgotten:
    - Clicks "Forgot password" link
    - Resets password
    - Logs in successfully

---

## Technical Features

### Client-Side Validation (JavaScript)

**Real-Time Password Strength Checking:**
- Monitors password input field
- Calculates strength score (0-5)
- Updates visual indicators instantly
- Checks each requirement individually
- Updates checklist icons and colors

**Password Match Validation:**
- Monitors both password fields
- Compares values in real-time
- Updates border colors
- Shows/hides error messages
- Prevents submission if mismatch

**Form Submission Prevention:**
- Validates before submission
- Blocks if password weak
- Blocks if passwords don't match
- Shows alert messages
- Returns false to prevent submission

**Visual Feedback:**
- Color-coded strength meter
- Animated bar transitions
- Icon changes (✗ to ✓)
- Border color changes
- Text color changes

### Server-Side Validation (Java)

**Password Strength Validation:**
- Length check: `password.length() < 6`
- Uppercase check: `password.matches(".*[A-Z].*")`
- Lowercase check: `password.matches(".*[a-z].*")`
- Number check: `password.matches(".*\\d.*")`
- Special char check: `password.matches(".*[@$!%*?&].*")`
- Accumulates error messages
- Returns detailed feedback

**Email Processing:**
- Converts to lowercase: `emailadd.toLowerCase()`
- Checks for duplicates: `sess.getUsersByEmail(emailadd)`
- Validates format (HTML5 email type)
- Trims whitespace

**Password Handling:**
- Preserves original case (NOT lowercased)
- Stores securely in database
- No plaintext logging
- Proper encryption/hashing

**Error Handling:**
- Try-catch blocks for all operations
- Specific error messages for known issues
- Generic messages for security
- Detailed logging for debugging
- User-friendly feedback

### Database Operations

**User Creation:**
- `sess.newEntry(usdx)` - Inserts new user record
- Generates unique ID
- Sets all required fields
- Commits transaction
- Handles constraints

**Duplicate Check:**
- `sess.getUsersByEmail(emailadd)` - Checks existing users
- Case-insensitive comparison
- Returns null if not found
- Returns user object if found

**Email Verification:**
- `emailVerificationSession.sendVerificationEmail(id)` - Sends email
- Generates verification token
- Creates verification link
- Sends via email service
- Returns success/failure status

**User Validation:**
- `sess.validateApplicantUser(emailadd)` - Validates configuration
- Checks role assignment
- Verifies status
- Ensures proper setup
- Logs warnings if issues

### Security Features

**Password Security:**
- Minimum complexity requirements
- Case-sensitive storage
- No plaintext logging
- Secure transmission (HTTPS assumed)
- Server-side validation

**Email Security:**
- Verification required before login
- Unique email enforcement
- Lowercase normalization
- Format validation
- Anti-spam measures

**Session Security:**
- No session created during registration
- User must login after verification
- Prevents unauthorized access
- Clean separation of concerns

**Input Sanitization:**
- HTML5 input validation
- Server-side validation
- SQL injection prevention (parameterized queries)
- XSS prevention (output encoding)

### User Interface Elements

**Responsive Design:**
- Bootstrap-based layout
- Mobile-friendly
- Touch-optimized
- Adaptive columns
- Proper spacing

**Visual Feedback:**
- Color-coded indicators
- Animated transitions
- Clear error messages
- Success confirmations
- Loading states

**Accessibility:**
- Semantic HTML
- Proper labels
- ARIA attributes
- Keyboard navigation
- Screen reader support

**Branding:**
- Institution logo
- Consistent colors
- Professional styling
- Clear hierarchy
- Trust indicators

---

## Important Concepts

### Email Verification Workflow

**Why Email Verification:**
- Confirms email ownership
- Prevents fake accounts
- Reduces spam registrations
- Ensures communication channel
- Security best practice

**Verification Process:**
1. User registers with email
2. Account created with email_verified_at = NULL
3. Verification email sent with unique token
4. User clicks link in email
5. Token validated
6. email_verified_at updated to current timestamp
7. User can now login
8. Unverified users blocked from login

**Verification Email Contents:**
- Unique verification link
- User's email address
- Expiration time (if applicable)
- Instructions
- Support contact

### Password Strength Scoring

**Score Calculation:**
- 1 point: Length ≥ 6 characters
- 1 point: Contains uppercase letter
- 1 point: Contains lowercase letter
- 1 point: Contains number
- 1 point: Contains special character
- Maximum score: 5 points

**Score Interpretation:**
- 0-1: Weak (unacceptable)
- 2: Fair (unacceptable)
- 3-4: Good (close but not enough)
- 5: Strong (required for registration)

**Why Strict Requirements:**
- Protects user accounts
- Prevents brute force attacks
- Reduces account compromise
- Industry best practice
- Compliance with security standards

### User Roles and Permissions

**Applicant Role (ID: 1064):**
- Default role for new registrations
- Limited permissions
- Can access application forms
- Can view own application
- Cannot access admin functions
- Cannot access student functions

**Role Assignment:**
- Automatic during registration
- Cannot be changed by user
- Set by system
- Determines accessible pages
- Controls available features

### Account Status

**ACTIVE Status:**
- Account is enabled
- Can attempt login (after verification)
- Can access system
- Normal operational state

**Other Possible Statuses:**
- INACTIVE: Account disabled
- SUSPENDED: Temporarily blocked
- DELETED: Soft-deleted account
- PENDING: Awaiting approval

---

## Best Practices & Recommendations

### For Applicants:

1. **Use Valid Email:** Provide an email you can access
2. **Check Spam Folder:** Verification emails may go to spam
3. **Create Strong Password:** Follow all requirements
4. **Remember Credentials:** Save email and password securely
5. **Verify Promptly:** Click verification link soon after registration
6. **One Account Only:** Don't create multiple accounts
7. **Keep Email Active:** Maintain access to registered email
8. **Update Information:** Keep contact details current

### For Administrators:

1. **Monitor Registrations:** Track new account creation
2. **Check Email Service:** Ensure verification emails are sending
3. **Review Failed Attempts:** Investigate registration errors
4. **Maintain Email Templates:** Keep verification emails updated
5. **Monitor Spam Reports:** Ensure emails aren't marked as spam
6. **Database Maintenance:** Regular cleanup of unverified accounts
7. **Security Audits:** Review password policies periodically
8. **User Support:** Assist with registration issues promptly

### For System Maintenance:

1. **Email Service Monitoring:** Ensure email service is operational
2. **Database Performance:** Monitor user table growth
3. **Error Logging:** Review registration error logs
4. **Security Updates:** Keep password requirements current
5. **Backup Strategy:** Regular backups of user data
6. **Cleanup Jobs:** Remove old unverified accounts
7. **Rate Limiting:** Prevent registration abuse
8. **Captcha Integration:** Consider adding for spam prevention

---

## Common Scenarios & Solutions

### Scenario: User Can't Receive Verification Email
**Problem:** Verification email not arriving in inbox.
**Solutions:**
1. Check spam/junk folder
2. Wait a few minutes (email delays)
3. Click "resend verification email" link
4. Verify email address is correct
5. Check email service isn't blocking sender
6. Contact support if persistent
7. Admin can manually verify account

### Scenario: Password Requirements Too Strict
**Problem:** User complains password requirements are too difficult.
**Solution:**
- Requirements are for security
- Explain importance of strong passwords
- Provide examples of acceptable passwords
- Show password strength indicator
- Suggest password manager
- Requirements are industry standard
- Cannot be relaxed for security reasons

### Scenario: Duplicate Email Error But User Doesn't Remember Account
**Problem:** User gets duplicate email error but doesn't recall registering.
**Solution:**
1. Click "Forgot password" link
2. Enter email address
3. Receive password reset email
4. Reset password
5. Login with new password
6. If still issues, contact support
7. Support can verify account exists
8. May need to recover or reset account

### Scenario: Verification Link Expired
**Problem:** User clicks verification link but it's expired.
**Solution:**
1. Return to login page
2. Try to login
3. System detects unverified email
4. Offers to resend verification
5. New email sent with fresh link
6. Click new link promptly
7. Verification succeeds

### Scenario: Registration Form Won't Submit
**Problem:** Create Account button doesn't work.
**Solution:**
1. Check password strength indicator
2. Ensure all requirements are green
3. Verify passwords match
4. Check email format is valid
5. Look for error messages
6. Try different browser
7. Clear browser cache
8. Disable browser extensions
9. Contact support if persistent

### Scenario: Account Created But Can't Login
**Problem:** Registration successful but login fails.
**Solution:**
1. Check if email verification required
2. Look for verification email
3. Click verification link
4. Try login again
5. Verify password is correct (case-sensitive)
6. Check caps lock is off
7. Try password reset if forgotten
8. Contact support if verified but still can't login

---

## Important Notes for Users

1. **Email Verification Required:** Must verify email before login. Check inbox and spam folder.

2. **Password Case-Sensitive:** Passwords preserve uppercase and lowercase. "Password" ≠ "password".

3. **One Account Per Email:** Cannot register same email twice. Use unique email for each account.

4. **Strong Password Mandatory:** All five requirements must be met. No exceptions.

5. **Verification Email Timing:** May take a few minutes to arrive. Check spam if not in inbox.

6. **Account Security:** Keep password secure. Don't share with others.

7. **Email Access Important:** Must maintain access to registered email for password resets.

8. **Browser Compatibility:** Works best on modern browsers. Update if experiencing issues.

9. **Mobile Friendly:** Can register from mobile devices. Layout adapts automatically.

10. **Support Available:** Contact support if experiencing registration issues.

---

## Training Summary

During today's training session, the client was introduced to the **Application Registration** functionality, which serves as the entry point for prospective students to create accounts. The key takeaways include:

- Understanding the registration form and required fields
- Password strength requirements and validation
- Real-time password strength indicator
- Email verification process and importance
- Duplicate email detection and handling
- Client-side and server-side validation
- Error handling and user feedback
- Navigation options for different scenarios
- Security features and best practices
- User experience enhancements

This page is critical as it is the first interaction prospective students have with the system and establishes the foundation for their application journey. Proper account creation ensures secure access and enables the complete application process.

---

## Critical Warnings Recap

⚠️ **EMAIL VERIFICATION REQUIRED:** Users must verify email before login. Unverified accounts cannot access the system.

⚠️ **STRONG PASSWORD MANDATORY:** All five password requirements must be met. Form will not submit otherwise.

⚠️ **CASE-SENSITIVE PASSWORDS:** Passwords preserve original case. "Password" and "password" are different.

⚠️ **ONE EMAIL PER ACCOUNT:** Cannot register same email twice. Each account needs unique email.

⚠️ **CHECK SPAM FOLDER:** Verification emails may go to spam. Always check junk folder.

⚠️ **MAINTAIN EMAIL ACCESS:** Users must keep access to registered email for password resets.

⚠️ **NO PASSWORD RECOVERY WITHOUT EMAIL:** Cannot reset password without access to registered email.

⚠️ **ACCOUNT SECURITY:** Users responsible for keeping passwords secure. Don't share credentials.

---

**Report Prepared By:** Training Team  
**Page Analyzed:** applicationsRegister.jsp (Application Registration)  
**System:** EduPortal v1.0  
**Classification:** Public Registration Interface
