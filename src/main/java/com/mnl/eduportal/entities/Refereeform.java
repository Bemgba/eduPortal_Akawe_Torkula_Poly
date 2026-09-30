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
@Table(name = "refereeform")
@NamedQueries({
    @NamedQuery(name = "Refereeform.findAll", query = "SELECT r FROM Refereeform r"),
    @NamedQuery(name = "Refereeform.findById", query = "SELECT r FROM Refereeform r WHERE r.id = :id"),
    @NamedQuery(name = "Refereeform.findByApplicantId", query = "SELECT r FROM Refereeform r WHERE r.applicantId = :applicantId"),
    @NamedQuery(name = "Refereeform.findByRefEmail", query = "SELECT r FROM Refereeform r WHERE r.refEmail = :refEmail"),
    @NamedQuery(name = "Refereeform.findByRefPhonoNo", query = "SELECT r FROM Refereeform r WHERE r.refPhonoNo = :refPhonoNo"),
    @NamedQuery(name = "Refereeform.findByRefFullname", query = "SELECT r FROM Refereeform r WHERE r.refFullname = :refFullname"),
    @NamedQuery(name = "Refereeform.findByRefRank", query = "SELECT r FROM Refereeform r WHERE r.refRank = :refRank"),
    @NamedQuery(name = "Refereeform.findByRefOrganization", query = "SELECT r FROM Refereeform r WHERE r.refOrganization = :refOrganization"),
    @NamedQuery(name = "Refereeform.findByRefDepartment", query = "SELECT r FROM Refereeform r WHERE r.refDepartment = :refDepartment"),
    @NamedQuery(name = "Refereeform.findByIntellectualCapacity", query = "SELECT r FROM Refereeform r WHERE r.intellectualCapacity = :intellectualCapacity"),
    @NamedQuery(name = "Refereeform.findByCapacityForPersistence", query = "SELECT r FROM Refereeform r WHERE r.capacityForPersistence = :capacityForPersistence"),
    @NamedQuery(name = "Refereeform.findByImaginativeThought", query = "SELECT r FROM Refereeform r WHERE r.imaginativeThought = :imaginativeThought"),
    @NamedQuery(name = "Refereeform.findByProductivesCholarship", query = "SELECT r FROM Refereeform r WHERE r.productivesCholarship = :productivesCholarship"),
    @NamedQuery(name = "Refereeform.findByPreviousWork", query = "SELECT r FROM Refereeform r WHERE r.previousWork = :previousWork"),
    @NamedQuery(name = "Refereeform.findByOralAndWrittenExp", query = "SELECT r FROM Refereeform r WHERE r.oralAndWrittenExp = :oralAndWrittenExp"),
    @NamedQuery(name = "Refereeform.findByPersonalityComment", query = "SELECT r FROM Refereeform r WHERE r.personalityComment = :personalityComment"),
    @NamedQuery(name = "Refereeform.findByAcceptCandidate", query = "SELECT r FROM Refereeform r WHERE r.acceptCandidate = :acceptCandidate"),
    @NamedQuery(name = "Refereeform.findByOverallPromise", query = "SELECT r FROM Refereeform r WHERE r.overallPromise = :overallPromise"),
    @NamedQuery(name = "Refereeform.findByAnyInformation", query = "SELECT r FROM Refereeform r WHERE r.anyInformation = :anyInformation"),
    @NamedQuery(name = "Refereeform.findByObjectionComment", query = "SELECT r FROM Refereeform r WHERE r.objectionComment = :objectionComment"),
    @NamedQuery(name = "Refereeform.findByDateProvided", query = "SELECT r FROM Refereeform r WHERE r.dateProvided = :dateProvided"),
    @NamedQuery(name = "Refereeform.findByDateSubmitted", query = "SELECT r FROM Refereeform r WHERE r.dateSubmitted = :dateSubmitted")})
public class Refereeform implements Serializable {

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
    @Column(name = "applicant_id")
    private String applicantId;
    @Size(max = 100)
    @Column(name = "ref_email")
    private String refEmail;
    @Size(max = 13)
    @Column(name = "ref_phono_no")
    private String refPhonoNo;
    @Size(max = 150)
    @Column(name = "ref_fullname")
    private String refFullname;
    @Size(max = 150)
    @Column(name = "ref_rank")
    private String refRank;
    @Size(max = 200)
    @Column(name = "ref_organization")
    private String refOrganization;
    @Size(max = 100)
    @Column(name = "ref_department")
    private String refDepartment;
    @Column(name = "intellectual_capacity")
    private Integer intellectualCapacity;
    @Column(name = "capacity_for_persistence")
    private Integer capacityForPersistence;
    @Column(name = "imaginative_thought")
    private Integer imaginativeThought;
    @Column(name = "productives_cholarship")
    private Integer productivesCholarship;
    @Column(name = "previous_work")
    private Integer previousWork;
    @Column(name = "oral_and_written_exp")
    private Integer oralAndWrittenExp;
    @Column(name = "personality_comment")
    private Integer personalityComment;
    @Size(max = 100)
    @Column(name = "accept_candidate")
    private String acceptCandidate;
    @Size(max = 200)
    @Column(name = "overall_promise")
    private String overallPromise;
    @Size(max = 200)
    @Column(name = "any_information")
    private String anyInformation;
    @Size(max = 200)
    @Column(name = "objection_comment")
    private String objectionComment;
    @Column(name = "date_provided")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateProvided;
    @Column(name = "date_submitted")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateSubmitted;

    public Refereeform() {
    }

    public Refereeform(String id) {
        this.id = id;
    }

    public Refereeform(String id, String applicantId) {
        this.id = id;
        this.applicantId = applicantId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(String applicantId) {
        this.applicantId = applicantId;
    }

    public String getRefEmail() {
        return refEmail;
    }

    public void setRefEmail(String refEmail) {
        this.refEmail = refEmail;
    }

    public String getRefPhonoNo() {
        return refPhonoNo;
    }

    public void setRefPhonoNo(String refPhonoNo) {
        this.refPhonoNo = refPhonoNo;
    }

    public String getRefFullname() {
        return refFullname;
    }

    public void setRefFullname(String refFullname) {
        this.refFullname = refFullname;
    }

    public String getRefRank() {
        return refRank;
    }

    public void setRefRank(String refRank) {
        this.refRank = refRank;
    }

    public String getRefOrganization() {
        return refOrganization;
    }

    public void setRefOrganization(String refOrganization) {
        this.refOrganization = refOrganization;
    }

    public String getRefDepartment() {
        return refDepartment;
    }

    public void setRefDepartment(String refDepartment) {
        this.refDepartment = refDepartment;
    }

    public Integer getIntellectualCapacity() {
        return intellectualCapacity;
    }

    public void setIntellectualCapacity(Integer intellectualCapacity) {
        this.intellectualCapacity = intellectualCapacity;
    }

    public Integer getCapacityForPersistence() {
        return capacityForPersistence;
    }

    public void setCapacityForPersistence(Integer capacityForPersistence) {
        this.capacityForPersistence = capacityForPersistence;
    }

    public Integer getImaginativeThought() {
        return imaginativeThought;
    }

    public void setImaginativeThought(Integer imaginativeThought) {
        this.imaginativeThought = imaginativeThought;
    }

    public Integer getProductivesCholarship() {
        return productivesCholarship;
    }

    public void setProductivesCholarship(Integer productivesCholarship) {
        this.productivesCholarship = productivesCholarship;
    }

    public Integer getPreviousWork() {
        return previousWork;
    }

    public void setPreviousWork(Integer previousWork) {
        this.previousWork = previousWork;
    }

    public Integer getOralAndWrittenExp() {
        return oralAndWrittenExp;
    }

    public void setOralAndWrittenExp(Integer oralAndWrittenExp) {
        this.oralAndWrittenExp = oralAndWrittenExp;
    }

    public Integer getPersonalityComment() {
        return personalityComment;
    }

    public void setPersonalityComment(Integer personalityComment) {
        this.personalityComment = personalityComment;
    }

    public String getAcceptCandidate() {
        return acceptCandidate;
    }

    public void setAcceptCandidate(String acceptCandidate) {
        this.acceptCandidate = acceptCandidate;
    }

    public String getOverallPromise() {
        return overallPromise;
    }

    public void setOverallPromise(String overallPromise) {
        this.overallPromise = overallPromise;
    }

    public String getAnyInformation() {
        return anyInformation;
    }

    public void setAnyInformation(String anyInformation) {
        this.anyInformation = anyInformation;
    }

    public String getObjectionComment() {
        return objectionComment;
    }

    public void setObjectionComment(String objectionComment) {
        this.objectionComment = objectionComment;
    }

    public Date getDateProvided() {
        return dateProvided;
    }

    public void setDateProvided(Date dateProvided) {
        this.dateProvided = dateProvided;
    }

    public Date getDateSubmitted() {
        return dateSubmitted;
    }

    public void setDateSubmitted(Date dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
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
        if (!(object instanceof Refereeform)) {
            return false;
        }
        Refereeform other = (Refereeform) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Refereeform[ id=" + id + " ]";
    }
    
}
