/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "users")
@NamedQueries({
    @NamedQuery(name = "Users.findAll", query = "SELECT u FROM Users u"),
    @NamedQuery(name = "Users.findById", query = "SELECT u FROM Users u WHERE u.id = :id"),
    @NamedQuery(name = "Users.findByUsername", query = "SELECT u FROM Users u WHERE u.username = :username"),
    @NamedQuery(name = "Users.findByPassword", query = "SELECT u FROM Users u WHERE u.password = :password"),
    @NamedQuery(name = "Users.findByEmail", query = "SELECT u FROM Users u WHERE u.email = :email"),
    @NamedQuery(name = "Users.findByDatelastlogin", query = "SELECT u FROM Users u WHERE u.datelastlogin = :datelastlogin"),
    @NamedQuery(name = "Users.findByIplastlogin", query = "SELECT u FROM Users u WHERE u.iplastlogin = :iplastlogin"),
    @NamedQuery(name = "Users.findByDevicelastlogin", query = "SELECT u FROM Users u WHERE u.devicelastlogin = :devicelastlogin"),
    @NamedQuery(name = "Users.findByVerificationToken", query = "SELECT u FROM Users u WHERE u.verificationToken = :verificationToken"),
    @NamedQuery(name = "Users.findUnverifiedUsers", query = "SELECT u FROM Users u WHERE u.emailVerifiedAt IS NULL"),
    @NamedQuery(name = "Users.findByStatus", query = "SELECT u FROM Users u WHERE u.status = :status")})
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "username")
    private String username;
    @Size(max = 200)
    @Column(name = "password")
    private String password;
    //@Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Size(max = 100)
    @Column(name = "email")
    private String email;
    @Column(name = "datelastlogin")
    @Temporal(TemporalType.TIMESTAMP)
    private Date datelastlogin;
    @Size(max = 50)
    @Column(name = "iplastlogin")
    private String iplastlogin;
    @Size(max = 200)
    @Column(name = "devicelastlogin")
    private String devicelastlogin;
    @Size(max = 50)
    @Column(name = "status")
    private String status;
    
    // Email Verification Fields
    @Column(name = "email_verified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date emailVerifiedAt;
    
    @Column(name = "verification_token", unique = true)
    @Size(max = 255)
    private String verificationToken;
    
    @Column(name = "verification_token_expiration")
    @Temporal(TemporalType.TIMESTAMP)
    private Date verificationTokenExpiration;
    
    @Column(name = "last_verification_sent_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastVerificationSentAt;
    
    // Security and Audit Fields
    @Column(name = "failed_login_attempts")
    private Integer failedLoginAttempts = 0;
    
    @Column(name = "last_login_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLoginAt;
    
    @Column(name = "locked_until")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lockedUntil;
    
    @Column(name = "remember_token")
    @Size(max = 255)
    private String rememberToken;
    
    // Audit Fields
    @Column(name = "created_at", updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    
    @Column(name = "created_by")
    @Size(max = 50)
    private String createdBy;
    
    @Column(name = "updated_by")
    @Size(max = 50)
    private String updatedBy;
    
    // Soft Delete Fields
    @Column(name = "deleted", nullable = false)
    private Boolean deleted = false;
    
    @Column(name = "deleted_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deletedAt;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "users")
    private Applicantsbiodata applicantsbiodata;
    @OneToMany(mappedBy = "userId")
    private Collection<Userfaculties> userfacultiesCollection;
    @OneToMany(mappedBy = "headId")
    private Collection<Courses> coursesCollection;
    @JoinColumn(name = "default_role", referencedColumnName = "id")
    @ManyToOne
    private Roles defaultRole;
    @OneToMany(mappedBy = "headId")
    private Collection<Schools> schoolsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "addedBy")
    private Collection<Feessetup> feessetupCollection;
    @OneToMany(mappedBy = "userId")
    private Collection<Userschools> userschoolsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "addedBy")
    private Collection<Students> studentsCollection;
    @OneToMany(mappedBy = "headId")
    private Collection<Units> unitsCollection;
    @OneToOne(mappedBy = "headId")
    private FacultiesDirectorates facultiesDirectorates;
    @OneToMany(mappedBy = "headId")
    private Collection<Departments> departmentsCollection;
    @OneToMany(mappedBy = "userId")
    private Collection<Userunits> userunitsCollection;
    @OneToMany(mappedBy = "headId")
    private Collection<Schoolprogrammes> schoolprogrammesCollection;
    @OneToMany(mappedBy = "userId")
    private Collection<Userlogins> userloginsCollection;
    @OneToMany(mappedBy = "userId")
    private Collection<Userprogrammes> userprogrammesCollection;

    public Users() {
    }

    public Users(String id) {
        this.id = id;
    }

    public Users(String id, String username) {
        this.id = id;
        this.username = username;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
     public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Email Verification Getters and Setters
    public Date getEmailVerifiedAt() {
        return emailVerifiedAt;
    }

    public void setEmailVerifiedAt(Date emailVerifiedAt) {
        this.emailVerifiedAt = emailVerifiedAt;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public Date getVerificationTokenExpiration() {
        return verificationTokenExpiration;
    }

    public void setVerificationTokenExpiration(Date verificationTokenExpiration) {
        this.verificationTokenExpiration = verificationTokenExpiration;
    }

    public Date getLastVerificationSentAt() {
        return lastVerificationSentAt;
    }

    public void setLastVerificationSentAt(Date lastVerificationSentAt) {
        this.lastVerificationSentAt = lastVerificationSentAt;
    }

    // Security and Audit Getters and Setters
    public Integer getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(Integer failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }

    public Date getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(Date lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public Date getLockedUntil() {
        return lockedUntil;
    }

    public void setLockedUntil(Date lockedUntil) {
        this.lockedUntil = lockedUntil;
    }

    public String getRememberToken() {
        return rememberToken;
    }

    public void setRememberToken(String rememberToken) {
        this.rememberToken = rememberToken;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public Date getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }

    // Utility Methods for Email Verification
    public boolean isEmailVerified() {
        return emailVerifiedAt != null;
    }

    public boolean isVerificationTokenExpired() {
        return verificationTokenExpiration != null && 
               verificationTokenExpiration.before(new Date());
    }

    public boolean isAccountLocked() {
        return lockedUntil != null && lockedUntil.after(new Date());
    }

    public boolean isDeleted() {
        return deleted != null && deleted;
    }

    public Date getDatelastlogin() {
        return datelastlogin;
    }

    public void setDatelastlogin(Date datelastlogin) {
        this.datelastlogin = datelastlogin;
    }

    public String getIplastlogin() {
        return iplastlogin;
    }

    public void setIplastlogin(String iplastlogin) {
        this.iplastlogin = iplastlogin;
    }

    public String getDevicelastlogin() {
        return devicelastlogin;
    }

    public void setDevicelastlogin(String devicelastlogin) {
        this.devicelastlogin = devicelastlogin;
    }

    public Collection<Userfaculties> getUserfacultiesCollection() {
        return userfacultiesCollection;
    }

    public void setUserfacultiesCollection(Collection<Userfaculties> userfacultiesCollection) {
        this.userfacultiesCollection = userfacultiesCollection;
    }

    public Collection<Courses> getCoursesCollection() {
        return coursesCollection;
    }

    public void setCoursesCollection(Collection<Courses> coursesCollection) {
        this.coursesCollection = coursesCollection;
    }

    public Roles getDefaultRole() {
        return defaultRole;
    }

    public void setDefaultRole(Roles defaultRole) {
        this.defaultRole = defaultRole;
    }

    public Collection<Schools> getSchoolsCollection() {
        return schoolsCollection;
    }

    public void setSchoolsCollection(Collection<Schools> schoolsCollection) {
        this.schoolsCollection = schoolsCollection;
    }

    public Collection<Feessetup> getFeessetupCollection() {
        return feessetupCollection;
    }

    public void setFeessetupCollection(Collection<Feessetup> feessetupCollection) {
        this.feessetupCollection = feessetupCollection;
    }

    public Collection<Userschools> getUserschoolsCollection() {
        return userschoolsCollection;
    }

    public void setUserschoolsCollection(Collection<Userschools> userschoolsCollection) {
        this.userschoolsCollection = userschoolsCollection;
    }

    public Collection<Students> getStudentsCollection() {
        return studentsCollection;
    }

    public void setStudentsCollection(Collection<Students> studentsCollection) {
        this.studentsCollection = studentsCollection;
    }

    public Collection<Units> getUnitsCollection() {
        return unitsCollection;
    }

    public void setUnitsCollection(Collection<Units> unitsCollection) {
        this.unitsCollection = unitsCollection;
    }

    public FacultiesDirectorates getFacultiesDirectorates() {
        return facultiesDirectorates;
    }

    public void setFacultiesDirectorates(FacultiesDirectorates facultiesDirectorates) {
        this.facultiesDirectorates = facultiesDirectorates;
    }

    public Collection<Departments> getDepartmentsCollection() {
        return departmentsCollection;
    }

    public void setDepartmentsCollection(Collection<Departments> departmentsCollection) {
        this.departmentsCollection = departmentsCollection;
    }

    public Collection<Userunits> getUserunitsCollection() {
        return userunitsCollection;
    }

    public void setUserunitsCollection(Collection<Userunits> userunitsCollection) {
        this.userunitsCollection = userunitsCollection;
    }

    public Collection<Schoolprogrammes> getSchoolprogrammesCollection() {
        return schoolprogrammesCollection;
    }

    public void setSchoolprogrammesCollection(Collection<Schoolprogrammes> schoolprogrammesCollection) {
        this.schoolprogrammesCollection = schoolprogrammesCollection;
    }

    public Collection<Userlogins> getUserloginsCollection() {
        return userloginsCollection;
    }

    public void setUserloginsCollection(Collection<Userlogins> userloginsCollection) {
        this.userloginsCollection = userloginsCollection;
    }

    public Collection<Userprogrammes> getUserprogrammesCollection() {
        return userprogrammesCollection;
    }

    public void setUserprogrammesCollection(Collection<Userprogrammes> userprogrammesCollection) {
        this.userprogrammesCollection = userprogrammesCollection;
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
        if (!(object instanceof Users)) {
            return false;
        }
        Users other = (Users) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Users[ id=" + id + " ]";
    }

    /**
     * @return the applicantsbiodata
     */
    public Applicantsbiodata getApplicantsbiodata() {
        return applicantsbiodata;
    }

    /**
     * @param applicantsbiodata the applicantsbiodata to set
     */
    public void setApplicantsbiodata(Applicantsbiodata applicantsbiodata) {
        this.applicantsbiodata = applicantsbiodata;
    }
    
}
