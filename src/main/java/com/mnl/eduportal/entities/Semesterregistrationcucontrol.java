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
@Table(name = "semesterregistrationcucontrol")
@NamedQueries({
    @NamedQuery(name = "Semesterregistrationcucontrol.findAll", query = "SELECT s FROM Semesterregistrationcucontrol s"),
    @NamedQuery(name = "Semesterregistrationcucontrol.findById", query = "SELECT s FROM Semesterregistrationcucontrol s WHERE s.id = :id"),
    @NamedQuery(name = "Semesterregistrationcucontrol.findByLevel", query = "SELECT s FROM Semesterregistrationcucontrol s WHERE s.level = :level"),
    @NamedQuery(name = "Semesterregistrationcucontrol.findBySemester", query = "SELECT s FROM Semesterregistrationcucontrol s WHERE s.semester = :semester"),
    @NamedQuery(name = "Semesterregistrationcucontrol.findByMincu", query = "SELECT s FROM Semesterregistrationcucontrol s WHERE s.mincu = :mincu"),
    @NamedQuery(name = "Semesterregistrationcucontrol.findByMaxcu", query = "SELECT s FROM Semesterregistrationcucontrol s WHERE s.maxcu = :maxcu")})
public class Semesterregistrationcucontrol implements Serializable {

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
    @Column(name = "level")
    private String level;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "semester")
    private String semester;
    @Column(name = "mincu")
    private Integer mincu;
    @Column(name = "maxcu")
    private Integer maxcu;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseId;

    public Semesterregistrationcucontrol() {
    }

    public Semesterregistrationcucontrol(String id) {
        this.id = id;
    }

    public Semesterregistrationcucontrol(String id, String level, String semester) {
        this.id = id;
        this.level = level;
        this.semester = semester;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public Integer getMincu() {
        return mincu;
    }

    public void setMincu(Integer mincu) {
        this.mincu = mincu;
    }

    public Integer getMaxcu() {
        return maxcu;
    }

    public void setMaxcu(Integer maxcu) {
        this.maxcu = maxcu;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
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
        if (!(object instanceof Semesterregistrationcucontrol)) {
            return false;
        }
        Semesterregistrationcucontrol other = (Semesterregistrationcucontrol) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.test.resources.Semesterregistrationcucontrol[ id=" + id + " ]";
    }
    
}
