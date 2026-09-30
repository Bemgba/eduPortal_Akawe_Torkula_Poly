package com.mnl.eduportal.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 * Entity for password reset tokens
 * Separate table to handle password reset functionality
 * 
 * @author eduportal
 */
@Entity
@Table(name = "password_reset_tokens")
@NamedQueries({
    @NamedQuery(name = "PasswordResetToken.findByToken", 
                query = "SELECT p FROM PasswordResetToken p WHERE p.token = :token"),
    @NamedQuery(name = "PasswordResetToken.findByUserId", 
                query = "SELECT p FROM PasswordResetToken p WHERE p.userId = :userId"),
    @NamedQuery(name = "PasswordResetToken.deleteExpired", 
                query = "DELETE FROM PasswordResetToken p WHERE p.expiryTime < :currentTime")
})
public class PasswordResetToken implements Serializable {

    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "user_id")
    private String userId;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "token")
    private String token;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "expiry_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date expiryTime;
    
    @Column(name = "created_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdTime;
    
    @Column(name = "used")
    private Boolean used = false;

    public PasswordResetToken() {
    }

    public PasswordResetToken(String userId, String token, Date expiryTime) {
        this.userId = userId;
        this.token = token;
        this.expiryTime = expiryTime;
        this.createdTime = new Date();
        this.used = false;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Date expiryTime) {
        this.expiryTime = expiryTime;
    }

    public Date getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }

    public Boolean getUsed() {
        return used;
    }

    public void setUsed(Boolean used) {
        this.used = used;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof PasswordResetToken)) {
            return false;
        }
        PasswordResetToken other = (PasswordResetToken) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "PasswordResetToken[ id=" + id + " ]";
    }
}