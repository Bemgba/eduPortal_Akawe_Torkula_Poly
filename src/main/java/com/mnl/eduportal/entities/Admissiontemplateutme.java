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
@Table(name = "admissiontemplateutme")
@NamedQueries({
    @NamedQuery(name = "Admissiontemplateutme.findAll", query = "SELECT a FROM Admissiontemplateutme a"),
    @NamedQuery(name = "Admissiontemplateutme.findById", query = "SELECT a FROM Admissiontemplateutme a WHERE a.id = :id"),
    @NamedQuery(name = "Admissiontemplateutme.findByUtmeType", query = "SELECT a FROM Admissiontemplateutme a WHERE a.utmeType = :utmeType")})
public class Admissiontemplateutme implements Serializable {

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
    @Column(name = "utme_type")
    private String utmeType;
    @JoinColumn(name = "admission_template", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Admissiontemplate admissionTemplate;
    @JoinColumn(name = "utmesubjects", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Utmesubjects utmesubjects;

    public Admissiontemplateutme() {
    }

    public Admissiontemplateutme(String id) {
        this.id = id;
    }

    public Admissiontemplateutme(String id, String utmeType) {
        this.id = id;
        this.utmeType = utmeType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUtmeType() {
        return utmeType;
    }

    public void setUtmeType(String utmeType) {
        this.utmeType = utmeType;
    }

    public Admissiontemplate getAdmissionTemplate() {
        return admissionTemplate;
    }

    public void setAdmissionTemplate(Admissiontemplate admissionTemplate) {
        this.admissionTemplate = admissionTemplate;
    }

    public Utmesubjects getUtmesubjects() {
        return utmesubjects;
    }

    public void setUtmesubjects(Utmesubjects utmesubjects) {
        this.utmesubjects = utmesubjects;
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
        if (!(object instanceof Admissiontemplateutme)) {
            return false;
        }
        Admissiontemplateutme other = (Admissiontemplateutme) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.bdic.benueexco.admissiontemplate.resources.Admissiontemplateutme[ id=" + id + " ]";
    }
    
}
