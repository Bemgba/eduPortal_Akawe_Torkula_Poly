# Complete Login System Flow

## Overview
This document explains exactly how the login system retrieves email/username and password, validates credentials, and grants access.

---

## Step-by-Step Login Process

### STEP 1: User Submits Login Form
**File:** `src/main/webapp/index.jsp` (Lines 101-107)

```java
String username = request.getParameter("username");  // Get from form input
String password = request.getParameter("password");  // Get from form input
String button   = request.getParameter("button");    // Check if form submitted

if (button != null && username != null && password != null && username.trim().length() > 0) {
    username = username.trim().toLowerCase();  // ✅ Convert to lowercase
    password = password.trim();                // ✅ Preserve original case
```

**What happens:**
- Retrieves `username` from form (user can enter email or username)
- Retrieves `password` from form
- **Converts username to lowercase** for case-insensitive matching
- **Preserves password case** for security

**Example:**
```
User enters:
  Username: User@Example.com
  Password: Test@123

After processing:
  username = "user@example.com"  ← lowercase
  password = "Test@123"          ← original case
```

---

### STEP 2: Collect User Agent Information
**File:** `src/main/webapp/index.jsp` (Lines 109-127)

```java
String ipAddress = request.getHeader("X-FORWARDED-FOR");
if (ipAddress == null) {
    ipAddress = request.getRemoteAddr();
}

String agent = "";
Enumeration<String> heads = request.getHeaderNames();
while (heads.hasMoreElements()) {
    String head = heads.nextElement();
    // Collect relevant headers (User-Agent, etc.)
    if (!head.equalsIgnoreCase("accept") && ...) {
        agent += request.getHeader(head) + ", ";
    }
}
agent = agent.length() > 190 ? agent.substring(0,190) : agent;
```

**What happens:**
- Gets user's IP address (for security logging)
- Collects browser/device information (User-Agent)
- Truncates to 190 characters if too long

**Purpose:** Security tracking and audit trail

---

### STEP 3: Call Login Method
**File:** `src/main/webapp/index.jsp` (Line 129)

```java
Users userd = sess.login(username, password, ipAddress, agent);
```

**What happens:**
- Calls `MainSession.login()` method
- Passes username (lowercase), password (original case), IP, and agent
- Returns `Users` object if successful, `null` if failed

---

### STEP 4: Database Query for User
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Lines 1033-1035)

```java
Users tmp = (Users) em.createQuery(
    "SELECT u FROM Users u WHERE u.username = :username OR u.email = :email"
)
.setParameter("email", username)
.setParameter("username", username)
.setMaxResults(1)
.getSingleResult();
```

**What happens:**
- Searches database for user by `username` OR `email`
- Both parameters set to the same value (the username input)
- Returns first matching user

**SQL Equivalent:**
```sql
SELECT * FROM users 
WHERE username = 'user@example.com' OR email = 'user@example.com'
LIMIT 1;
```

**Why it works:**
- During registration, both `username` and `email` are set to the email address (lowercase)
- Login converts input to lowercase
- Database comparison finds the match

---

### STEP 5: Password Validation
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Lines 1037-1040)

```java
if (tmp != null) {
    // Check password - support both case-sensitive and case-insensitive
    boolean passwordMatches = tmp.getPassword().equals(password) || 
                             tmp.getPassword().equalsIgnoreCase(password);
    
    if (passwordMatches) {
        user = tmp;  // ✅ Authentication successful
```

**What happens:**
- Compares stored password with entered password
- **First tries exact match** (case-sensitive): `equals()`
- **Then tries case-insensitive match**: `equalsIgnoreCase()` (for backward compatibility)
- If either matches, authentication succeeds

**Example:**
```
Database password: "Test@123"
User enters: "Test@123"
Result: equals() → TRUE ✅

Database password: "test@123" (old user)
User enters: "Test@123"
Result: equalsIgnoreCase() → TRUE ✅ (backward compatibility)
```

**Why both checks:**
- Old users have lowercase passwords (from before fix)
- New users have mixed-case passwords
- System supports both for smooth transition

---

### STEP 6: Load User Relationships
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Lines 1043-1049)

```java
// Force loading of relationships to avoid lazy loading issues
if (user.getDefaultRole() != null) {
    user.getDefaultRole().getName();  // Force load role
    if (user.getDefaultRole().getDefaulthome() != null) {
        user.getDefaultRole().getDefaulthome().getAlias();  // Force load home page
    }
}
```

**What happens:**
- Loads user's role from database
- Loads role's default home page
- Prevents lazy loading errors later

**Purpose:** Ensures all needed data is loaded before session ends

---

### STEP 7: Create Login Audit Log
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Lines 1051-1057)

```java
Userlogins log = new Userlogins(
    tmp.getId() + settings.getTodaysdate() + settings.generateId("", 6),
    settings.getCurrentDateTime(),
    ipAddress, 
    agent, 
    tmp
);
this.newEntry(log);
```

**What happens:**
- Creates a login record in `userlogins` table
- Stores: user ID, timestamp, IP address, device info
- Saves to database

**Purpose:** Security audit trail

---

### STEP 8: Update User Last Login Info
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Lines 1058-1061)

```java
user.setDatelastlogin(settings.getCurrentDateTime());
user.setDevicelastlogin(agent);
user.setIplastlogin(ipAddress);
this.updateUser(user);
```

**What happens:**
- Updates user's last login timestamp
- Updates last login device/browser info
- Updates last login IP address
- Saves changes to database

**Purpose:** Track user activity

---

### STEP 9: Return to Login Page
**File:** `src/main/java/com/mnl/eduportal/sessions/MainSession.java` (Line 1068)

```java
return user;  // Returns Users object if successful, null if failed
```

**What happens:**
- Returns authenticated user object to `index.jsp`
- Returns `null` if authentication failed

---

### STEP 10: Check Email Verification
**File:** `src/main/webapp/index.jsp` (Lines 131-175)

```java
if (userd != null) {
    // Check email verification status
    EmailVerificationSession emailVerificationSession = ...;
    LoginEligibilityResult eligibility = emailVerificationSession.checkLoginEligibility(userd);
    
    if (!eligibility.isEligible()) {
        // Show error: "Email not verified" or "Account locked"
        return;  // Stop login process
    }
```

**What happens:**
- Checks if email is verified (`email_verified_at` not null)
- Checks if account is locked (`locked_until` in future)
- If not eligible, shows error and stops login

**Purpose:** Security - ensure email ownership

---

### STEP 11: Validate User Configuration
**File:** `src/main/webapp/index.jsp` (Lines 177-181)

```java
boolean isValid = sess.validateApplicantUser(userd.getEmail());
if (!isValid) {
    System.out.println("WARNING: User has configuration issues");
}
```

**What happens:**
- Checks if user has valid role
- Checks if role has default home page
- Logs warning if misconfigured (but continues login)

**Purpose:** Diagnostic - identify configuration issues

---

### STEP 12: Load User Permissions
**File:** `src/main/webapp/index.jsp` (Lines 183-186)

```java
String pagesd = sess.getPagesString(userd.getId());
String menud  = sess.getDesignedMenu(userd.getId());
```

**What happens:**
- Loads list of pages user can access (based on role)
- Loads menu structure for user's dashboard
- Converts to string format for session storage

**Purpose:** Authorization - control what user can see/do

---

### STEP 13: Create User Session
**File:** `src/main/webapp/index.jsp` (Lines 188-190)

```java
session.setAttribute("USER", userd);
session.setAttribute("PAGES", pagesd);
session.setAttribute("MENU", menud);
```

**What happens:**
- Stores user object in HTTP session
- Stores accessible pages in session
- Stores menu structure in session

**Purpose:** Maintain login state across requests

---

### STEP 14: Redirect to Dashboard
**File:** `src/main/webapp/index.jsp` (Lines 192-194)

```java
String landingpage = userd.getDefaultRole().getDefaulthome().getAlias();
response.sendRedirect("/" + landingpage + "?login_success=true");
```

**What happens:**
- Gets user's role (e.g., "GENERAL APPLICANT")
- Gets role's default home page (e.g., "p0016")
- Gets page alias (e.g., "gen_app_dashboard")
- Redirects to: `/gen_app_dashboard?login_success=true`

**Example Flow:**
```
User Role: 1064 (GENERAL APPLICANT)
  ↓
Role Default Home: p0016
  ↓
Page Alias: gen_app_dashboard
  ↓
Redirect: /gen_app_dashboard
  ↓
File: genappDashboard.jsp
```

---

### STEP 15: Login Failed
**File:** `src/main/webapp/index.jsp` (Lines 196-200)

```java
} else {
    // userd is null - authentication failed
    %>
    <div class="alert alert-danger">
        Invalid username or password!
    </div>
```

**What happens:**
- If `sess.login()` returned `null`, show error
- User stays on login page
- Can try again

---

## Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User enters email/password in login form                │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. index.jsp retrieves and processes input                 │
│    - username = username.trim().toLowerCase()               │
│    - password = password.trim() (preserve case)             │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Call sess.login(username, password, ip, agent)          │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. MainSession.login() queries database                    │
│    SELECT * FROM users                                      │
│    WHERE username = ? OR email = ?                          │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Compare passwords                                        │
│    - Try exact match: equals()                              │
│    - Try case-insensitive: equalsIgnoreCase()              │
└────────────────────┬────────────────────────────────────────┘
                     ↓
         ┌───────────┴───────────┐
         ↓                       ↓
    ✅ Match                 ❌ No Match
         ↓                       ↓
┌────────────────────┐   ┌──────────────────┐
│ 6. Load role &     │   │ Return null      │
│    home page       │   │ Show error       │
└────────┬───────────┘   └──────────────────┘
         ↓
┌────────────────────┐
│ 7. Create audit    │
│    log entry       │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 8. Update last     │
│    login info      │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 9. Return user     │
│    object          │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 10. Check email    │
│     verification   │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 11. Load pages &   │
│     menu           │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 12. Create session │
│     attributes     │
└────────┬───────────┘
         ↓
┌────────────────────┐
│ 13. Redirect to    │
│     dashboard      │
└────────────────────┘
```

---

## Key Points

### Email/Username Handling
- ✅ Both stored as lowercase during registration
- ✅ Converted to lowercase during login
- ✅ Case-insensitive matching works correctly

### Password Handling
- ✅ Stored with original case during registration
- ✅ Preserved with original case during login
- ✅ Supports both exact and case-insensitive matching (backward compatibility)

### Security Features
1. **Email verification required** before login
2. **Account locking** after failed attempts
3. **Audit logging** of all login attempts
4. **IP and device tracking**
5. **Session management**

### Why Login Might Fail

1. **User doesn't exist** - Registration failed
2. **Password mismatch** - Wrong password or case issue
3. **Email not verified** - Must click verification link
4. **Account locked** - Too many failed attempts
5. **Role/page misconfigured** - Database issue

---

## Related Files

- **`src/main/webapp/index.jsp`** - Login form and flow control
- **`src/main/java/com/mnl/eduportal/sessions/MainSession.java`** - Authentication logic
- **`src/main/java/com/mnl/eduportal/sessions/EmailVerificationSession.java`** - Email verification checks
- **`src/main/webapp/applicationsRegister.jsp`** - Registration (creates users)

---

**Last Updated:** February 11, 2026
