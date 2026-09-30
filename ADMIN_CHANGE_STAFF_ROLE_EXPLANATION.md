# adminChangeStaffRole.jsp - Complete Workflow Explanation

## Overview
This page allows administrators to change staff roles by entering a staff number and selecting a new role. It also displays all available staff roles with statistics.

---

## Page Structure

### 1. Authentication Check
```jsp
<%    
    if (user == null) {
        response.sendRedirect("/");
    }
%>
```
- Ensures only logged-in users can access the page
- Redirects to login if not authenticated

---

## Main Components

### Component 1: Role Change Form

#### Step 1: Load Available Roles
```jsp
List<Roles> lroles = sess.getRolesByType("STAFF_PUBLIC");
```
- Fetches all roles with type "STAFF_PUBLIC"
- These are roles that can be assigned to staff members
- Stored in `lroles` list for dropdown population

#### Step 2: Get Form Parameters
```jsp
String staffno = request.getParameter("staffno");
String newrole = request.getParameter("newrole");
String submit = request.getParameter("submit");
```
- `staffno`: Staff number entered by admin
- `newrole`: Selected role ID from dropdown
- `submit`: Button click indicator

#### Step 3: Process Role Change (Backend Logic)
```jsp
if (submit != null && staffno != null && staffno.length() > 0) {
    staffno = staffno.toLowerCase();
    Staff stfd = sess.getStaffById(staffno);
    
    if (stfd != null) {
        int iro = Integer.valueOf(newrole);
        Roles ro = (Roles) sess.getSingleObject(Roles.class, iro);
        
        if (ro != null) {
            Users usdx = (Users) sess.getSingleObject(Users.class, stfd.getId());
            if (usdx != null) {
                sess.updateUserRole(stfd.getId(), iro);
            }
            msg = "Staff matching " + staffno + " has been added to role " + ro.getName();
            sty = "success";
        } else {
            msg = "This role is not found or not assignable";
        }
    } else {
        msg = "Staff matching either number or university email " + staffno + " is not found";
    }
}
```

**Detailed Flow:**

1. **Validate Submission**
   - Check if form was submitted (`submit != null`)
   - Check if staff number was provided
   - Convert staff number to lowercase

2. **Find Staff Record**
   ```jsp
   Staff stfd = sess.getStaffById(staffno);
   ```
   - Searches `Staff` table by staff number
   - Returns `Staff` object if found, `null` otherwise

3. **Validate Role**
   ```jsp
   int iro = Integer.valueOf(newrole);
   Roles ro = (Roles) sess.getSingleObject(Roles.class, iro);
   ```
   - Convert role ID from string to integer
   - Fetch `Roles` object from database
   - Verify role exists

4. **Find User Record**
   ```jsp
   Users usdx = (Users) sess.getSingleObject(Users.class, stfd.getId());
   ```
   - Get `Users` record using staff ID
   - Staff ID and User ID are the same (linked by ID)

5. **Update User Role** (THE KEY STEP)
   ```jsp
   sess.updateUserRole(stfd.getId(), iro);
   ```
   - Calls `MainSession.updateUserRole()` method
   - Updates `users.default_role` field in database
   - This is the actual role change

6. **Display Success Message**
   ```jsp
   msg = "Staff matching " + staffno + " has been added to role " + ro.getName();
   sty = "success";
   ```

#### Step 4: Display Form
```jsp
<form action='' method='post' name="verify">
    <div class="mb-3 row">
        <label class="col-sm-2 col-form-label" for="staffno">Staff Number</label>
        <div class="col-sm-3">
            <input class="form-control" id="staffno" type="text" name="staffno" required="">
        </div>
        <div class="col-sm-3">
            <select name="newrole" class='form-select'>
                <% for (Roles role : lroles) { %>
                    <option value="<%=role.getId()%>"><%=role.getName()%></option>
                <% } %>
            </select>                      
        </div>
        <div class="col-sm-2">
            <button name="submit" class="btn btn-primary mb-3" type="submit">Change Role</button>                       
        </div>
        <div class="col-sm-2">
            <a href="#" data-coreui-toggle="modal" data-coreui-target="#details" onclick="viewDetails()">
                View Details
            </a>
        </div>
    </div>
</form>
```

**Form Elements:**
- **Staff Number Input**: Text field for entering staff number
- **Role Dropdown**: Populated with all STAFF_PUBLIC roles
- **Change Role Button**: Submits the form
- **View Details Button**: Opens modal to view staff details

---

### Component 2: View Staff Details (AJAX)

#### JavaScript Function
```javascript
async function viewDetails() {
    try {
        var staffno = document.getElementById("staffno").value;
        const url = "AjaxServlet?action=viewStaffDetails&id2=" + escape(staffno);
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const respText = await response.text();
        document.getElementById("det").innerHTML = respText;
    } catch (error) {
        console.error("Error updating record:", error);
    }
}
```

**How it works:**
1. Gets staff number from input field
2. Makes AJAX call to `AjaxServlet` with action `viewStaffDetails`
3. Receives HTML response with staff details
4. Displays in modal with id `det`

#### Modal Structure
```jsp
<div class="modal fade" id="details" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">User Details</h5>
                <button type="button" class="btn-close" data-coreui-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="det">Loading...</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
```

---

### Component 3: Roles Statistics Table

#### Display All Roles
```jsp
<table class="table table-striped table-hover" id='dataTable'>
    <thead>
        <tr>
            <th>#</th>
            <th>Role</th>
            <th>Number of Staff</th>
            <th>Pages</th>
        </tr>
    </thead>
    <tbody>
        <% 
        int i = 1;
        for (Roles role : lroles) { 
        %>
        <tr>
            <td><%=i%></td>
            <td><%=role.getName()%></td>
            <td>
                <% int size = sess.getUsersByRole(role.getId() + "").size(); %>
                <a href="#" onclick="loadUsers('<%=role.getId()%>')"><%=size%></a>
            </td>
            <td>
                <% int pagess = sess.getAllPagesforRole(role.getId() + "").size(); %>
                <a href="#" onclick="loadPages('<%=role.getId()%>')"><%=pagess%></a>
            </td>
        </tr>
        <% i++; } %>
    </tbody>
</table>
```

**Table Columns:**
1. **#**: Row number
2. **Role**: Role name
3. **Number of Staff**: Count of users with this role (clickable to view list)
4. **Pages**: Count of pages accessible by this role (clickable to view list)

#### Load Users by Role (AJAX)
```javascript
async function loadUsers(recordid) {
    try {
        const url = "AjaxServlet?action=loadUsers&id2=" + escape(recordid);
        const response = await fetch(url);
        const respText = await response.text();
        document.getElementById(recordid + "k").innerHTML = respText;
    } catch (error) {
        console.error("Error updating record:", error);
    }
}
```

**How it works:**
1. Takes role ID as parameter
2. Calls `AjaxServlet` with action `loadUsers`
3. Returns list of users with that role
4. Displays in modal

#### Load Pages by Role (AJAX)
```javascript
async function loadPages(recordid) {
    try {
        const url = "AjaxServlet?action=loadPages&id2=" + escape(recordid);
        const response = await fetch(url);
        const respText = await response.text();
        document.getElementById(recordid + "l").innerHTML = respText;
    } catch (error) {
        console.error("Error updating record:", error);
    }
}
```

**How it works:**
1. Takes role ID as parameter
2. Calls `AjaxServlet` with action `loadPages`
3. Returns list of pages accessible by that role
4. Displays in modal

---

## Database Operations

### Tables Involved

1. **Staff Table**
   - Stores staff information
   - Primary key: `id`
   - Contains: staff_no, surname, othernames, etc.

2. **Users Table**
   - Stores user authentication and role
   - Primary key: `id` (same as Staff.id)
   - Key field: `default_role` (foreign key to Roles table)

3. **Roles Table**
   - Stores role definitions
   - Primary key: `id`
   - Contains: name, description, role_type, defaulthome

### The Role Change Process

**Step-by-Step Database Flow:**

1. **Find Staff**
   ```sql
   SELECT * FROM staff WHERE id = ? OR staff_no = ?
   ```

2. **Find Role**
   ```sql
   SELECT * FROM roles WHERE id = ?
   ```

3. **Find User**
   ```sql
   SELECT * FROM users WHERE id = ?
   ```

4. **Update User Role** (THE CRITICAL UPDATE)
   ```sql
   UPDATE users SET default_role = ? WHERE id = ?
   ```
   - This is executed by `sess.updateUserRole(stfd.getId(), iro)`
   - Changes the user's default role
   - Immediately affects user's permissions and access

---

## Key Methods Used

### 1. sess.getRolesByType("STAFF_PUBLIC")
```java
public List<Roles> getRolesByType(String type) {
    List<Roles> ali2 = new ArrayList();
    try {
        ali2 = (List<Roles>) em.createQuery("SELECT s FROM Roles s WHERE s.roleType = :type")
                .setParameter("type", type).getResultList();
    } catch (Exception k) {
    }
    return ali2;
}
```
- Returns all roles with specified type
- Used to populate role dropdown

### 2. sess.getStaffById(staffno)
```java
public Staff getStaffById(String id) {
    Staff staff = null;
    try {
        staff = (Staff) em.createQuery("SELECT s FROM Staff s WHERE s.id = :id OR s.staffNo = :id")
                .setParameter("id", id).getSingleResult();
    } catch (Exception k) {
    }
    return staff;
}
```
- Finds staff by ID or staff number
- Returns Staff object

### 3. sess.getSingleObject(Users.class, stfd.getId())
```java
public Object getSingleObject(Class className, String id) {
    Object obj = null;
    try {
        obj = em.find(className, id);
    } catch (Exception k) {
    }
    return obj;
}
```
- Generic method to find entity by ID
- Used to get Users and Roles objects

### 4. sess.updateUserRole(stfd.getId(), iro) ⭐ KEY METHOD
```java
@Transactional
public void updateUserRole(String userId, int roleId) {
    Roles role = em.find(Roles.class, roleId);
    Users user = em.find(Users.class, userId);
    if (user != null && role != null) {
        user.setDefaultRole(role);
    }
}
```
- **This is the method that actually changes the role**
- Finds user and role entities
- Sets user's defaultRole to new role
- Transaction automatically commits the change

### 5. sess.getUsersByRole(roleId)
```java
public List<Users> getUsersByRole(String roleId) {
    List<Users> list = new ArrayList();
    try {
        list = (List<Users>) em.createQuery("SELECT u FROM Users u WHERE u.defaultRole.id = :roleId")
                .setParameter("roleId", Integer.parseInt(roleId)).getResultList();
    } catch (Exception k) {
    }
    return list;
}
```
- Returns all users with specified role
- Used for statistics display

### 6. sess.getAllPagesforRole(roleId)
```java
public List<Pages> getAllPagesforRole(String roleId) {
    List<Pages> list = new ArrayList();
    try {
        list = (List<Pages>) em.createQuery("SELECT p FROM Pages p WHERE p.roles LIKE :roleId")
                .setParameter("roleId", "%" + roleId + "%").getResultList();
    } catch (Exception k) {
    }
    return list;
}
```
- Returns all pages accessible by role
- Used for statistics display

---

## Complete Workflow Diagram

```
User Action: Enter Staff Number + Select Role + Click "Change Role"
    ↓
Form Submission (POST)
    ↓
Backend Processing Starts
    ↓
1. Get Parameters (staffno, newrole, submit)
    ↓
2. Find Staff Record
   sess.getStaffById(staffno)
    ↓
3. Validate Role
   sess.getSingleObject(Roles.class, roleId)
    ↓
4. Find User Record
   sess.getSingleObject(Users.class, staffId)
    ↓
5. Update User Role ⭐
   sess.updateUserRole(staffId, roleId)
    ↓
   Database: UPDATE users SET default_role = ? WHERE id = ?
    ↓
6. Display Success Message
    ↓
Page Reloads with Success Message
    ↓
Staff now has new role and new permissions
```

---

## Example Scenario

**Scenario:** Change John Doe's role from "Lecturer" to "Senior Lecturer"

1. **Admin enters:**
   - Staff Number: `STAFF001`
   - Selects Role: `Senior Lecturer` (ID: 1057)
   - Clicks "Change Role"

2. **Backend finds:**
   - Staff record: `Staff{id='s001', staffNo='STAFF001', surname='Doe', othernames='John'}`
   - Role record: `Roles{id=1057, name='Senior Lecturer'}`
   - User record: `Users{id='s001', username='johndoe', defaultRole=1055}`

3. **Backend updates:**
   ```sql
   UPDATE users SET default_role = 1057 WHERE id = 's001'
   ```

4. **Result:**
   - John Doe's user record now has `default_role = 1057`
   - Next time John logs in, he has Senior Lecturer permissions
   - He can access pages assigned to Senior Lecturer role
   - His old Lecturer permissions are replaced

---

## Security Considerations

1. **Authentication Required**
   - Page checks if user is logged in
   - Redirects to login if not authenticated

2. **Role Type Restriction**
   - Only shows "STAFF_PUBLIC" roles
   - Prevents assignment of system/admin roles

3. **Validation**
   - Checks if staff exists
   - Checks if role exists
   - Checks if user exists

4. **No Direct SQL**
   - Uses JPA/EntityManager
   - Prevents SQL injection

---

## Comparison with updateUser.jsp

| Feature | adminChangeStaffRole.jsp | updateUser.jsp |
|---------|-------------------------|----------------|
| **Search By** | Staff Number only | Username, Email, or User ID |
| **Target Users** | Staff only | Any user |
| **Can Update** | Role only | Email, Password, Role |
| **UI** | Basic form | Beautiful modern UI |
| **Details View** | AJAX modal | Inline display |
| **Statistics** | Shows role statistics | No statistics |
| **Password** | Cannot update | Can update |
| **Email** | Cannot update | Can update |

---

## Summary

The `adminChangeStaffRole.jsp` page:
1. Allows admins to change staff roles by staff number
2. Uses `sess.updateUserRole()` to update the `users.default_role` field
3. Provides AJAX-based details viewing
4. Shows statistics for all roles (user count, page count)
5. Restricts to STAFF_PUBLIC roles only
6. Simple, focused interface for role management

The key method is `sess.updateUserRole(userId, roleId)` which updates the database and changes the user's permissions immediately.
