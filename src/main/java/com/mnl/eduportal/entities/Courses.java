/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "courses")
@NamedQueries({
    @NamedQuery(name = "Courses.findAll", query = "SELECT c FROM Courses c"),
    @NamedQuery(name = "Courses.findById", query = "SELECT c FROM Courses c WHERE c.id = :id"),
    @NamedQuery(name = "Courses.findByName", query = "SELECT c FROM Courses c WHERE c.name = :name"),
    @NamedQuery(name = "Courses.findByCode", query = "SELECT c FROM Courses c WHERE c.code = :code"),
    @NamedQuery(name = "Courses.findByDefaultMinLevel", query = "SELECT c FROM Courses c WHERE c.defaultMinLevel = :defaultMinLevel"),
    @NamedQuery(name = "Courses.findByDefaultMaxLevel", query = "SELECT c FROM Courses c WHERE c.defaultMaxLevel = :defaultMaxLevel"),
    @NamedQuery(name = "Courses.findByDefaultMaxSpill", query = "SELECT c FROM Courses c WHERE c.defaultMaxSpill = :defaultMaxSpill"),
    @NamedQuery(name = "Courses.findByDefaultDuration", query = "SELECT c FROM Courses c WHERE c.defaultDuration = :defaultDuration"),
    @NamedQuery(name = "Courses.findByEntryRequirements", query = "SELECT c FROM Courses c WHERE c.entryRequirements = :entryRequirements")})
public class Courses implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "name")
    private String name;
    @Size(max = 20)
    @Column(name = "code")
    private String code;
    @Column(name = "default_min_level")
    private Integer defaultMinLevel;
    @Column(name = "default_max_level")
    private Integer defaultMaxLevel;
    @Column(name = "default_max_spill")
    private Integer defaultMaxSpill;
    @Column(name = "default_duration")
    private Integer defaultDuration;
    @Size(max = 2147483647)
    @Column(name = "entry_requirements")
    private String entryRequirements;

    @OneToMany(mappedBy = "course1", fetch = FetchType.LAZY)
    private Collection<Applicants> applicantsCollection;
    @OneToMany(mappedBy = "course2", fetch = FetchType.LAZY)
    private Collection<Applicants> applicantsCollection1;
    @OneToMany(mappedBy = "courseFrom", fetch = FetchType.LAZY)
    private Collection<Studentuniversitytransfer> studentuniversitytransferCollection;
    @OneToMany(mappedBy = "courseTo", fetch = FetchType.LAZY)
    private Collection<Studentuniversitytransfer> studentuniversitytransferCollection1;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseFrom", fetch = FetchType.LAZY)
    private Collection<Studentchangeofcourse> studentchangeofcourseCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseTo", fetch = FetchType.LAZY)
    private Collection<Studentchangeofcourse> studentchangeofcourseCollection1;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId", fetch = FetchType.LAZY)
    private Collection<Semesterregistrationcourses> semesterregistrationcoursesCollection;
    @JoinColumn(name = "head_title", referencedColumnName = "id")
    @ManyToOne
    private Positions headTitle;
    @JoinColumn(name = "department_id", referencedColumnName = "id")
    @ManyToOne
    private Departments departmentId;
    @JoinColumn(name = "school_programme_id", referencedColumnName = "id")
    @ManyToOne
    private Schoolprogrammes schoolProgrammeId;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @ManyToOne
    private Users headId;
    @OneToMany(mappedBy = "courseId")
    private Collection<Admissions> admissionsCollection;
    @OneToMany(mappedBy = "courseId", fetch = FetchType.LAZY)
    private Collection<Semesterregistration> semesterregistrationCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "course", fetch = FetchType.LAZY)
    private Collection<Utmeapplicants> utmeapplicantsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId")
    private Collection<Studentprogression> studentprogressionCollection;
    @OneToMany(mappedBy = "courseId")
    private Collection<Payments> paymentsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId")
    private Collection<Students> studentsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId", fetch = FetchType.LAZY)
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "courses")
    private Coursesjambmapping coursesjambmapping;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId", fetch = FetchType.LAZY)
    private Collection<Semesterregistrationcucontrol> semesterregistrationcucontrolCollection;

    public Courses() {
    }

    public Courses(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Integer getDefaultMinLevel() {
        return defaultMinLevel;
    }

    public void setDefaultMinLevel(Integer defaultMinLevel) {
        this.defaultMinLevel = defaultMinLevel;
    }

    public Integer getDefaultMaxLevel() {
        return defaultMaxLevel;
    }

    public void setDefaultMaxLevel(Integer defaultMaxLevel) {
        this.defaultMaxLevel = defaultMaxLevel;
    }

    public Integer getDefaultMaxSpill() {
        return defaultMaxSpill;
    }

    public void setDefaultMaxSpill(Integer defaultMaxSpill) {
        this.defaultMaxSpill = defaultMaxSpill;
    }

    public Integer getDefaultDuration() {
        return defaultDuration;
    }

    public void setDefaultDuration(Integer defaultDuration) {
        this.defaultDuration = defaultDuration;
    }

    public String getEntryRequirements() {
        return entryRequirements;
    }

    public void setEntryRequirements(String entryRequirements) {
        this.entryRequirements = entryRequirements;
    }

    public Collection<Applicants> getApplicantsCollection() {
        return applicantsCollection;
    }

    public void setApplicantsCollection(Collection<Applicants> applicantsCollection) {
        this.applicantsCollection = applicantsCollection;
    }

    public Collection<Applicants> getApplicantsCollection1() {
        return applicantsCollection1;
    }

    public void setApplicantsCollection1(Collection<Applicants> applicantsCollection1) {
        this.applicantsCollection1 = applicantsCollection1;
    }

    public Collection<Studentuniversitytransfer> getStudentuniversitytransferCollection() {
        return studentuniversitytransferCollection;
    }

    public void setStudentuniversitytransferCollection(Collection<Studentuniversitytransfer> studentuniversitytransferCollection) {
        this.studentuniversitytransferCollection = studentuniversitytransferCollection;
    }

    public Collection<Studentuniversitytransfer> getStudentuniversitytransferCollection1() {
        return studentuniversitytransferCollection1;
    }

    public void setStudentuniversitytransferCollection1(Collection<Studentuniversitytransfer> studentuniversitytransferCollection1) {
        this.studentuniversitytransferCollection1 = studentuniversitytransferCollection1;
    }

    public Collection<Studentchangeofcourse> getStudentchangeofcourseCollection() {
        return studentchangeofcourseCollection;
    }

    public void setStudentchangeofcourseCollection(Collection<Studentchangeofcourse> studentchangeofcourseCollection) {
        this.studentchangeofcourseCollection = studentchangeofcourseCollection;
    }

    public Collection<Studentchangeofcourse> getStudentchangeofcourseCollection1() {
        return studentchangeofcourseCollection1;
    }

    public void setStudentchangeofcourseCollection1(Collection<Studentchangeofcourse> studentchangeofcourseCollection1) {
        this.studentchangeofcourseCollection1 = studentchangeofcourseCollection1;
    }

    public Collection<Semesterregistrationcourses> getSemesterregistrationcoursesCollection() {
        return semesterregistrationcoursesCollection;
    }

    public void setSemesterregistrationcoursesCollection(Collection<Semesterregistrationcourses> semesterregistrationcoursesCollection) {
        this.semesterregistrationcoursesCollection = semesterregistrationcoursesCollection;
    }

    public Positions getHeadTitle() {
        return headTitle;
    }

    public void setHeadTitle(Positions headTitle) {
        this.headTitle = headTitle;
    }

    public Departments getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Departments departmentId) {
        this.departmentId = departmentId;
    }

    public Schoolprogrammes getSchoolProgrammeId() {
        return schoolProgrammeId;
    }

    
    public void setSchoolProgrammeId(Schoolprogrammes schoolProgrammeId) {
        this.schoolProgrammeId = schoolProgrammeId;
    }

     public Coursesjambmapping getCoursesjambmapping() {
        return coursesjambmapping;
    }

    public void setCoursesjambmapping(Coursesjambmapping coursesjambmapping) {
        this.coursesjambmapping = coursesjambmapping;
    }
    public Users getHeadId() {
        return headId;
    }

    public void setHeadId(Users headId) {
        this.headId = headId;
    }

    public Collection<Admissions> getAdmissionsCollection() {
        return admissionsCollection;
    }

    public void setAdmissionsCollection(Collection<Admissions> admissionsCollection) {
        this.admissionsCollection = admissionsCollection;
    }

    public Collection<Semesterregistration> getSemesterregistrationCollection() {
        return semesterregistrationCollection;
    }

    public void setSemesterregistrationCollection(Collection<Semesterregistration> semesterregistrationCollection) {
        this.semesterregistrationCollection = semesterregistrationCollection;
    }

    public Collection<Utmeapplicants> getUtmeapplicantsCollection() {
        return utmeapplicantsCollection;
    }

    public void setUtmeapplicantsCollection(Collection<Utmeapplicants> utmeapplicantsCollection) {
        this.utmeapplicantsCollection = utmeapplicantsCollection;
    }

    public Collection<Studentprogression> getStudentprogressionCollection() {
        return studentprogressionCollection;
    }

    public void setStudentprogressionCollection(Collection<Studentprogression> studentprogressionCollection) {
        this.studentprogressionCollection = studentprogressionCollection;
    }

    public Collection<Payments> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payments> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }

    public Collection<Students> getStudentsCollection() {
        return studentsCollection;
    }

    public void setStudentsCollection(Collection<Students> studentsCollection) {
        this.studentsCollection = studentsCollection;
    }

    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection() {
        return semesterregistrationsummaryCollection;
    }

    public void setSemesterregistrationsummaryCollection(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection) {
        this.semesterregistrationsummaryCollection = semesterregistrationsummaryCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Courses)) {
            return false;
        }
        Courses other = (Courses) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Courses[ id=" + id + " ]";
    }

    /**
     * @return the semesterregistrationcucontrolCollection
     */
    public Collection<Semesterregistrationcucontrol> getSemesterregistrationcucontrolCollection() {
        return semesterregistrationcucontrolCollection;
    }

    /**
     * @param semesterregistrationcucontrolCollection the semesterregistrationcucontrolCollection to set
     */
    public void setSemesterregistrationcucontrolCollection(Collection<Semesterregistrationcucontrol> semesterregistrationcucontrolCollection) {
        this.semesterregistrationcucontrolCollection = semesterregistrationcucontrolCollection;
    }

   

}
