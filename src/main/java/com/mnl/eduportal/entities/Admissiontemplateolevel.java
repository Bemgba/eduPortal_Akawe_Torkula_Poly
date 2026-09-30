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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "admissiontemplateolevel")
@NamedQueries({
    @NamedQuery(name = "Admissiontemplateolevel.findAll", query = "SELECT a FROM Admissiontemplateolevel a"),
    @NamedQuery(name = "Admissiontemplateolevel.findById", query = "SELECT a FROM Admissiontemplateolevel a WHERE a.id = :id"),
    @NamedQuery(name = "Admissiontemplateolevel.findByOlevelType", query = "SELECT a FROM Admissiontemplateolevel a WHERE a.olevelType = :olevelType")})
public class Admissiontemplateolevel implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 5)
    @Column(name = "olevel_type")
    private String olevelType;
    @JoinColumn(name = "admission_template", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Admissiontemplate admissionTemplate;
    @JoinColumn(name = "olevel_subject", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Olevelsubjects olevelSubject;

    public Admissiontemplateolevel() {
    }

    public Admissiontemplateolevel(String id) {
        this.id = id;
    }

    public Admissiontemplateolevel(String id, String olevelType) {
        this.id = id;
        this.olevelType = olevelType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOlevelType() {
        return olevelType;
    }

    public void setOlevelType(String olevelType) {
        this.olevelType = olevelType;
    }

    public Admissiontemplate getAdmissionTemplate() {
        return admissionTemplate;
    }

    public void setAdmissionTemplate(Admissiontemplate admissionTemplate) {
        this.admissionTemplate = admissionTemplate;
    }

    public Olevelsubjects getOlevelSubject() {
        return olevelSubject;
    }

    public void setOlevelSubject(Olevelsubjects olevelSubject) {
        this.olevelSubject = olevelSubject;
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
        if (!(object instanceof Admissiontemplateolevel)) {
            return false;
        }
        Admissiontemplateolevel other = (Admissiontemplateolevel) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.bdic.benueexco.admissiontemplate.Admissiontemplateolevel[ id=" + id + " ]";
    }
    
}
