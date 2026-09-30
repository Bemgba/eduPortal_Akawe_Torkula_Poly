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
@Table(name = "gradelevelsteps")
@NamedQueries({
    @NamedQuery(name = "Gradelevelsteps.findAll", query = "SELECT g FROM Gradelevelsteps g"),
    @NamedQuery(name = "Gradelevelsteps.findById", query = "SELECT g FROM Gradelevelsteps g WHERE g.id = :id"),
    @NamedQuery(name = "Gradelevelsteps.findByGradeLevel", query = "SELECT g FROM Gradelevelsteps g WHERE g.gradeLevel = :gradeLevel"),
    @NamedQuery(name = "Gradelevelsteps.findByMaxStep", query = "SELECT g FROM Gradelevelsteps g WHERE g.maxStep = :maxStep"),
    @NamedQuery(name = "Gradelevelsteps.findByOrderValue", query = "SELECT g FROM Gradelevelsteps g WHERE g.orderValue = :orderValue")})
public class Gradelevelsteps implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 50)
    @Column(name = "grade_level")
    private String gradeLevel;
    @Column(name = "max_step")
    private Integer maxStep;
    @Column(name = "order_value")
    private Integer orderValue;
    @JoinColumn(name = "salary_scale_id", referencedColumnName = "id")
    @ManyToOne
    private Salaryscale salaryScaleId;

    public Gradelevelsteps() {
    }

    public Gradelevelsteps(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGradeLevel() {
        return gradeLevel;
    }

    public void setGradeLevel(String gradeLevel) {
        this.gradeLevel = gradeLevel;
    }

    public Integer getMaxStep() {
        return maxStep;
    }

    public void setMaxStep(Integer maxStep) {
        this.maxStep = maxStep;
    }

    public Integer getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(Integer orderValue) {
        this.orderValue = orderValue;
    }

    public Salaryscale getSalaryScaleId() {
        return salaryScaleId;
    }

    public void setSalaryScaleId(Salaryscale salaryScaleId) {
        this.salaryScaleId = salaryScaleId;
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
        if (!(object instanceof Gradelevelsteps)) {
            return false;
        }
        Gradelevelsteps other = (Gradelevelsteps) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Gradelevelsteps[ id=" + id + " ]";
    }
    
}
