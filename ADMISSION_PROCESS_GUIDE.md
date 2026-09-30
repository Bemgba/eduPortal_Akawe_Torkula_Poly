# University Admission Process Guide

## Overview
This guide explains the complete admission process from harvesting qualified applicants to uploading admission lists and generating admission templates.

## Admission Process Flow

### 1. **Harvest Complete Applications**
**Purpose**: Identify applicants who qualify for admission consideration
**Location**: Staff Dashboard → "Complete Applications" download link
**Criteria**: Applicants must have:
- ✅ Complete UTME data (English + 3 subjects with scores)
- ✅ Payment records
- ✅ Current session application

**Output**: Excel file with qualified applicants in JAMB format

### 2. **Set Up Admission Templates (Per Course)**
**Purpose**: Define admission criteria and scoring system for each course
**Location**: Need to be configured in the system
**Components**:

#### **Scoring Weights** (Must total 100%):
- **UTME Percentage**: Weight for JAMB scores (e.g., 50%)
- **O-Level Percentage**: Weight for O-Level results (e.g., 40%) 
- **Post-UTME Percentage**: Weight for aptitude test (e.g., 10%)

#### **Subject Requirements**:
- **Compulsory UTME Subjects**: Required JAMB subjects (e.g., English, Mathematics)
- **Other UTME Subjects**: Additional JAMB subjects to choose from
- **Compulsory O-Level Subjects**: Required O-Level subjects
- **Other O-Level Subjects**: Additional O-Level subjects to choose from

#### **Merit Distribution**:
- **Total Merit Quota**: Total number of admission slots
- **National Merit %**: Percentage for national merit (best candidates nationwide)
- **State Merit %**: Percentage for state merit (best candidates from state)
- **LGA Merit %**: Percentage for LGA equality (distributed across LGAs)

### 3. **Generate Admission Template**
**Purpose**: Create comprehensive admission analysis with scoring
**Process**:
1. System calculates composite scores for each applicant:
   ```
   Total Score = (UTME Score × UTME%) + (O-Level Score × O-Level%) + (Post-UTME × Post-UTME%)
   ```
2. Ranks applicants by total score
3. Applies merit distribution criteria
4. Generates 4 sheets:
   - **Admission Summary**: Statistics and quota distribution
   - **Merit List**: Candidates selected for admission
   - **Other Recommended**: Qualified but not selected due to quota
   - **Non-Recommended**: Candidates with incomplete requirements

### 4. **Upload Admission List**
**Purpose**: Officially admit selected candidates
**Location**: `adminadmissionlist.jsp` → "Upload admission list" button
**Process**:

#### **Template Format** (admissionlist.xls):
```
Column 1: SNO (Serial Number)
Column 2: JAMB_NO (Application ID)
Column 3: MODE_OF_ENTRY (UTME/DE)
Column 4: MERIT_STATUS (NM/SM/ELG/LM/SPECIAL)
```

#### **Merit Status Codes**:
- **NM**: National Merit
- **SM**: State Merit  
- **ELG**: Equality of LGA
- **LM**: Locality Merit
- **SPECIAL**: Special Merit

#### **Upload Process**:
1. Select course to admit into
2. Upload Excel file with selected candidates
3. System validates each applicant:
   - Checks if applicant exists
   - Verifies current session
   - Creates admission record
4. Generates upload report showing success/failure for each candidate

### 5. **Admission Record Creation**
**What happens when admission is uploaded**:
- Creates `Admissions` record with:
  - Admission status: "PENDING"
  - Course admitted into
  - Merit type (NM/SM/ELG/LM/SPECIAL)
  - Mode of entry (UTME/DE)
  - Personal details copied from application
- Changes applicant status to "ADMITTED"

## Admission Criteria Details

### **UTME Requirements**
- **English**: Mandatory for all courses
- **Subject Combination**: Varies by course (e.g., Mathematics, Physics, Chemistry for Engineering)
- **Minimum Score**: Usually 180+ (varies by course and year)

### **O-Level Requirements**
- **Compulsory Subjects**: English, Mathematics (minimum C6)
- **Course-Specific Subjects**: Varies by course
- **Sitting Allowance**: 
  - 1 sitting = 10 points bonus
  - 2 sittings = 6 points bonus
  - More than 2 sittings = 0 points bonus

### **Scoring System Example**
```
For a course with 50% UTME, 40% O-Level, 10% Post-UTME:

Applicant with:
- UTME: 280/400 → 280 × 50% ÷ 400 = 35 points
- O-Level: 30 points + 10 sitting bonus = 40 → 40 × 40% ÷ 40 = 40 points  
- Post-UTME: 70/100 → 70 × 10% ÷ 100 = 7 points
- Total Score: 35 + 40 + 7 = 82 points
```

### **Merit Distribution Example**
```
Course Quota: 100 students
- National Merit (60%): 60 slots - Best 60 candidates nationwide
- State Merit (25%): 25 slots - Best 25 candidates from Benue State
- LGA Merit (15%): 15 slots - Distributed across 23 LGAs (≈1 per LGA)
```

## Step-by-Step Admission Workflow

### **Phase 1: Preparation**
1. **Download Complete Applications** from staff dashboard
2. **Review qualification statistics** in summary report
3. **Set up admission templates** for each course (if not done)

### **Phase 2: Selection**
1. **Generate admission template** for each course
2. **Review merit lists** and recommended candidates
3. **Select candidates** based on:
   - Available quota
   - Merit distribution requirements
   - Course-specific criteria

### **Phase 3: Upload**
1. **Prepare admission Excel file** with selected candidates
2. **Upload admission list** per course
3. **Review upload report** for any errors
4. **Verify admission records** were created correctly

### **Phase 4: Verification**
1. **Download admission list** to verify uploaded candidates
2. **Check admission statistics** per course
3. **Generate final reports** for management

## Key Files and Locations

### **Templates**:
- `templates/admissionlist.xls` - Admission upload template
- `templates/utme_applicants_sample.xls` - Complete applications format

### **Pages**:
- `adminadmissionlist.jsp` - Main admission management page
- `staffdashboard.jsp` - Contains complete applications download link

### **Servlets**:
- `UploadJambAdmissionlist` - Processes admission uploads
- `DownloadCompleteApplications` - Exports qualified applicants
- `DownloadAdmissionTemplate` - Generates admission analysis

## Important Notes

### **Data Consistency**:
- UTME subjects stored as IDs, converted to names for display
- Payment verification uses multiple payment record checks
- Application types include: "ug", "UTME", "DE", "REM"

### **Validation Rules**:
- Applicants must be in current session
- Applicants must exist in system
- Course must be valid
- Merit status must be valid code

### **Error Handling**:
- Upload report shows success/failure for each candidate
- Failed uploads don't affect successful ones
- Detailed error messages for troubleshooting

### **Security**:
- User authentication required
- Encrypted parameters in URLs
- Session-based access control

## Troubleshooting

### **Common Issues**:
1. **No qualified applicants**: Check UTME data completeness and payment status
2. **Upload failures**: Verify JAMB numbers exist and are in current session
3. **Wrong course admission**: Ensure correct course selected during upload
4. **Merit distribution errors**: Check admission template configuration

### **Best Practices**:
1. **Always download complete applications first** to see available candidates
2. **Review admission templates** before generating merit lists
3. **Test with small batches** before bulk uploads
4. **Keep backup** of admission files
5. **Verify uploads** with download reports

This comprehensive process ensures fair, transparent, and systematic admission based on merit and institutional requirements.