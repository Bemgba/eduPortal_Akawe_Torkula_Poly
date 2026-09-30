package com.mnl.eduportal.util;

public class CourseSummaryDTO {

    private String courseId;
    private String departmentName;
    private String courseName;
    private String level;
    private Long totalStudents;
    private Long gstFirstCount;
    private Long gstFirstCredits;
    private Long coreFirstCount;
    private Long coreFirstCredits;
    private Long electiveFirstCount;
    private Integer minCUFirst;
    private Integer maxCUFirst;
    private Long gstSecondCount;
    private Long gstSecondCredits;
    private Long coreSecondCount;
    private Long coreSecondCredits;
    private Long electiveSecondCount;
    private Integer minCUSecond;
    private Integer maxCUSecond;

    // Constructor
    public CourseSummaryDTO(String courseId, String departmentName, String courseName, String level,
                            Long totalStudents, Long gstFirstCount, Long gstFirstCredits, Long coreFirstCount,
                            Long coreFirstCredits, Long electiveFirstCount, Integer minCUFirst, Integer maxCUFirst,
                            Long gstSecondCount, Long gstSecondCredits, Long coreSecondCount, Long coreSecondCredits,
                            Long electiveSecondCount, Integer minCUSecond, Integer maxCUSecond) {
        this.courseId = courseId;
        this.departmentName = departmentName;
        this.courseName = courseName;
        this.level = level;
        this.totalStudents = totalStudents;
        this.gstFirstCount = gstFirstCount;
        this.gstFirstCredits = gstFirstCredits;
        this.coreFirstCount = coreFirstCount;
        this.coreFirstCredits = coreFirstCredits;
        this.electiveFirstCount = electiveFirstCount;
        this.minCUFirst = minCUFirst;
        this.maxCUFirst = maxCUFirst;
        this.gstSecondCount = gstSecondCount;
        this.gstSecondCredits = gstSecondCredits;
        this.coreSecondCount = coreSecondCount;
        this.coreSecondCredits = coreSecondCredits;
        this.electiveSecondCount = electiveSecondCount;
        this.minCUSecond = minCUSecond;
        this.maxCUSecond = maxCUSecond;
    }

    // Getters and Setters
    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Long getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(Long totalStudents) {
        this.totalStudents = totalStudents;
    }

    public Long getGstFirstCount() {
        return gstFirstCount;
    }

    public void setGstFirstCount(Long gstFirstCount) {
        this.gstFirstCount = gstFirstCount;
    }

    public Long getGstFirstCredits() {
        return gstFirstCredits;
    }

    public void setGstFirstCredits(Long gstFirstCredits) {
        this.gstFirstCredits = gstFirstCredits;
    }

    public Long getCoreFirstCount() {
        return coreFirstCount;
    }

    public void setCoreFirstCount(Long coreFirstCount) {
        this.coreFirstCount = coreFirstCount;
    }

    public Long getCoreFirstCredits() {
        return coreFirstCredits;
    }

    public void setCoreFirstCredits(Long coreFirstCredits) {
        this.coreFirstCredits = coreFirstCredits;
    }

    public Long getElectiveFirstCount() {
        return electiveFirstCount;
    }

    public void setElectiveFirstCount(Long electiveFirstCount) {
        this.electiveFirstCount = electiveFirstCount;
    }

    public Integer getMinCUFirst() {
        return minCUFirst;
    }

    public void setMinCUFirst(Integer minCUFirst) {
        this.minCUFirst = minCUFirst;
    }

    public Integer getMaxCUFirst() {
        return maxCUFirst;
    }

    public void setMaxCUFirst(Integer maxCUFirst) {
        this.maxCUFirst = maxCUFirst;
    }

    public Long getGstSecondCount() {
        return gstSecondCount;
    }

    public void setGstSecondCount(Long gstSecondCount) {
        this.gstSecondCount = gstSecondCount;
    }

    public Long getGstSecondCredits() {
        return gstSecondCredits;
    }

    public void setGstSecondCredits(Long gstSecondCredits) {
        this.gstSecondCredits = gstSecondCredits;
    }

    public Long getCoreSecondCount() {
        return coreSecondCount;
    }

    public void setCoreSecondCount(Long coreSecondCount) {
        this.coreSecondCount = coreSecondCount;
    }

    public Long getCoreSecondCredits() {
        return coreSecondCredits;
    }

    public void setCoreSecondCredits(Long coreSecondCredits) {
        this.coreSecondCredits = coreSecondCredits;
    }

    public Long getElectiveSecondCount() {
        return electiveSecondCount;
    }

    public void setElectiveSecondCount(Long electiveSecondCount) {
        this.electiveSecondCount = electiveSecondCount;
    }

    public Integer getMinCUSecond() {
        return minCUSecond;
    }

    public void setMinCUSecond(Integer minCUSecond) {
        this.minCUSecond = minCUSecond;
    }

    public Integer getMaxCUSecond() {
        return maxCUSecond;
    }

    public void setMaxCUSecond(Integer maxCUSecond) {
        this.maxCUSecond = maxCUSecond;
    }
}
