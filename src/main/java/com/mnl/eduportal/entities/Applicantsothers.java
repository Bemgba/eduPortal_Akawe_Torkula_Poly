/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
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
@Table(name = "applicantsothers")
@NamedQueries({
    @NamedQuery(name = "Applicantsothers.findAll", query = "SELECT a FROM Applicantsothers a"),
    @NamedQuery(name = "Applicantsothers.findById", query = "SELECT a FROM Applicantsothers a WHERE a.id = :id"),
    @NamedQuery(name = "Applicantsothers.findByApplicationType", query = "SELECT a FROM Applicantsothers a WHERE a.applicationType = :applicationType"),
    @NamedQuery(name = "Applicantsothers.findByCurrentlyTraining", query = "SELECT a FROM Applicantsothers a WHERE a.currentlyTraining = :currentlyTraining"),
    @NamedQuery(name = "Applicantsothers.findByDeclaration", query = "SELECT a FROM Applicantsothers a WHERE a.declaration = :declaration"),
    @NamedQuery(name = "Applicantsothers.findByEmploymentStatus", query = "SELECT a FROM Applicantsothers a WHERE a.employmentStatus = :employmentStatus"),
    @NamedQuery(name = "Applicantsothers.findByFieldOfStudy", query = "SELECT a FROM Applicantsothers a WHERE a.fieldOfStudy = :fieldOfStudy"),
    @NamedQuery(name = "Applicantsothers.findByResearchExperience", query = "SELECT a FROM Applicantsothers a WHERE a.researchExperience = :researchExperience"),
    @NamedQuery(name = "Applicantsothers.findByTranscriptStatus", query = "SELECT a FROM Applicantsothers a WHERE a.transcriptStatus = :transcriptStatus"),
    @NamedQuery(name = "Applicantsothers.findByDateTranscripted", query = "SELECT a FROM Applicantsothers a WHERE a.dateTranscripted = :dateTranscripted"),
    @NamedQuery(name = "Applicantsothers.findByTranscriptUrl", query = "SELECT a FROM Applicantsothers a WHERE a.transcriptUrl = :transcriptUrl")})
public class Applicantsothers implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 50)
    @Column(name = "application_type")
    private String applicationType;
    @Size(max = 50)
    @Column(name = "currently_training")
    private String currentlyTraining;
    @Size(max = 200)
    @Column(name = "declaration")
    private String declaration;
    @Size(max = 50)
    @Column(name = "employment_status")
    private String employmentStatus;
    @Size(max = 50)
    @Column(name = "field_of_study")
    private String fieldOfStudy;
    @Size(max = 2147483647)
    @Column(name = "research_experience")
    private String researchExperience;
    @Size(max = 50)
    @Column(name = "transcript_status")
    private String transcriptStatus;
    @Column(name = "date_transcripted")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateTranscripted;
    @Size(max = 50)
    @Column(name = "transcript_url")
    private String transcriptUrl;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Applicants applicants;

    public Applicantsothers() {
    }

    public Applicantsothers(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getApplicationType() {
        return applicationType;
    }

    public void setApplicationType(String applicationType) {
        this.applicationType = applicationType;
    }

    public String getCurrentlyTraining() {
        return currentlyTraining;
    }

    public void setCurrentlyTraining(String currentlyTraining) {
        this.currentlyTraining = currentlyTraining;
    }

    public String getDeclaration() {
        return declaration;
    }

    public void setDeclaration(String declaration) {
        this.declaration = declaration;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public String getFieldOfStudy() {
        return fieldOfStudy;
    }

    public void setFieldOfStudy(String fieldOfStudy) {
        this.fieldOfStudy = fieldOfStudy;
    }

    public String getResearchExperience() {
        return researchExperience;
    }

    public void setResearchExperience(String researchExperience) {
        this.researchExperience = researchExperience;
    }

    public String getTranscriptStatus() {
        return transcriptStatus;
    }

    public void setTranscriptStatus(String transcriptStatus) {
        this.transcriptStatus = transcriptStatus;
    }

    public Date getDateTranscripted() {
        return dateTranscripted;
    }

    public void setDateTranscripted(Date dateTranscripted) {
        this.dateTranscripted = dateTranscripted;
    }

    public String getTranscriptUrl() {
        return transcriptUrl;
    }

    public void setTranscriptUrl(String transcriptUrl) {
        this.transcriptUrl = transcriptUrl;
    }

    public Applicants getApplicants() {
        return applicants;
    }

    public void setApplicants(Applicants applicants) {
        this.applicants = applicants;
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
        if (!(object instanceof Applicantsothers)) {
            return false;
        }
        Applicantsothers other = (Applicantsothers) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.bsutest.Applicantsothers[ id=" + id + " ]";
    }
    
}
