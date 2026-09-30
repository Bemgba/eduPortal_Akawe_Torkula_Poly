/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "alevelresult")
@NamedQueries({
    @NamedQuery(name = "Alevelresult.findAll", query = "SELECT a FROM Alevelresult a"),
    @NamedQuery(name = "Alevelresult.findById", query = "SELECT a FROM Alevelresult a WHERE a.id = :id"),
    @NamedQuery(name = "Alevelresult.findByStudentId", query = "SELECT a FROM Alevelresult a WHERE a.studentId = :studentId"),
    @NamedQuery(name = "Alevelresult.findByRegistrationNo", query = "SELECT a FROM Alevelresult a WHERE a.registrationNo = :registrationNo"),
    @NamedQuery(name = "Alevelresult.findBySchoolName", query = "SELECT a FROM Alevelresult a WHERE a.schoolName = :schoolName"),
    @NamedQuery(name = "Alevelresult.findByResultDate", query = "SELECT a FROM Alevelresult a WHERE a.resultDate = :resultDate"),
    @NamedQuery(name = "Alevelresult.findByGrade", query = "SELECT a FROM Alevelresult a WHERE a.grade = :grade"),
    @NamedQuery(name = "Alevelresult.findByPoints", query = "SELECT a FROM Alevelresult a WHERE a.points = :points"),
    @NamedQuery(name = "Alevelresult.findByCourse", query = "SELECT a FROM Alevelresult a WHERE a.course = :course"),
    @NamedQuery(name = "Alevelresult.findByDateAdded", query = "SELECT a FROM Alevelresult a WHERE a.dateAdded = :dateAdded"),
    @NamedQuery(name = "Alevelresult.findByDateVerified", query = "SELECT a FROM Alevelresult a WHERE a.dateVerified = :dateVerified"),
    @NamedQuery(name = "Alevelresult.findByVerificationComment", query = "SELECT a FROM Alevelresult a WHERE a.verificationComment = :verificationComment")})
public class Alevelresult implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "student_id")
    private String studentId;
    @Size(max = 50)
    @Column(name = "registration_no")
    private String registrationNo;
    @Size(max = 200)
    @Column(name = "school_name")
    private String schoolName;
    @Size(max = 20)
    @Column(name = "result_date")
    private String resultDate;
    @Size(max = 50)
    @Column(name = "grade")
    private String grade;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "points")
    private Double points;
    @Size(max = 200)
    @Column(name = "course")
    private String course;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Column(name = "date_verified")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateVerified;
    @Size(max = 200)
    @Column(name = "verification_comment")
    private String verificationComment;

    public Alevelresult() {
    }

    public Alevelresult(String id) {
        this.id = id;
    }

    public Alevelresult(String id, String studentId) {
        this.id = id;
        this.studentId = studentId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public String getSchoolName() {
        return schoolName;
    }

    public void setSchoolName(String schoolName) {
        this.schoolName = schoolName;
    }

    public String getResultDate() {
        return resultDate;
    }

    public void setResultDate(String resultDate) {
        this.resultDate = resultDate;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public Double getPoints() {
        return points;
    }

    public void setPoints(Double points) {
        this.points = points;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Date getDateVerified() {
        return dateVerified;
    }

    public void setDateVerified(Date dateVerified) {
        this.dateVerified = dateVerified;
    }

    public String getVerificationComment() {
        return verificationComment;
    }

    public void setVerificationComment(String verificationComment) {
        this.verificationComment = verificationComment;
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
        if (!(object instanceof Alevelresult)) {
            return false;
        }
        Alevelresult other = (Alevelresult) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Alevelresult[ id=" + id + " ]";
    }
    
}
