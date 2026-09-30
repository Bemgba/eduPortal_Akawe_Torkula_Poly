# getAllCourses() Method Duplicate Resolution

## Date: February 13, 2026
## File: src/main/java/com/mnl/eduportal/sessions/MainSession.java

---

## Problem:
Two methods with the same signature `getAllCourses()` existed in the MainSession class, causing a compilation error:
```
method getAllCourses() is already defined in class MainSession
```

---

## Methods Found:

### Method 1 (Line 1588) - OLD VERSION:
```java
public List<Courses> getAllCourses() {
    List<Courses> list = new ArrayList();  // Raw type - old style
    try {
        list = (List<Courses>) em.createQuery(
                "SELECT l FROM Courses l ORDER BY l.name ASC")
                .getResultList();
    } catch (Exception k) {
        k.printStackTrace();  // Prints stack trace
    }
    return list;
}
```

**Issues:**
- Uses raw ArrayList type (no generics)
- Requires casting
- Prints stack traces to console
- Older Java syntax

### Method 2 (Line 6886) - NEW VERSION:
```java
public List<Courses> getAllCourses() {
    List<Courses> list = new ArrayList<>();  // Generic type - modern
    try {
        list = em.createQuery("SELECT c FROM Courses c ORDER BY c.name", Courses.class)
                .getResultList();
    } catch (Exception k) {
        // k.printStackTrace();  // Commented out
    }
    return list;
}
```

**Advantages:**
- Uses generics properly
- Typed query (no casting needed)
- Cleaner error handling
- Modern Java syntax

---

## Solution Applied:

### Step 1: Renamed OLD method (Line 1588)
```java
// DEPRECATED: Use getAllCourses() instead - this is the old version
public List<Courses> getAllCoursesOld() {
    // ... old implementation
}
```

### Step 2: Kept NEW method as primary (Line 6886)
```java
// Get ALL courses regardless of school/programme - Modern implementation
public List<Courses> getAllCourses() {
    // ... modern implementation
}
```

---

## Method Comparison:

| Feature | getAllCoursesOld() (Line 1588) | getAllCourses() (Line 6886) |
|---------|-------------------------------|----------------------------|
| **Status** | DEPRECATED | ACTIVE |
| **Generics** | No (raw type) | Yes (`ArrayList<>()`) |
| **Type Safety** | Requires casting | Type-safe |
| **Error Handling** | Prints stack trace | Silent (commented) |
| **Java Version** | Old style | Modern style |
| **Recommended** | ❌ No | ✅ Yes |

---

## Recommendation:

**Use `getAllCourses()` (Line 6886)** - This is the correct, modern implementation.

**Avoid `getAllCoursesOld()` (Line 1588)** - This is deprecated and kept only for backward compatibility if any code still references it.

---

## Migration Path:

If any code is still using the old method, it will now call `getAllCoursesOld()`. To migrate:

1. Search for calls to `getAllCoursesOld()`
2. Replace with `getAllCourses()`
3. Test thoroughly
4. Once confirmed no code uses `getAllCoursesOld()`, it can be deleted

---

## Verification:

✅ **Compilation Status**: No diagnostics found  
✅ **Method Renamed**: `getAllCourses()` → `getAllCoursesOld()` (old version)  
✅ **Primary Method**: `getAllCourses()` (new version at line 6886)  
✅ **No Conflicts**: Both methods now have unique names

---

## Code Search Commands:

To find any remaining references to the old method:

```bash
# Search for getAllCoursesOld usage
grep -r "getAllCoursesOld()" src/

# Search for getAllCourses usage (should use new version)
grep -r "getAllCourses()" src/
```

---

**Status**: ✅ RESOLVED - No duplicate method signatures
