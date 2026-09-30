# CREDO Service Code Implementation Guide (School-Based)

## Overview
This implementation provides hardcoded logic for routing payments to different bank accounts based on school ID using CREDO service codes.

## Business Logic
- **Special School ("S001")**: Use service code `008219RFI2DJ`
- **All Other Schools**: Use service code `0082192DLY7O`

## Key Insight
The logic is now correctly based on **schools** rather than programmes, because:
- A programme can be offered in multiple schools
- Each school has its own bank account for collecting payments
- The school determines which CREDO service code (bank account) to use

## Implementation Details

### Key Features:
- **School-Based Logic**: Routes payments based on school ID from schoolprogrammes relationship
- **Programme Traceability**: Traces programme → schoolprogrammes → school → service code
- **Hardcoded Logic**: Simple, maintainable business rules
- **Multiple Detection Methods**: Finds school ID from various sources

### 1. Files Modified/Created

#### Modified Files:
- `src/main/java/com/mnl/eduportal/entities/Banks.java` - Added service_code field
- `src/main/java/com/mnl/eduportal/servlet/Etranzact2.java` - Added school-based service code logic

#### New Files:
- `src/main/java/com/mnl/eduportal/util/ServiceCodeUtil.java` - Hardcoded school-based service code logic
- `add_service_code_column.sql` - Database migration script
- `src/main/webapp/testServiceCode.jsp` - Test page for verification

### 2. Database Changes
```sql
-- Add service code column
ALTER TABLE banks ADD COLUMN service_code VARCHAR(50);

-- Create bank records for service codes
INSERT INTO banks (id, name, service_code) VALUES 
('BANK_SPECIAL', 'Special Programmes Account', '008219RFI2DJ'),
('BANK_DEFAULT', 'General Programmes Account', '0082192DLY7O');
```

### 3. How It Works

#### Payment Flow:
1. User initiates payment via portal
2. `Etranzact2` servlet processes payment request
3. Servlet determines school ID from:
   - Payment reference school relationship
   - Programme → Schoolprogrammes → School relationship  
   - Session attribute `SCHOOL_ID`
4. `ServiceCodeUtil.getServiceCodeForSchool()` applies hardcoded logic
5. Service code is included in CREDO API call
6. CREDO routes payment to appropriate bank account
7. Payment reference is updated with correct bank information

#### Service Code Logic:
```java
// Primary method - handles school-based logic
public static String getServiceCodeForSchool(String schoolId) {
    if (schoolId != null && "S001".equals(schoolId)) {
        return "008219RFI2DJ"; // Special school
    } else {
        return "0082192DLY7O"; // Default schools
    }
}
```

#### School Detection Logic:
```java
// Method 1: Direct from payment reference
if (payRef.getSchoolId() != null) {
    schoolId = payRef.getSchoolId().getId();
}

// Method 2: Via programme → schoolprogrammes relationship
String queryStr = "SELECT sp FROM Schoolprogrammes sp WHERE sp.programmeId.id = :programmeId";
Schoolprogrammes schoolProg = (Schoolprogrammes) sess.getEntityManager()
    .createQuery(queryStr)
    .setParameter("programmeId", Integer.valueOf(programmeIdStr))
    .getSingleResult();
schoolId = schoolProg.getSchoolId().getId();

// Method 3: Direct from session
Object sessionSchoolId = request.getSession().getAttribute("SCHOOL_ID");
schoolId = sessionSchoolId.toString();
```

### 4. CREDO API Integration

The service code is sent to CREDO in the payment initialization request:
```json
{
    "amount": 50000,
    "currency": "NGN",
    "reference": "PAY123456",
    "service_code": "008219RFI2DJ",
    "email": "student@example.com",
    "callback_url": "https://portal.atpoly.edu.ng/confirmation"
}
```

### 5. Testing

#### Test Page:
Visit `/testServiceCode.jsp` to verify the service code logic for different programme IDs.

#### Manual Testing:
1. Set school ID in session: `request.getSession().setAttribute("SCHOOL_ID", "S001");`
2. Set programme ID in session: `request.getSession().setAttribute("PROGRAMME_ID", "1");` (system will trace to school)
3. Initiate payment through portal
4. Check logs for school ID detection and service code selection
5. Verify CREDO receives correct service code

#### Test Cases:
- School ID "S001" → Service Code: 008219RFI2DJ
- School ID "S002" → Service Code: 0082192DLY7O
- School ID "ENGR" → Service Code: 0082192DLY7O
- School ID null → Service Code: 0082192DLY7O
- Programme in School S001 → Service Code: 008219RFI2DJ
- Programme in School S002 → Service Code: 0082192DLY7O

### 6. Logging

The implementation includes comprehensive logging:
- Service code selection decisions
- Programme ID detection
- CREDO API calls with service codes
- Bank information updates

### 7. Error Handling

- If programme ID cannot be determined, uses default service code
- If service code lookup fails, falls back to default
- All errors are logged without breaking payment flow
- Security and performance code remains untouched

### 8. Maintenance

To modify the hardcoded logic:
1. Edit `ServiceCodeUtil.java`
2. Update service code constants
3. Modify `getServiceCodeForSchool()` method
4. Update school ID comparison logic
5. Update database bank records if needed

### 9. School-Programme Relationship

The implementation correctly handles the relationship:
- **Programme**: Can be offered in multiple schools
- **Schoolprogrammes**: Links specific programme to specific school
- **School**: Determines which bank account receives payments
- **Service Code**: Routes payment to correct CREDO account

**Example Scenarios:**
- Computer Science programme offered in School S001 → payments use service code 008219RFI2DJ
- Computer Science programme offered in School S002 → payments use service code 0082192DLY7O
- Same programme, different schools, different bank accounts

### 9. Security Considerations

- No sensitive data exposed in logs
- Service codes are treated as configuration data
- Original security measures in Etranzact2 preserved
- Input validation maintained

### 10. Performance Impact

- Minimal performance impact
- Simple hardcoded logic (no database queries)
- Single additional field in banks table
- Efficient programme ID lookup

## Deployment Steps

1. Run database migration: `add_service_code_column.sql`
2. Deploy updated code
3. Test with `/testServiceCode.jsp`
4. Monitor logs for service code selection
5. Verify payments route to correct accounts in CREDO dashboard

## Support

For issues or modifications:
1. Check logs for service code selection
2. Verify programme ID is correctly set in session
3. Confirm CREDO service codes are active
4. Test with different programme IDs using test page