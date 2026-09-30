# Email Collection Feature - Test Scenarios

## Test Scenario 1: User Without Email (Primary Use Case)

**Preconditions:**
- User exists in database (uploaded via JAMB)
- `users.email` is NULL or empty string
- User has valid username and password

**Steps:**
1. Navigate to login page (`/`)
2. Enter username: `[JAMB_USER]`
3. Enter password: `[PASSWORD]`
4. Click "Login" button

**Expected Results:**
- Login credentials validated successfully
- Email collection modal appears automatically
- Modal cannot be dismissed by clicking outside or pressing ESC
- Modal displays: "Email Address Required" header
- Info alert explains why email is needed
- Email input field is displayed
- Submit button is visible

**Test Email Submission:**
5. Enter valid email: `test@example.com`
6. Click "Submit Email Address"

**Expected Results:**
- Button shows loading spinner: "Updating..."
- AJAX request sent to `/apis/user-email/update`
- Success message displayed: "Email updated successfully. Please login again."
- After 2 seconds, redirected to login page with success message
- User can now login normally
- Verification email is sent to the provided email

---

## Test Scenario 2: User With Existing Email

**Preconditions:**
- User exists in database
- `users.email` has a valid email address
- User has valid username and password

**Steps:**
1. Navigate to login page (`/`)
2. Enter username: `[USER_WITH_EMAIL]`
3. Enter password: `[PASSWORD]`
4. Click "Login" button

**Expected Results:**
- Login credentials validated successfully
- Email collection modal DOES NOT appear
- System proceeds to email verification check
- If email not verified: Shows verification required message
- If email verified: Redirects to dashboard

---

## Test Scenario 3: Invalid Email Format

**Preconditions:**
- User without email attempts login
- Email collection modal is displayed

**Steps:**
1. Enter invalid email formats:
   - `notanemail`
   - `test@`
   - `@example.com`
   - `test @example.com` (space)
   - `test..test@example.com` (double dot)

**Expected Results:**
- Error message displayed: "Please enter a valid email address"
- Button remains enabled
- User can correct and resubmit

---

## Test Scenario 4: Duplicate Email Address

**Preconditions:**
- User A has email: `existing@example.com`
- User B has no email
- User B attempts to use User A's email

**Steps:**
1. Login as User B (no email)
2. Email collection modal appears
3. Enter email: `existing@example.com`
4. Click "Submit Email Address"

**Expected Results:**
- Error message displayed: "Email address is already in use by another account"
- Button re-enabled
- User must provide different email

---

## Test Scenario 5: Empty Email Submission

**Preconditions:**
- User without email attempts login
- Email collection modal is displayed

**Steps:**
1. Leave email field empty
2. Click "Submit Email Address"

**Expected Results:**
- Error message displayed: "Please enter your email address"
- Form validation prevents submission
- User must enter email

---

## Test Scenario 6: Network Error During Submission

**Preconditions:**
- User without email attempts login
- Email collection modal is displayed
- Network connection is interrupted

**Steps:**
1. Enter valid email: `test@example.com`
2. Disconnect network
3. Click "Submit Email Address"

**Expected Results:**
- Button shows loading state
- After timeout, error message: "Network error. Please check your connection and try again."
- Button re-enabled
- User can retry after reconnecting

---

## Test Scenario 7: Enter Key Submission

**Preconditions:**
- User without email attempts login
- Email collection modal is displayed

**Steps:**
1. Enter valid email: `test@example.com`
2. Press Enter key (instead of clicking button)

**Expected Results:**
- Form submits via Enter key
- Same behavior as clicking submit button
- Email updated successfully

---

## Test Scenario 8: Multiple Login Attempts

**Preconditions:**
- User without email

**Steps:**
1. Attempt login (modal appears)
2. Close browser without submitting email
3. Attempt login again

**Expected Results:**
- Modal appears again
- User must provide email to proceed
- Email is still NULL in database

---

## Test Scenario 9: Case Sensitivity

**Preconditions:**
- User without email attempts login

**Steps:**
1. Login with username: `TestUser123`
2. Email collection modal appears
3. Enter email: `Test@Example.COM`
4. Submit

**Expected Results:**
- Email stored as lowercase: `test@example.com`
- Username matched case-insensitively
- Update successful

---

## Test Scenario 10: Special Characters in Email

**Preconditions:**
- User without email attempts login

**Steps:**
1. Email collection modal appears
2. Enter email with special characters:
   - `test+tag@example.com` (plus sign)
   - `test.name@example.com` (dot)
   - `test_name@example.com` (underscore)

**Expected Results:**
- Valid special characters accepted
- Email updated successfully
- Verification email sent

---

## Test Scenario 11: SQL Injection Attempt

**Preconditions:**
- User without email attempts login

**Steps:**
1. Email collection modal appears
2. Enter malicious input:
   - `test@example.com'; DROP TABLE users; --`
   - `<script>alert('xss')</script>@example.com`

**Expected Results:**
- Input treated as string (not executed)
- Email format validation fails
- Error message displayed
- No database changes

---

## Test Scenario 12: Concurrent Updates

**Preconditions:**
- User without email
- Two browser tabs open

**Steps:**
1. Tab 1: Login and see email modal
2. Tab 2: Login and see email modal
3. Tab 1: Submit email `email1@example.com`
4. Tab 2: Submit email `email2@example.com`

**Expected Results:**
- First submission succeeds
- Second submission updates to new email
- Last update wins
- Both tabs redirect to login

---

## Test Scenario 13: Very Long Email

**Preconditions:**
- User without email attempts login

**Steps:**
1. Email collection modal appears
2. Enter very long email (>100 characters):
   `verylongemailaddressthatexceedsthemaximumlengthallowedinthedatabase@verylongdomainname.com`

**Expected Results:**
- Database field limit enforced (100 chars)
- Error or truncation handled gracefully
- User notified if email too long

---

## Test Scenario 14: Browser Back Button

**Preconditions:**
- User without email
- Email collection modal displayed

**Steps:**
1. Modal appears
2. Click browser back button

**Expected Results:**
- Modal remains visible (cannot be dismissed)
- User must provide email or close browser
- Back button doesn't bypass requirement

---

## Test Scenario 15: After Email Update - Full Flow

**Preconditions:**
- User just updated email via modal

**Steps:**
1. Redirected to login page
2. Enter same username and password
3. Click "Login"

**Expected Results:**
- Email collection modal DOES NOT appear
- Email verification check runs
- Verification email sent to new email
- Message: "Email not verified. Please check your email..."
- User can resend verification email
- After verification, user can access dashboard

---

## Performance Test Scenarios

### PT1: Response Time
- Email update should complete within 2 seconds
- Modal should appear within 500ms of login

### PT2: Concurrent Users
- 100 users updating emails simultaneously
- No database deadlocks
- All updates successful

### PT3: Database Load
- Email update query optimized
- No full table scans
- Proper indexing on username and email fields

---

## Security Test Scenarios

### ST1: Authentication Required
- Cannot access `/apis/user-email/update` without valid session
- Username must match authenticated user

### ST2: CSRF Protection
- API endpoint protected against CSRF attacks
- Proper headers required

### ST3: Rate Limiting
- Prevent rapid email update attempts
- Max 5 attempts per minute per user

---

## Accessibility Test Scenarios

### AT1: Screen Reader
- Modal title announced
- Form labels properly associated
- Error messages announced

### AT2: Keyboard Navigation
- Tab through form fields
- Enter key submits form
- Focus trapped in modal

### AT3: Color Contrast
- Text readable against backgrounds
- Error messages clearly visible
- WCAG AA compliance

---

## Browser Compatibility

Test on:
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

---

## Summary

Total test scenarios: 15 functional + 3 performance + 3 security + 3 accessibility = 24 test cases

**Priority:**
- P0 (Critical): Scenarios 1, 2, 3, 4, 5, 15
- P1 (High): Scenarios 6, 7, 8, 11, ST1, ST2
- P2 (Medium): Scenarios 9, 10, 12, 13, 14, PT1, AT1
- P3 (Low): PT2, PT3, AT2, AT3
