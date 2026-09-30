/*
 * Simple utility class for hardcoded CREDO service code logic
 */
package com.mnl.eduportal.util;

/**
 * Utility class to determine CREDO service codes based on school ID
 * This implements the hardcoded business logic for service code selection
 * @author eduportal
 */
public class ServiceCodeUtil {
    
    // Hardcoded service codes as per requirements
    private static final String SERVICE_CODE_SPECIAL_SCHOOL = "008219RFI2DJ"; // For school S001
    private static final String SERVICE_CODE_DEFAULT = "0082192DLY7O"; // For all other schools
    
    /**
     * Get the appropriate CREDO service code based on school ID
     * Business Logic: 
     * - If schoolId = "S001", use service code "008219RFI2DJ"
     * - For all other schools, use service code "0082192DLY7O"
     * 
     * @param schoolId The school ID (can be null)
     * @return The appropriate CREDO service code
     */
    public static String getServiceCodeForSchool(String schoolId) {
        if (schoolId != null && "S001".equals(schoolId)) {
            System.out.println("ServiceCodeUtil: School " + schoolId + " -> Special service code: " + SERVICE_CODE_SPECIAL_SCHOOL);
            return SERVICE_CODE_SPECIAL_SCHOOL;
        } else {
            System.out.println("ServiceCodeUtil: School " + schoolId + " -> Default service code: " + SERVICE_CODE_DEFAULT);
            return SERVICE_CODE_DEFAULT;
        }
    }
    
    /**
     * Get the bank ID that should be associated with a school
     * This maps service codes to bank IDs for record keeping
     * 
     * @param schoolId The school ID
     * @return The bank ID to use for this school
     */
    public static String getBankIdForSchool(String schoolId) {
        if (schoolId != null && "S001".equals(schoolId)) {
            return "BANK_SPECIAL"; // Bank ID for special school
        } else {
            return "BANK_DEFAULT"; // Bank ID for default schools
        }
    }
    
    /**
     * Check if a school uses the special service code
     * 
     * @param schoolId The school ID
     * @return true if school uses special service code, false otherwise
     */
    public static boolean isSpecialSchool(String schoolId) {
        return schoolId != null && "S001".equals(schoolId);
    }
    
    /**
     * Get description of the service code logic for logging/debugging
     * 
     * @param schoolId The school ID
     * @return Description string
     */
    public static String getServiceCodeDescription(String schoolId) {
        if (isSpecialSchool(schoolId)) {
            return "Special school (S001) -> Service Code: " + SERVICE_CODE_SPECIAL_SCHOOL;
        } else {
            return "Default schools -> Service Code: " + SERVICE_CODE_DEFAULT;
        }
    }
    
    // Legacy methods for backward compatibility (deprecated)
    @Deprecated
    public static String getServiceCodeForProgramme(String programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use getServiceCodeForSchool() instead");
        return getServiceCodeForSchool(null); // Default to general service code
    }
    
    @Deprecated
    public static String getServiceCodeForProgramme(Integer programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use getServiceCodeForSchool() instead");
        return getServiceCodeForSchool(null); // Default to general service code
    }
    
    @Deprecated
    public static String getBankIdForProgramme(String programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use getBankIdForSchool() instead");
        return getBankIdForSchool(null);
    }
    
    @Deprecated
    public static String getBankIdForProgramme(Integer programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use getBankIdForSchool() instead");
        return getBankIdForSchool(null);
    }
    
    @Deprecated
    public static boolean isSpecialProgramme(String programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use isSpecialSchool() instead");
        return false;
    }
    
    @Deprecated
    public static boolean isSpecialProgramme(Integer programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use isSpecialSchool() instead");
        return false;
    }
    

    
    @Deprecated
    public static String getServiceCodeDescription(Integer programmeId) {
        System.out.println("ServiceCodeUtil: DEPRECATED - Use getServiceCodeDescription() with school ID instead");
        return getServiceCodeDescription((String) null);
    }
}