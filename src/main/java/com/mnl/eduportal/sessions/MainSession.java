/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.sessions;

/**
 *
 * @author eaglescan
 */
import com.google.gson.Gson;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEvent;
import com.itextpdf.text.pdf.PdfWriter;
import com.mnl.eduportal.entities.Admissions;
import com.mnl.eduportal.entities.Admissiontemplate;
import com.mnl.eduportal.entities.Admissiontemplateolevel;
import com.mnl.eduportal.entities.Admissiontemplateutme;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsbiodata;
import com.mnl.eduportal.entities.Applicantsothers;
import com.mnl.eduportal.entities.Applicantsreferees;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Banks;
import com.mnl.eduportal.entities.Countries;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Coursesjambmapping;
import com.mnl.eduportal.entities.Deferments;
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.entities.FacultiesDirectorates;
import com.mnl.eduportal.entities.Feesgroup;
import com.mnl.eduportal.entities.Feesitems;
import com.mnl.eduportal.entities.Feessetup;
import com.mnl.eduportal.entities.Feeswaiver;
import com.mnl.eduportal.entities.Hostelallocation;
import com.mnl.eduportal.entities.Hostelapplication;
import com.mnl.eduportal.entities.Hostelrooms;
import com.mnl.eduportal.entities.Hostels;
import com.mnl.eduportal.entities.Lgas;
import com.mnl.eduportal.entities.Menus;
import com.mnl.eduportal.entities.News;
import com.mnl.eduportal.entities.Olevelgrades;
import com.mnl.eduportal.entities.Olevelresults;
import com.mnl.eduportal.entities.Olevelresultsitems;
import com.mnl.eduportal.entities.Olevelsubjects;
import com.mnl.eduportal.entities.Pages;
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.entities.Paymentnotification;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Positions;
import com.mnl.eduportal.entities.Programmes;
import com.mnl.eduportal.entities.Roles;
import com.mnl.eduportal.entities.Schoolprogrammes;
import com.mnl.eduportal.entities.Schools;
import com.mnl.eduportal.entities.Schoolsattended;
import com.mnl.eduportal.entities.Semestercourses;
import com.mnl.eduportal.entities.Semesterregistration;
import com.mnl.eduportal.entities.Semesterregistrationcourses;
import com.mnl.eduportal.entities.Semesterregistrationcucontrol;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.Staff;
import com.mnl.eduportal.entities.States;
import com.mnl.eduportal.entities.Studentprogression;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.entities.Summerschoolapplication;
import com.mnl.eduportal.entities.Summerschoolregistration;
import com.mnl.eduportal.entities.Summerschoolstatus;
import com.mnl.eduportal.entities.Units;
import com.mnl.eduportal.entities.Uploadeddocuments;
import com.mnl.eduportal.entities.Userfaculties;
import com.mnl.eduportal.entities.Userlogins;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.entities.Utmesubjects;
import com.mnl.eduportal.util.AdmTempData;
import com.mnl.eduportal.util.AdmTempData2;
import com.mnl.eduportal.util.AdmTempOLDet;
import com.mnl.eduportal.util.AdmTempUTMEDet;
import com.mnl.eduportal.util.ConvertNumberToWord;
import com.mnl.eduportal.util.CourseSummaryDTO;
import com.mnl.eduportal.util.FooterPageEvent;
import com.mnl.eduportal.util.InterswitchUtil;
import com.mnl.eduportal.util.MailClient;
import com.mnl.eduportal.util.PaymentDetails;
import com.mnl.eduportal.util.PaymentNotification;
import com.mnl.eduportal.util.PaymentSummaryDTO;
import com.mnl.eduportal.util.PaymentreferenceDetail;
import com.mnl.eduportal.util.QRCodeManagement;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.StudentStats;
import com.mnl.eduportal.util.UsersDTO;
import com.mnl.eduportal.util.WatermarkPageEvent;
import jakarta.annotation.Resource;
import jakarta.ejb.LocalBean;
import jakarta.ejb.SessionContext;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.OptimisticLockException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceException;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
//import javax.persistence.NoResultException;

@Stateless
@LocalBean
public class MainSession {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    @Resource
    private SessionContext sessionContext;

    Settings settings = new Settings();

    private static final ConcurrentHashMap<String, ProgressionProgress> progressionTracking = new ConcurrentHashMap<>();

    // Inner class for tracking progression progress
    public static class ProgressionProgress {
        public int totalStudents;
        public int processedStudents;
        public int failedStudents;
        public int totalBatches;
        public int currentBatch;
        public boolean completed;
        
        public ProgressionProgress() {
            this.totalStudents = 0;
            this.processedStudents = 0;
            this.failedStudents = 0;
            this.totalBatches = 0;
            this.currentBatch = 0;
            this.completed = false;
        }
    }

    public ProgressionProgress getProgressionProgress(String sessionId) {
        return progressionTracking.get(sessionId);
    }

    public void clearProgressionProgress(String sessionId) {
        progressionTracking.remove(sessionId);
    }

    @Transactional
    public void newEntry(Object obj) {
        try {
            this.em.persist(obj);
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void createCourseMapping(String courseId, String jambName, String schoolProgrammeId) {
        try {
            Coursesjambmapping existing = getCoursesjambmapping(jambName);
            if (existing == null) {
                Coursesjambmapping mapping = new Coursesjambmapping();
                mapping.setId(courseId);
                mapping.setJamdName(jambName.toLowerCase());
                Schoolprogrammes sp = getSchoolprogrammes(schoolProgrammeId);
                if (sp != null) {
                    mapping.setSchoolProgrammesId(sp);
                    this.em.persist(mapping);
                    System.out.println("Created course mapping: " + jambName + " -> " + courseId);
                } else {
                    System.out.println("School programme not found: " + schoolProgrammeId);
                }
            }
        } catch (Exception e) {
            System.out.println("Error creating course mapping: " + e.getMessage());
        }
    }

    public Schoolprogrammes getSchoolprogrammes(String id) {
        try {
            return (Schoolprogrammes) this.em.find(Schoolprogrammes.class, id);
        } catch (Exception e) {
            System.out.println("Error getting school programme: " + e.getMessage());
            return null;
        }
    }

    @Transactional
    public String createApplicantWithUser(Applicants applicant, Users user) {
        try {
            Applicants existingApp = getApplicantsById(applicant.getId());
            Users existingUser = getUsers(user.getId());
            Applicantsutme existingUtme = getApplicantsutme(applicant.getId());
            if (existingApp != null || existingUser != null || existingUtme != null) {
                String existingTypes = "";
                if (existingApp != null) {
                    existingTypes = existingTypes + "applicant ";
                }
                if (existingUser != null) {
                    existingTypes = existingTypes + "user ";
                }
                if (existingUtme != null) {
                    existingTypes = existingTypes + "UTME ";
                }
                return "Record already exists - cannot create duplicate (" + existingTypes.trim() + "records found)";
            }
            if (applicant.getApplicantsutme() == null) {
                return "Error: UTME data is required but not provided";
            }
            System.out.println("Creating applicant with UTME data for ID: " + applicant.getId());
            System.out.println("UTME Total Score: " + applicant.getApplicantsutme().getTotalUtme());
            this.em.persist(applicant);
            this.em.persist(user);
            this.em.flush();
            System.out.println("Successfully created applicant, UTME data, and user records for ID: " + applicant
                    .getId());
            return "Success";
        } catch (Exception e) {
            System.out.println("Transaction failed for ID " + applicant.getId() + ": " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Applicantsutme getApplicantsutme(String id) {
        try {
            return (Applicantsutme) this.em.find(Applicantsutme.class, id);
        } catch (Exception e) {
            return null;
        }
    }

    @Transactional
    public String createStaffWithUser(Staff staff, Users user) {
        try {
            Staff existingStaff = getStaff(staff.getId());
            Users existingUser = getUsers(user.getId());
            if (existingStaff != null || existingUser != null) {
                String existingTypes = "";
                if (existingStaff != null) {
                    existingTypes = existingTypes + "staff ";
                }
                if (existingUser != null) {
                    existingTypes = existingTypes + "user ";
                }
                return "Record already exists - cannot create duplicate (" + existingTypes.trim() + "records found)";
            }
            System.out.println("Creating staff and user records for Staff No: " + staff.getStaffNo());
            this.em.persist(user);
            this.em.persist(staff);
            this.em.flush();
            System.out.println("Successfully created staff and user records for Staff No: " + staff.getStaffNo());
            return "Success";
        } catch (Exception e) {
            System.out.println("Transaction failed for Staff No " + staff.getStaffNo() + ": " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Staff getStaff(String id) {
        try {
            return (Staff) this.em.find(Staff.class, id);
        } catch (Exception e) {
            return null;
        }
    }

    public Staff getStaffByStaffNo(String staffNo) {
        try {
            List<Staff> results = this.em.createQuery("SELECT s FROM Staff s WHERE s.staffNo = :staffNo", Staff.class).setParameter("staffNo", staffNo).getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            return null;
        }
    }

    @Transactional
    public void initializeCommonCourseMappings() {
        try {
            createCourseMapping("C00023", "computer science", "10001");
            createCourseMapping("C00061", "medicine", "10013");
            createCourseMapping("C00061", "medicine and surgery", "10013");
            createCourseMapping("C00061", "mbbs", "10013");
            createCourseMapping("C00029", "physics", "10001");
            createCourseMapping("C64548", "biochemistry", "10013");
            createCourseMapping("C18115", "human physiology", "10013");
            createCourseMapping("C35147", "nursing science", "10013");
            createCourseMapping("C00019", "accounting", "10001");
            createCourseMapping("C00024", "economics", "10001");
            createCourseMapping("C00021", "business administration", "10001");
            createCourseMapping("C00021", "business management", "10001");
            createCourseMapping("C00032", "sociology", "10001");
            createCourseMapping("C00031", "psychology", "10001");
            createCourseMapping("C00025", "geography", "10001");
            createCourseMapping("C00033", "law", "10001");
            createCourseMapping("C94958", "mass communication", "10001");
            System.out.println("Common course mappings initialized");
        } catch (Exception e) {
            System.out.println("Error initializing course mappings: " + e.getMessage());
        }
    }

    @Transactional
    public long countOlevelSubjectsByUser(String userId) {
        return ((Long) this.em.createQuery("SELECT COUNT(i) FROM Olevelresultsitems i WHERE i.olevelResultsId.userId = :userId", Long.class)
                .setParameter("userId", userId)
                .getSingleResult()).longValue();
    }

    public long countUtmeSubjectsByApplicant(String applicantId) {
        return ((Long) this.em.createQuery("SELECT COUNT(u) FROM Applicantsutme u WHERE u.applicantId.id = :applicantId", Long.class)
                .setParameter("applicantId", applicantId)
                .getSingleResult()).longValue();
    }

    @Transactional
    public void changeApplicantStatus(String appno, String status) {
        try {
            Applicants ss = (Applicants) this.em.find(Applicants.class, appno);
            if (ss != null) {
                ss.setStatus(status);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void addUpdateAdmission(Admissions adm) {
        try {
            Admissions ss = (Admissions) this.em.find(Admissions.class, adm.getId());
            if (ss != null) {
                this.em.merge(adm);
            } else {
                this.em.persist(adm);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error adding or updating admission", e);
        }
    }

    @Transactional
    public void newSummerschoolapplication(Summerschoolapplication obj) {
        try {
            Summerschoolapplication ss = (Summerschoolapplication) this.em.find(Summerschoolapplication.class, obj.getId());
            if (ss != null) {
                this.em.merge(obj);
            } else {
                this.em.persist(obj);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void newSessionmanager(Sessionmanager obj) {
        try {
            this.em.persist(obj);
        } catch (Exception e) {
            throw new RuntimeException("Error creating new session manager", e);
        }
    }

    @Transactional
    public void newOlevelItem(Olevelresultsitems obj) {
        try {
            this.em.persist(obj);
        } catch (Exception e) {
            throw new RuntimeException("Error saving new OlevelItem", e);
        }
    }

    @Transactional
    public void newUsers(Users obj) {
        try {
            this.em.persist(obj);
        } catch (Exception e) {
            throw new RuntimeException("Error saving new User", e);
        }
    }

    @Transactional
    public void newStudentprogression(Studentprogression sp) {
        try {
            Studentprogression ss = (Studentprogression) this.em.find(Studentprogression.class, sp.getId());
            if (ss != null) {
                this.em.merge(sp);
            } else {
                this.em.persist(sp);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void newStudent(Students sp) {
        try {
            this.em.persist(sp);
        } catch (Exception e) {
            throw new RuntimeException("Error saving new Student", e);
        }
    }

    @Transactional
    public void updatePassword(String id, String newpw1) {
        try {
            Users pass = (Users) this.em.find(Users.class, id);
            if (pass != null) {
                pass.setPassword(newpw1);
                this.em.merge(pass);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void savePassport(String id, String url) {
        try {
            Passports pass = getPassports(id);
            if (pass != null) {
                pass.setDateAdded(this.settings.getCurrentDateTime());
                pass.setUrl(url);
                this.em.merge(pass);
            } else {
                pass = new Passports(id);
                pass.setDateAdded(this.settings.getCurrentDateTime());
                pass.setUrl(url);
                this.em.persist(pass);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateAdmissiontemplate(Admissiontemplate obj) {
        try {
            this.em.createQuery("UPDATE Admissiontemplate p SET p.aptitudePer = :a, p.compulsorySubjects = :b, p.compulsoryUtme = :c, p.lgaMerit = :d, p.nationalMerit = :e, p.olevelPer = :f, p.otherSubjects = :g, p.otherUtme = :h, p.stateMerit = :i, p.totalMerit = :j, p.utmePer = :k WHERE p.id = :id")
                    .setParameter("a", obj.getAptitudePer())
                    .setParameter("b", obj.getCompulsorySubjects())
                    .setParameter("c", obj.getCompulsoryUtme())
                    .setParameter("d", obj.getLgaMerit())
                    .setParameter("e", obj.getNationalMerit())
                    .setParameter("f", obj.getOlevelPer())
                    .setParameter("g", obj.getOtherSubjects())
                    .setParameter("h", obj.getOtherUtme())
                    .setParameter("i", obj.getStateMerit())
                    .setParameter("j", obj.getTotalMerit())
                    .setParameter("k", obj.getUtmePer())
                    .setParameter("id", obj.getId())
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Admissiontemplate", e);
        }
    }

    @Transactional
    public void deleteObject(Object obj) {
        try {
            this.em.remove(obj);
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updatePaymentreference(String id, String responseText, String payRef, String bank, String bankName, Date datePaid, String status) {
        try {
            this.em.createQuery("UPDATE Paymentreference p SET p.responseText = :responseText, p.paymentRef = :payref, p.bankCode = :bankcode, p.bankName = :bankname, p.datePaid = :datePaid, p.paidStatus = :status WHERE p.id = :id")
                    .setParameter("responseText", responseText)
                    .setParameter("payref", payRef)
                    .setParameter("bankcode", bank)
                    .setParameter("bankname", bankName)
                    .setParameter("datePaid", datePaid)
                    .setParameter("status", status)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating payment reference", e);
        }
    }

    @Transactional
    public void deleteObject(String obj, String id) {
        try {
            this.em.createQuery("DELETE FROM " + obj + " p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void deleteAdmissiontemplateolevel(String id) {
        try {
            this.em.createQuery("DELETE FROM Admissiontemplateolevel p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Admissiontemplateolevel", e);
        }
    }

    @Transactional
    public void deleteStudent(String id) {
        try {
            this.em.createQuery("DELETE FROM Students p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Student", e);
        }
    }

    @Transactional
    public void deleteSemesterregistration(String id) {
        try {
            this.em.createQuery("DELETE FROM Semesterregistration p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Semesterregistration", e);
        }
    }

    @Transactional
    public void deleteSemestercourses(String id) {
        try {
            this.em.createQuery("DELETE FROM Semestercourses p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Semestercourses", e);
        }
    }

    @Transactional
    public void deleteFeessetup(String id) {
        try {
            this.em.createQuery("DELETE FROM Feessetup p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting fee setup", e);
        }
    }

    @Transactional
    public void deleteStudentprogression(String id) {
        try {
            String sql = "DELETE FROM studentprogression WHERE id = ?";
            int i = this.em.createNativeQuery(sql).setParameter(1, id).executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting student progression", e);
        }
    }

    @Transactional
    public void deleteAdmissiontemplateutme(String id) {
        try {
            this.em.createQuery("DELETE FROM Admissiontemplateutme p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting admission template UTME", e);
        }
    }

    @Transactional
    public void updateUserRole(String userId, int roleId) {
        Roles role = (Roles) this.em.find(Roles.class, Integer.valueOf(roleId));
        Users user = (Users) this.em.find(Users.class, userId);
        if (user != null && role != null) {
            user.setDefaultRole(role);
        }
    }

    @Transactional
    public void updateUserStatus(String userId, String status) {
        try {
            Users us = (Users) this.em.find(Users.class, userId);
            if (us != null) {
                us.setStatus(status);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void completeApplicantStatus(String id) {
        try {
            Applicants genapp = (Applicants) this.em.find(Applicants.class, id);
            if (genapp != null) {
                genapp.setStatus("SUBMITTED");
                genapp.setDateCompleted(this.settings.getCurrentDateTime());
                genapp.getApplicantsothers().setDeclaration("DECLARED");
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void resetApplicationStatus(String id) {
        try {
            Applicants genapp = (Applicants) this.em.find(Applicants.class, id);
            if (genapp != null) {
                genapp.setStatus("NOT SUBMITTED");
                genapp.setDateCompleted(null);
                genapp.getApplicantsothers().setDeclaration(null);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void checkAndUpdateApplicationStatus(String applicantId) {
        try {
            Applicants app = (Applicants) this.em.find(Applicants.class, applicantId);
            if (app != null) {
                boolean hasAllData = true;
                if (app.getSurname() == null || app.getSurname().trim().isEmpty() || app
                        .getOthernames() == null || app.getOthernames().trim().isEmpty() || app
                        .getDateOfBirth() == null || app.getEmailAddress() == null) {
                    hasAllData = false;
                }
                Applicantsutme utme = getApplicantsutme(applicantId);
                if (utme == null || utme.getEngScore() == null || utme
                        .getSubj2() == null || utme.getSubj3() == null || utme.getSubj4() == null) {
                    hasAllData = false;
                }
                List<Schoolsattended> institutions = getSchoolsattendedByRegno(applicantId);
                if (institutions == null || institutions.isEmpty()) {
                    hasAllData = false;
                }
                List<Uploadeddocuments> documents = getUploadeddocumentsByRegno(applicantId);
                if (documents == null || documents.isEmpty()) {
                    hasAllData = false;
                }
                boolean hasPayment = false;
                try {
                    List<Payments> payments = getPaymentsByRegno(applicantId);
                    hasPayment = (payments != null && payments.size() > 0);
                } catch (Exception e) {
                    hasPayment = false;
                }
                if (hasAllData && hasPayment) {
                    app.setStatus("SUBMITTED");
                    app.setDateCompleted(this.settings.getCurrentDateTime());
                    if (app.getApplicantsothers() != null) {
                        app.getApplicantsothers().setDeclaration("DECLARED");
                    }
                } else {
                    app.setStatus("NOT SUBMITTED");
                    app.setDateCompleted(null);
                    if (app.getApplicantsothers() != null) {
                        app.getApplicantsothers().setDeclaration(null);
                    }
                }
            }
        } catch (Exception k) {
            System.out.println("Error updating application status: " + k.getMessage());
        }
    }

    @Transactional
    public void updateApplicantsothers(String id, String apptype, String training, String empstatus, String fieldstudy, String research) {
        try {
            Applicantsothers app = (Applicantsothers) this.em.find(Applicantsothers.class, id);
            if (app != null) {
                app.setApplicationType("POST GRADUATE");
                app.setCurrentlyTraining(training);
                app.setEmploymentStatus(empstatus);
                app.setFieldOfStudy(fieldstudy);
                app.setResearchExperience(research);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateApplicantsUtmescore(String id, int score) {
        try {
            Applicantsutme app = (Applicantsutme) this.em.find(Applicantsutme.class, id);
            if (app != null) {
                app.setPostUtme(Integer.valueOf(score));
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void saveOrUpdateApplicantsUtmescore(String id, int score) {
        try {
            Applicantsutme app = (Applicantsutme) this.em.find(Applicantsutme.class, id);
            if (app != null) {
                app.setPostUtme(Integer.valueOf(score));
            } else {
                Applicantsutme newApp = new Applicantsutme();
                newApp.setId(id);
                newApp.setPostUtme(Integer.valueOf(score));
                this.em.persist(newApp);
            }
        } catch (Exception h) {
            h.printStackTrace();
        }
    }

    @Transactional
    public void updateSummerschoolapplicationStatus(String id, String status) {
        try {
            Summerschoolapplication app = (Summerschoolapplication) this.em.find(Summerschoolapplication.class, id);
            if (app != null) {
                app.setApplicationStatus(status);
                if (status.equals("REGISTERED")) {
                    app.setDateRegistered(this.settings.getCurrentDateTime());
                    app.setRegistrationStatus("REGISTERED");
                }
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateUserEmail(String id, String email) {
        try {
            Users app = (Users) this.em.find(Users.class, id);
            if (app != null) {
                app.setEmail(email);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public int updateUserEmailDirect(String id, String email) {
        try {
            return this.em.createQuery("UPDATE Users u SET u.email = :email WHERE u.id = :id")
                    .setParameter("email", email)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            System.out.println("Error updating user email directly: " + e.getMessage());
            throw e;
        }
    }

    @Transactional
    public void addRoleToPage(String id, int role) {
        try {
            Pages app = (Pages) this.em.find(Pages.class, id);
            if (app != null) {
                if (app.getRoles().endsWith(";")) {
                    app.setRoles(app.getRoles() + app.getRoles());
                } else {
                    app.setRoles(app.getRoles() + ";" + app.getRoles());
                }
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void removeRoleFromPage(String id, String role) {
        try {
            Pages app = (Pages) this.em.find(Pages.class, id);
            if (app != null) {
                String newroles = app.getRoles().replace(role, "");
                try {
                    newroles = newroles.replaceAll(";;", ";");
                } catch (Exception exception) {
                }
                app.setRoles(newroles);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void removeFeessetup(String id) {
        try {
            String sql = "DELETE FROM feessetup WHERE id = ?";
            int i = this.em.createNativeQuery(sql).setParameter(1, id).executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error removing fee setup", e);
        }
    }

    @Transactional
    public void updateStudents(String id, String email) {
        try {
            Students app = (Students) this.em.find(Students.class, id);
            if (app != null) {
                if (email.contains(this.settings.institutionDomain)) {
                    app.setUniversityEmail(email);
                } else {
                    app.setPersonalEmail(email);
                }
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void editStudents(String id, String surname, String othernames, String pemail, String uemail, String phoneno, States sta, Lgas lga) {
        try {
            Students app = (Students) this.em.find(Students.class, id);
            if (app != null) {
                if (uemail.contains(this.settings.institutionDomain)) {
                    app.setUniversityEmail(uemail);
                }
                app.setSurname(surname);
                app.setOthernames(othernames);
                app.setPersonalEmail(pemail);
                app.setLga(lga);
                app.setPhoneNo(phoneno);
                app.setStateOfOrigin(sta);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateApplicantEmail(String id, String email) {
        try {
            Applicants app = (Applicants) this.em.find(Applicants.class, id);
            if (app != null) {
                app.setEmailAddress(email);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateStaffEmail(String id, String email) {
        Staff staff = (Staff) this.em.find(Staff.class, id);
        if (staff != null) {
            if (email.contains(this.settings.institutionDomain)) {
                staff.setOfficialEmailAddress(email);
            } else {
                staff.setPersonalEmailAddress(email);
            }
        }
    }

    @Transactional
    public void updateApplicants(String id, String guardianname, String guardianadd, String sponsorphone, String quali, String maritalstatus) {
        try {
            Applicants app = (Applicants) this.em.find(Applicants.class, id);
            if (app != null) {
                app.setGuardianName(guardianname);
                app.setGuardianAddress(guardianadd);
                app.setSponsorPhone(sponsorphone);
                app.setQualification(quali);
                app.setMaritalStatus(maritalstatus);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateApplicant(Applicantsbiodata ap) {
        try {
            Applicantsbiodata apb = (Applicantsbiodata) this.em.find(Applicantsbiodata.class, ap.getId());
            if (apb != null) {
                System.out.println("DEBUG: Updating existing biodata for user: " + ap.getId());
                apb.setSurname(ap.getSurname());
                apb.setOthernames(ap.getOthernames());
                apb.setContactAddress(ap.getContactAddress());
                apb.setDateAdded(this.settings.getCurrentDateTime());
                apb.setDateOfBirth(ap.getDateOfBirth());
                apb.setGender(ap.getGender());
                apb.setHomeTown(ap.getHomeTown());
                apb.setLga(ap.getLga());
                apb.setState(ap.getState());
                apb.setNationality(ap.getNationality());
                apb.setPhoneno(ap.getPhoneno());
            } else {
                System.out.println("DEBUG: Creating new biodata for user: " + ap.getId());
                this.em.persist(ap);
            }
        } catch (Exception h) {
            System.out.println("DEBUG: Error in updateApplicant: " + h.getMessage());
            h.printStackTrace();
            throw h;
        }
    }

    @Transactional
    public void updatePUTME(String id, String email, String phoneno) {
        try {
            Applicants app = getApplicants(id);
            String text = "UPDATE Applicants p SET p.emailAddress = :email, p.phoneNo = :phoneno WHERE p.id = :id";
            if (app.getStatus().equalsIgnoreCase("PENDING") || app.getStatus().equalsIgnoreCase("PAID")) {
                text = "UPDATE Applicants p SET p.emailAddress = :email, p.phoneNo = :phoneno, p.status='REGISTERED' WHERE p.id = :id";
            }
            this.em.createQuery(text)
                    .setParameter("email", email)
                    .setParameter("phoneno", phoneno)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating PUTME details", e);
        }
    }

    @Transactional
    public int updateApplicantContactIfEmpty(String id, String email, String phoneno) {
        try {
            return this.em.createQuery("UPDATE Applicants p SET p.emailAddress = CASE WHEN (p.emailAddress IS NULL OR p.emailAddress = '') THEN :email ELSE p.emailAddress END, p.phoneNo = CASE WHEN (p.phoneNo IS NULL OR p.phoneNo = '') THEN :phoneno ELSE p.phoneNo END WHERE p.id = :id")
                    .setParameter("email", email)
                    .setParameter("phoneno", phoneno)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            System.out.println("Error updating applicant contact info: " + e.getMessage());
            throw e;
        }
    }

    @Transactional
    public void updateRecord(Object obj) {
        try {
            Object object = this.em.merge(obj);
        } catch (OptimisticLockException optimisticLockException) {
        }
    }

    public Object getSingleObject(Class<?> ent, Object pk) {
        Object obj = null;
        try {
            obj = this.em.find(ent, pk);
        } catch (Exception exception) {
        }
        return obj;
    }

    @Transactional
    public Feessetup getFeessetup(String id) {
        Feessetup fs = null;
        try {
            fs = (Feessetup) this.em.find(Feessetup.class, id);
        } catch (Exception exception) {
        }
        return fs;
    }

    @Transactional
    public void updateUser(Users usr) {
        try {
            this.em.createQuery("UPDATE Users p SET p.datelastlogin = :sdate, p.devicelastlogin = :device, p.iplastlogin = :iplogin WHERE p.id = :id")
                    .setParameter("sdate", usr.getDatelastlogin())
                    .setParameter("device", usr.getDevicelastlogin())
                    .setParameter("iplogin", usr.getIplastlogin())
                    .setParameter("id", usr.getId())
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating user", e);
        }
    }

    public Users login(String username, String password, String ipAddress, String agent) {
        Users user = null;
        System.out.println("=== LOGIN ATTEMPT START ===");
        System.out.println("Username/Email entered: " + username);
        System.out.println("Password length: " + ((password != null) ? password.length() : 0));
        System.out.println("IP Address: " + ipAddress);
        try {
            System.out.println("Executing database query...");
            Users tmp = (Users) this.em.createQuery("SELECT u FROM Users u WHERE u.username = :username OR u.email = :email").setParameter("email", username).setParameter("username", username).setMaxResults(1).getSingleResult();
            System.out.println("Query executed successfully");
            if (tmp != null) {
                System.out.println("User found in database");
                System.out.println("  - User ID: " + tmp.getId());
                System.out.println("  - Username: " + tmp.getUsername());
                System.out.println("  - Email: " + tmp.getEmail());
                System.out.println("  - Stored password length: " + ((tmp.getPassword() != null) ? tmp.getPassword().length() : 0));
                System.out.println("  - Default Role: "
                        + String.valueOf((tmp.getDefaultRole() != null) ? tmp.getDefaultRole().getId() : "NULL"));
                System.out.println("Comparing passwords...");
                boolean exactMatch = tmp.getPassword().equals(password);
                boolean caseInsensitiveMatch = tmp.getPassword().equalsIgnoreCase(password);
                boolean passwordMatches = (exactMatch || caseInsensitiveMatch);
                System.out.println("  - Exact match (case-sensitive): " + exactMatch);
                System.out.println("  - Case-insensitive match: " + caseInsensitiveMatch);
                System.out.println("  - Password matches: " + passwordMatches);
                if (passwordMatches) {
                    System.out.println("Password validation successful");
                    user = tmp;
                    if (user.getDefaultRole() != null) {
                        System.out.println("Loading user role...");
                        user.getDefaultRole().getName();
                        System.out.println("  - Role name: " + user.getDefaultRole().getName());
                        if (user.getDefaultRole().getDefaulthome() != null) {
                            user.getDefaultRole().getDefaulthome().getAlias();
                            System.out
                                    .println("  - Default home: " + user.getDefaultRole().getDefaulthome().getAlias());
                        } else {
                            System.out.println("  - WARNING: Role has no default home page!");
                        }
                    } else {
                        System.out.println("  - WARNING: User has no default role!");
                    }
                    System.out.println("Creating login audit log...");
                    Userlogins log = new Userlogins(tmp.getId() + tmp.getId() + this.settings.getTodaysdate(), this.settings.getCurrentDateTime(), ipAddress, agent, tmp);
                    newEntry(log);
                    System.out.println("Updating user last login info...");
                    user.setDatelastlogin(this.settings.getCurrentDateTime());
                    user.setDevicelastlogin(agent);
                    user.setIplastlogin(ipAddress);
                    updateUser(user);
                    System.out.println("Login successful for user: " + username);
                } else {
                    System.out.println("Password validation FAILED");
                    System.out.println("  - Entered password: [HIDDEN for security]");
                    System.out.println("  - Stored password: [HIDDEN for security]");
                    System.out.println("  - Hint: Check if password case matches");
                }
            } else {
                System.out.println("User NOT found in database");
                System.out.println("  - Searched for username: " + username);
                System.out.println("  - Searched for email: " + username);
            }
        } catch (NoResultException nre) {
            System.out.println("No user found with username/email: " + username);
            System.out.println("  - This means the user doesn't exist in the database");
        } catch (Exception j) {
            System.out.println("Login error for: " + username);
            System.out.println("  - Error type: " + j.getClass().getName());
            System.out.println("  - Error message: " + j.getMessage());
            j.printStackTrace();
        }
        System.out.println("=== LOGIN ATTEMPT END ===");
        System.out.println("Result: " + ((user != null) ? "SUCCESS" : "FAILED"));
        System.out.println("");
        return user;
    }

    public List<States> getAllStatesInCountry(Integer country_id) {
        List<States> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM States AS s WHERE s.countryId.id = :countryId ORDER BY s.name ASC").setParameter("countryId", country_id).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Lgas> getAllLgasInStte(Integer state_id) {
        List<Lgas> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Lgas AS s WHERE s.stateId.id = :countryId ORDER BY s.name ASC").setParameter("countryId", state_id).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public boolean validateApplicantUser(String email) {
        try {
            Users user = getUsersByEmail(email);
            if (user == null) {
                System.out.println("VALIDATION: No user found for email: " + email);
                return false;
            }
            if (user.getDefaultRole() == null) {
                System.out.println("VALIDATION: User " + email + " has no default role");
                return false;
            }
            if (user.getDefaultRole().getDefaulthome() == null) {
                System.out.println("VALIDATION: User " + email + " role has no default home page");
                return false;
            }
            System.out.println("VALIDATION: User " + email + " is properly configured");
            System.out.println("  - Role: " + user.getDefaultRole().getName());
            System.out.println("  - Home: " + user.getDefaultRole().getDefaulthome().getAlias());
            return true;
        } catch (Exception e) {
            System.out.println("VALIDATION ERROR for " + email + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Users getUsersByEmail(String email) {
        Users user = null;
        try {
            List<Users> list = this.em.createQuery("SELECT s FROM Users s WHERE s.email = :email").setParameter("email", email).getResultList();
            if (!list.isEmpty()) {
                user = list.get(0);
                if (user.getDefaultRole() != null) {
                    user.getDefaultRole().getName();
                    if (user.getDefaultRole().getDefaulthome() != null) {
                        user.getDefaultRole().getDefaulthome().getAlias();
                    }
                }
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
        return user;
    }

    public Users getUsersByUsername(String username) {
        Users user = null;
        try {
            List<Users> list = this.em.createQuery("SELECT s FROM Users s WHERE s.username = :username").setParameter("username", username).getResultList();
            if (!list.isEmpty()) {
                user = list.get(0);
                if (user.getDefaultRole() != null) {
                    user.getDefaultRole().getName();
                    if (user.getDefaultRole().getDefaulthome() != null) {
                        user.getDefaultRole().getDefaulthome().getAlias();
                    }
                }
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
        return user;
    }

    public Users getUsers(String id) {
        Users user = null;
        try {
            user = (Users) this.em.createQuery("SELECT s FROM Users AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Countries getCountries(Integer id) {
        Countries user = null;
        try {
            user = (Countries) this.em.createQuery("SELECT s FROM Countries AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Roles getRoles(Integer id) {
        Roles role = null;
        try {
            role = (Roles) this.em.createQuery("SELECT s FROM Roles s WHERE s.id = :id").setParameter("id", id).getSingleResult();
            if (role != null && role.getDefaulthome() != null) {
                role.getDefaulthome().getAlias();
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
        return role;
    }

    public Countries getCountries(String name) {
        name = name.toLowerCase();
        Countries user = null;
        try {
            user = (Countries) this.em.createQuery("SELECT s FROM Countries AS s WHERE LOWER(s.name) = :name").setParameter("name", name).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Coursesjambmapping getCoursesjambmapping(String jambName) {
        jambName = jambName.toLowerCase();
        Coursesjambmapping user = null;
        try {
            user = (Coursesjambmapping) this.em.createQuery("SELECT s FROM Coursesjambmapping AS s WHERE LOWER(s.jamdName) = :name").setParameter("name", jambName).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public States getStates(Integer id) {
        States user = null;
        try {
            user = (States) this.em.createQuery("SELECT s FROM States AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public States getStates(String name, String country) {
        name = name.toLowerCase();
        country = country.toLowerCase();
        States user = null;
        try {
            user = (States) this.em.createQuery("SELECT s FROM States AS s WHERE LOWER(s.name) = :name AND LOWER(s.countryId.name) = :country").setParameter("name", name).setParameter("country", country).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Lgas getLgas(Integer id) {
        Lgas user = null;
        try {
            user = (Lgas) this.em.createQuery("SELECT s FROM Lgas AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Passports getPassports(String id) {
        Passports user = null;
        try {
            user = (Passports) this.em.createQuery("SELECT s FROM Passports AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public Lgas getLgas(String name, String state) {
        name = name.toLowerCase();
        state = state.toLowerCase();
        Lgas user = null;
        try {
            user = (Lgas) this.em.createQuery("SELECT s FROM Lgas AS s WHERE LOWER(s.name) = :name AND LOWER(s.stateId.name) = :state").setParameter("name", name).setParameter("state", state).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    public String getPagesString(String username) {
        String userPages = "";
        try {
            Users ul = getUsers(username);
            if (ul != null) {
                List<Pages> pages = getAllPagesforRole("" + ul.getDefaultRole().getId());
                for (Pages page : pages) {
                    if (!userPages.contains(page.getName())) {
                        // FIXED: Was "userPages + ";" + userPages" which doubled the string each time (OutOfMemoryError)
                        // Should append the page name, not duplicate the entire string
                        userPages = userPages + ";" + page.getName();
                    }
                }
            }
        } catch (Exception exception) {
        }
        return userPages;
    }

    public List<Pages> getAllPages() {
        return this.em.createQuery("SELECT p FROM Pages p ORDER BY p.description", Pages.class).getResultList();
    }

    public void addUserToPage(String pageid, String rolename) {
        try {
            Pages p = (Pages) this.em.find(Pages.class, pageid);
            if (!p.getId().contains(rolename)) {
                String newuser = p.getId() + ";" + p.getId();
                p.setRoles(newuser);
                updateRecord(p);
            }
        } catch (Exception exception) {
        }
    }

    public void removeAllUsersFromAllPages() {
        try {
            List<Pages> pa = this.em.createNamedQuery("Pages.findAll").getResultList();
            pa.stream().map(p -> {
                p.setId(";");
                return p;
            }).forEach(p -> updateRecord(p));
        } catch (Exception exception) {
        }
    }

    public List<Pages> getAllPagesforRole(String roleid) {
        List<Pages> pages = new ArrayList<>();
        roleid = "%" + roleid + "%";
        try {
            pages = this.em.createQuery("SELECT p FROM Pages p WHERE p.roles LIKE :roleid ORDER BY p.description ASC").setParameter("roleid", roleid).getResultList();
        } catch (Exception exception) {
        }
        return pages;
    }

    public List<Menus> getAllMenus() {
        return this.em.createQuery("SELECT m FROM Menus m ORDER BY m.name", Menus.class).getResultList();
    }

    public Pages getPageByName(String name) {
        try {
            return (Pages) this.em.createQuery("SELECT p FROM Pages p WHERE p.name = :name", Pages.class)
                    .setParameter("name", name)
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public String getDesignedMenu(String username) {
        List<Menus> tb = getAllMenus();
        String tabmenu = "";
        for (Menus tb1 : tb) {
            String[] pages = getPagesString(username).split(";");
            if (pages.length > 0) {
                int ps = 0;
                String xtabmenu = "<li class=\"nav-group\"><a class=\"nav-link nav-group-toggle\" href=\"#\"><svg class=\"nav-icon\"><use xlink:href=\"vendors/@coreui/icons/svg/free.svg#cil-puzzle\"></use></svg><span data-coreui-i18n=\"" + tb1.getId() + "\">" + tb1.getName() + "</span></a><ul class=\"nav-group-items compact\">";
                for (String page : pages) {
                    Pages pagedet = getPageByName(page);
                    if (pagedet != null
                            && pagedet.getManuId() != null && tb1.getId().equalsIgnoreCase(pagedet.getManuId().getId())) {
                        if (pagedet.getStatus().equalsIgnoreCase("ACTIVE")) {
                            xtabmenu = xtabmenu + "<li class=\"nav-item\"><a class=\"nav-link\" href=\"/" + xtabmenu + "\"><span class=\"nav-icon\"><span class=\"nav-icon-bullet\"></span></span><span data-coreui-i18n=\"accordion\">" + pagedet.getAlias() + "</span></a></li>";
                        } else {
                            xtabmenu = xtabmenu + "<li class=\"nav-item\"><a class=\"nav-link\" href=\"#\" title=\"This page has been deactivated\"><span class=\"nav-icon\"><span class=\"nav-icon-bullet\"></span></span><span data-coreui-i18n=\"accordion\">" + xtabmenu + "</span></a></li>";
                        }
                        ps++;
                    }
                }
                xtabmenu = xtabmenu + "</ul></li>";
                if (ps > 0) {
                    tabmenu = tabmenu + tabmenu;
                    ps = 0;
                }
            }
        }
        return tabmenu;
    }

    public News getLatestNews() {
        News news = null;
        return news;
    }

    public List<News> getTop5() {
        List<News> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT n FROM News n WHERE n.status = 'ACTIVE' ORDER By n.datePosted DESC").setMaxResults(5).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<News> getAllNews(String status) {
        List<News> list = new ArrayList<>();
        return list;
    }

    public Students getStudentsById(String studentId) {
        Students std = null;
        try {
            List<Students> l2 = this.em.createQuery("SELECT p FROM Students p WHERE p.id = :id1 OR p.registrationNo = :id2 OR p.matricNo = :id3 OR p.universityEmail = :id4").setParameter("id1", studentId).setParameter("id2", studentId).setParameter("id3", studentId).setParameter("id4", studentId).getResultList();
            Iterator<Students> iterator = l2.iterator();
            if (iterator.hasNext()) {
                Students pa = iterator.next();
                std = pa;
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public Staff getStaffById(String stfid) {
        Staff std = null;
        try {
            List<Staff> l2 = this.em.createQuery("SELECT p FROM Staff p WHERE p.id = :id1 OR p.staffNo = :id2 OR p.officialEmailAddress = :id3").setParameter("id1", stfid).setParameter("id2", stfid).setParameter("id3", stfid).getResultList();
            Iterator<Staff> iterator = l2.iterator();
            if (iterator.hasNext()) {
                Staff pa = iterator.next();
                std = pa;
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public Applicants getApplicantsById(String id) {
        Applicants std = null;
        try {
            List<Applicants> l2 = this.em.createQuery("SELECT p FROM Applicants p WHERE p.id = :id1").setParameter("id1", id).getResultList();
            Iterator<Applicants> iterator = l2.iterator();
            if (iterator.hasNext()) {
                Applicants pa = iterator.next();
                std = pa;
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public Applicantsbiodata getApplicantsbiodataById(String id) {
        Applicantsbiodata std = null;
        try {
            std = (Applicantsbiodata) this.em.createQuery("SELECT p FROM Applicantsbiodata p WHERE p.id = :id1").setParameter("id1", id).getSingleResult();
        } catch (Exception exception) {
        }
        return std;
    }

    public Olevelresults getOlevelresults(String id) {
        Olevelresults std = null;
        try {
            std = (Olevelresults) this.em.createQuery("SELECT p FROM Olevelresults p WHERE p.id = :id1").setParameter("id1", id).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return std;
    }

    public List<Applicants> getApplicantsByCourseStatus(String course, String session, String status, String apptype) {
        List<Applicants> std = new ArrayList<>();
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.applicationType = :apptype";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("apptype", apptype).getResultList();
            } else {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status AND p.applicationType = :apptype";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("apptype", apptype).getResultList();
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public List<Courses> getAllCoursesOld() {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Courses l ORDER BY l.name ASC").getResultList();
        } catch (Exception k) {
            k.printStackTrace();
        }
        return list;
    }

    public List<Applicants> getApplicantsByCourse(String course, String session, String status) {
        List<Applicants> std = new ArrayList<>();
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session ORDER BY p.dateInitiated DESC";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).getResultList();
            } else {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status ORDER BY p.dateInitiated DESC";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).getResultList();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public Long getCountApplicantsByCourse(String course, String session, String status) {
        Long std = Long.valueOf(0L);
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).getSingleResult();
            } else {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).getSingleResult();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public List<Applicants> getApplicantsByCourseAndTypes(String course, String session, String status, List<String> appTypes) {
        List<Applicants> std = new ArrayList<>();
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.applicationType IN :appTypes ORDER BY p.dateInitiated DESC";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("appTypes", appTypes).getResultList();
            } else {
                String text = "SELECT p FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status AND p.applicationType IN :appTypes ORDER BY p.dateInitiated DESC";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("appTypes", appTypes).getResultList();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public Long getCountApplicantsByCourseStatus(String course, String session, String status, String apptype) {
        Long std = Long.valueOf(0L);
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.applicationType = :apptype";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("apptype", apptype).getSingleResult();
            } else {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status AND p.applicationType = :apptype";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("apptype", apptype).getSingleResult();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public List<Object[]> getApplicationTypesByCourseAndSession(String course, String session) {
        List<Object[]> results = new ArrayList();
        try {
            String text = "SELECT p.applicationType, COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session GROUP BY p.applicationType";
            results = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).getResultList();
        } catch (Exception s) {
            s.printStackTrace();
        }
        return results;
    }

    public Long getCountApplicantsByCourseAndTypes(String course, String session, String status, List<String> appTypes) {
        Long std = Long.valueOf(0L);
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.applicationType IN :appTypes";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("appTypes", appTypes).getSingleResult();
            } else {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.course1.id = :course AND p.session = :session AND p.status = :status AND p.applicationType IN :appTypes";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("appTypes", appTypes).getSingleResult();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public Long getCountAdmissionsByCourseStatus(String course, String session, String status, String moe) {
        Long std = Long.valueOf(0L);
        if (moe.equalsIgnoreCase("ALL")) {
            moe = "%%";
        } else {
            moe = "%" + moe + "%";
        }
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT COUNT(p) FROM Admissions p WHERE p.courseId.id = :course AND p.session = :session AND p.modeOfEntry LIKE :apptype";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("apptype", moe).getSingleResult();
            } else {
                String text = "SELECT COUNT(p) FROM Admissions p WHERE p.courseId.id = :course AND p.session = :session AND p.admissionStatus = :status AND p.modeOfEntry LIKE :apptype";
                std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("apptype", moe).getSingleResult();
            }
        } catch (Exception s) {
            s.printStackTrace();
        }
        return std;
    }

    public Long getCountStudentsByCourseSessionadm(String course, String session, String moe) {
        Long std = Long.valueOf(0L);
        if (moe.equalsIgnoreCase("ALL")) {
            moe = "%%";
        } else {
            moe = "%" + moe + "%";
        }
        try {
            String text = "SELECT COUNT(p) FROM Students p WHERE p.courseId.id = :course AND p.sessionAdmitted = :session AND p.modeOfEntry LIKE :apptype";
            std = (Long) this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("apptype", moe).getSingleResult();
        } catch (Exception exception) {
        }
        return std;
    }

    public List<Admissions> getAdmissionsByCourseStatus(String course, String session, String status, String moe, String schoolid, Integer programmeid) {
        List<Admissions> std = new ArrayList<>();
        if (moe.equalsIgnoreCase("ALL")) {
            moe = "%%";
        } else {
            moe = "%" + moe + "%";
        }
        if (course.equalsIgnoreCase("ALL")) {
            course = "%%";
        } else {
            course = "%" + course + "%";
        }
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT p FROM Admissions p WHERE p.courseId.id LIKE :course AND p.session = :session AND p.modeOfEntry LIKE :apptype AND p.schoolId.id = :schid AND p.programmeId.id = :progid";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("apptype", moe).setParameter("schid", schoolid).setParameter("progid", programmeid).getResultList();
            } else {
                String text = "SELECT p FROM Admissions p WHERE p.courseId.id LIKE :course AND p.session = :session AND p.admissionStatus = :status AND p.modeOfEntry LIKE :apptype AND p.schoolId.id = :schid AND p.programmeId.id = :progid";
                std = this.em.createQuery(text).setParameter("course", course).setParameter("session", session).setParameter("status", status).setParameter("apptype", moe).setParameter("schid", schoolid).setParameter("progid", programmeid).getResultList();
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public List<Applicants> getApplicantsByTypeSessionStatus(String session, String status, String apptype) {
        List<Applicants> std = new ArrayList<>();
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT p FROM Applicants p WHERE p.session = :session AND p.applicationType = :apptype";
                std = this.em.createQuery(text).setParameter("session", session).setParameter("apptype", apptype).getResultList();
            } else {
                String text = "SELECT p FROM Applicants p WHERE p.session = :session AND p.status = :status AND p.applicationType = :apptype";
                std = this.em.createQuery(text).setParameter("session", session).setParameter("status", status).setParameter("apptype", apptype).getResultList();
            }
        } catch (Exception exception) {
        }
        return std;
    }

    public Long countApplicantsByTypeSessionStatus(String session, String status, String apptype) {
        Long count = Long.valueOf(0L);
        try {
            if (status.equalsIgnoreCase("ALL")) {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.session = :session AND p.applicationType = :apptype";
                count = (Long) this.em.createQuery(text).setParameter("session", session).setParameter("apptype", apptype).getSingleResult();
            } else {
                String text = "SELECT COUNT(p) FROM Applicants p WHERE p.session = :session AND p.status = :status AND p.applicationType = :apptype";
                count = (Long) this.em.createQuery(text).setParameter("session", session).setParameter("status", status).setParameter("apptype", apptype).getSingleResult();
            }
        } catch (Exception exception) {
        }
        return count;
    }

    public List<String> getOlevelsForAdmission(Applicants app, List<Admissiontemplateolevel> admtl) {
        List<String> subjs = new ArrayList<>();
        try {
            Olevelresults olr = getOlevelresults(app.getId());
            if (olr != null) {
                Collection<Olevelresultsitems> items = olr.getOlevelresultsitemsCollection();
                List<Admissiontemplateolevel> listoc = (List<Admissiontemplateolevel>) admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C")).collect(Collectors.toList());
                List<Admissiontemplateolevel> listoo = (List<Admissiontemplateolevel>) admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O")).collect(Collectors.toList());
                for (Admissiontemplateolevel comp : listoc) {
                    for (Olevelresultsitems ol : items) {
                        if (comp.getOlevelSubject().getId().equalsIgnoreCase(ol.getOlevelResultsId().getId())) {
                            subjs.add(ol.getOlevelResultsId().getId());
                            items.remove(ol);
                        }
                    }
                }
                List<Olevelresultsitems> list = new ArrayList<>(items);
                list.sort((o1, o2) -> Integer.compare(o2.getGrade().getScore(), o1.getGrade().getScore()));
            }
        } catch (Exception exception) {
        }
        return subjs;
    }

    public Long countApplicantsBySessionAndType(String sess, String apptype) {
        Long co = Long.valueOf(0L);
        try {
            Query query = this.em.createQuery("SELECT COUNT(e) FROM Applicants e WHERE e.session = :sess AND e.applicationType = :apptype").setParameter("sess", sess).setParameter("apptype", apptype);
            co = (Long) query.getSingleResult();
        } catch (Exception exception) {
        }
        return co;
    }

    public List<Object[]> getApplicantsBySessionAndType(String sess, String apptype, int count, int index) {
        List<Object[]> list = new ArrayList();
        try {
            String sql = "SELECT * FROM Applicants WHERE session = ? AND application_type = ? ORDER BY date_initiated DESC, id ASC";
            Query query = this.em.createQuery("SELECT e.id, e.surname, e.othernames, e.course1.name, e.gender, e.stateOfOrigin.name FROM Applicants e WHERE e.session = :sess AND e.applicationType = :apptype ORDER BY e.course1.name ASC, e.id ASC").setParameter("sess", sess).setParameter("apptype", apptype).setFirstResult(index).setMaxResults(count);
            list = query.getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Object[]> getQualifiedApplicantsBySessionAndType(String sess, String apptype, int count, int index) {
        List<Object[]> list = new ArrayList();
        try {
            Query query = this.em.createQuery("SELECT DISTINCT e.id, e.surname, e.othernames, e.course1.name, e.gender, e.stateOfOrigin.name FROM Applicants e WHERE e.session = :sess AND e.applicationType = :apptype AND EXISTS (SELECT p FROM Payments p WHERE (p.payerId = e.id OR p.payerRegistrationNo = e.id)            AND p.datePaid IS NOT NULL AND p.sessionPaid = e.session) AND EXISTS (SELECT u FROM Applicantsutme u WHERE u.applicantId = e.id AND u.totalUtme > 0) ORDER BY e.course1.name ASC, e.id ASC").setParameter("sess", sess).setParameter("apptype", apptype).setFirstResult(index).setMaxResults(count);
            list = query.getResultList();
        } catch (Exception k) {
            System.out.println("Error in getQualifiedApplicantsBySessionAndType: " + k.getMessage());
            k.printStackTrace();
            return getApplicantsBySessionAndType(sess, apptype, count, index);
        }
        return list;
    }

    public Long countQualifiedApplicantsBySessionAndType(String sess, String apptype) {
        Long count = Long.valueOf(0L);
        try {
            Query query = this.em.createQuery("SELECT COUNT(DISTINCT e.id) FROM Applicants e WHERE e.session = :sess AND e.applicationType = :apptype AND EXISTS (SELECT p FROM Payments p WHERE (p.payerId = e.id OR p.payerRegistrationNo = e.id)            AND p.datePaid IS NOT NULL AND p.sessionPaid = e.session) AND EXISTS (SELECT u FROM Applicantsutme u WHERE u.applicantId = e.id AND u.totalUtme > 0)").setParameter("sess", sess).setParameter("apptype", apptype);
            count = (Long) query.getSingleResult();
        } catch (Exception k) {
            System.out.println("Error in countQualifiedApplicantsBySessionAndType: " + k.getMessage());
            k.printStackTrace();
            return countApplicantsBySessionAndType(sess, apptype);
        }
        return count;
    }

    public List<Feesgroup> getFeesgroupBySchoolAndCategory(String schoolId, String category) {
        List<Feesgroup> list = new ArrayList<>();
        try {
            if (category.equalsIgnoreCase("ALL")) {
                list = this.em.createQuery("SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schId ORDER BY p.name ASC").setParameter("schId", schoolId).getResultList();
            } else {
                list = this.em.createQuery("SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schId AND p.category = :cat ORDER BY p.name ASC").setParameter("schId", schoolId).setParameter("cat", category).getResultList();
            }
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Feesgroup> getFeesgroupBySchoolAndCategory(String schoolId, String category, String visibility) {
        List<Feesgroup> list = new ArrayList<>();
        try {
            if (category.equalsIgnoreCase("ALL")) {
                list = this.em.createQuery("SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schId AND p.visibility = :visibility ORDER BY p.name ASC").setParameter("schId", schoolId).setParameter("visibility", visibility).getResultList();
            } else {
                list = this.em.createQuery("SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schId AND p.visibility = :visibility AND p.category = :cat ORDER BY p.name ASC").setParameter("schId", schoolId).setParameter("cat", category).setParameter("visibility", visibility).getResultList();
            }
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Studentprogression> getStudentprogression(String stdid) {
        List<Studentprogression> list = new ArrayList<>();
        try {
            String tex = "SELECT p FROM Studentprogression p WHERE p.studentsId.id = :stdid ORDER BY p.sessionAdded DESC";
            list = this.em.createQuery(tex).setParameter("stdid", stdid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public boolean isMatchingProgression(Studentprogression person, String tmpsess, String semester) {
        return (person.getSessionAdded().equals(tmpsess) && person.getSemesterAdded().equals(semester));
    }

    public Studentprogression getStudentprogressionByStdSessSem(String stdid, String sess, String sem) {
        Studentprogression pro = null;
        Students stdy = getStudentsById(stdid);
        if (stdy != null) {
            Collection<Studentprogression> cl2 = stdy.getStudentprogressionCollection();
            for (Studentprogression sp : cl2) {
                if (sp.getSessionAdded().equalsIgnoreCase(sess) && sp
                        .getSemesterAdded().equalsIgnoreCase(sem)) {
                    pro = sp;
                    break;
                }
            }
        }
        return pro;
    }

    public Feesgroup getSchoolFeesId(String schId) {
        Feesgroup fs = null;
        try {
            String tex = "SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schid AND p.name ='SCHOOL FEES'";
            List<Feesgroup> list = this.em.createQuery(tex).setParameter("schid", schId).getResultList();
            if (list.size() > 0) {
                fs = list.get(0);
            }
        } catch (Exception exception) {
        }
        return fs;
    }

    public List<Feessetup> getFeessetup(String feesgroup, String sess, String sem, String sch, String prog, String fac, String dept, String course, String lev, String ind, String campus, Date dfrom, String std) {
        List<Feessetup> list = new ArrayList<>();
        try {
            String tex = "SELECT s FROM Feessetup s WHERE s.feesGroupId.id = :feesgroup AND (s.sessionAdded = :sess OR s.sessionAdded = 'All') AND (s.semesterAdded = :sem OR s.semesterAdded = 'None') AND (s.schoolScope = :sch OR s.schoolScope = 'None') AND (s.facultyScope = :fac OR s.facultyScope = 'None') AND (s.programmeScope = :prog OR s.programmeScope = 'None') AND (s.departmentScope = :dept OR s.departmentScope = 'None') AND (s.courseScope = :course OR s.courseScope = 'None') AND (s.levelScope = :lev OR s.levelScope = 'None') AND (s.indigeneStatusScope = :ind OR s.indigeneStatusScope = 'None') AND (s.onCampusScope = :campus OR s.onCampusScope = 'All') AND (s.studentId = :std OR s.studentId = 'None')";
            list = this.em.createQuery(tex).setParameter("feesgroup", feesgroup).setParameter("sess", sess).setParameter("sem", sem).setParameter("sch", sch).setParameter("fac", fac).setParameter("prog", prog).setParameter("dept", dept).setParameter("course", course).setParameter("lev", lev).setParameter("ind", ind).setParameter("campus", campus).setParameter("std", std).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Feessetup> getFeessetup(String feesgroup, String sess, String sem, String sch, String prog) {
        List<Feessetup> list = new ArrayList<>();
        try {
            String tex = "SELECT s FROM Feessetup s WHERE s.feesGroupId.id = :feesgroup AND (s.sessionAdded = :sess OR s.sessionAdded = 'All') AND (s.semesterAdded = :sem OR s.semesterAdded = 'None') AND (s.schoolScope = :sch OR s.schoolScope = 'None') AND (s.programmeScope = :prog OR s.programmeScope = 'None') ORDER BY s.courseScope ASC, s.levelScope ASC, s.indigeneStatusScope ASC, s.departmentScope ASC, s.facultyScope ASC,   s.onCampusScope ASC, s.studentId ASC";
            list = this.em.createQuery(tex).setParameter("feesgroup", feesgroup).setParameter("sess", sess).setParameter("sem", sem).setParameter("sch", sch).setParameter("prog", prog).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public Double sumPaymentByItemSchoolYear(String item, String school, String year) {
        Double am = Double.valueOf(0.0D);
        try {
            String sdate = year + "-01-01 00:00:00";
            String edate = year + "-12-31 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            am = (Double) this.em.createQuery("SELECT SUM(p.amount) FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear AND p.feesGroupId.id = :item").setParameter("schid", school).setParameter("startYear", ts1).setParameter("endYear", ts2).setParameter("item", item).getSingleResult();
        } catch (Exception exception) {
        }
        return am;
    }

    public Double sumPaymentByItemSchoolMonth(String item, String school, String year) {
        Double am = Double.valueOf(0.0D);
        try {
            String sdate = year + "-01 00:00:00";
            String edate = year + "-31 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            am = (Double) this.em.createQuery("SELECT SUM(p.amount) FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear AND p.feesGroupId.id = :item").setParameter("schid", school).setParameter("startYear", ts1).setParameter("endYear", ts2).setParameter("item", item).getSingleResult();
        } catch (Exception exception) {
        }
        return am;
    }

    public List<Payments> listPaymentByItemSchoolMonth(String item, String school, String year) {
        List<Payments> am = new ArrayList<>();
        try {
            String sdate = year + "-01 00:00:00";
            String edate = year + "-31 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            am = this.em.createQuery("SELECT p FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear AND p.feesGroupId.id = :item ORDER BY p.datePaid DESC").setParameter("schid", school).setParameter("startYear", ts1).setParameter("endYear", ts2).setParameter("item", item).getResultList();
        } catch (Exception exception) {
        }
        return am;
    }

    public List<Payments> listPaymentByItemSchoolSessionSemester(String item, String school, String sess, String sem) {
        List<Payments> am = new ArrayList<>();
        try {
            am = this.em.createQuery("SELECT p FROM Payments p WHERE p.schoolId.id = :schid AND p.sessionPaid = :sess AND p.semesterPaid = :sem AND p.feesGroupId.id = :item ORDER BY p.datePaid DESC").setParameter("schid", school).setParameter("sess", sess).setParameter("sem", sem).setParameter("item", item).getResultList();
        } catch (Exception exception) {
        }
        return am;
    }

    public List<Feesgroup> getFeesgroupBySchoolAndYearRange(String schid, String startYear, String endYear) {
        List<Feesgroup> fg = new ArrayList<>();
        try {
            String sdate = startYear + "-01-01 00:00:00";
            String edate = endYear + "-12-31 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            fg = this.em.createQuery("SELECT p.feesGroupId FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear ORDER BY p.feesGroupId.name ASC").setParameter("schid", schid).setParameter("startYear", ts1).setParameter("endYear", ts2).getResultList();
        } catch (Exception exception) {
        }
        return fg;
    }

    public List<Feesgroup> getFeesgroupBySchoolAndMonthRange(String schid, String startYear, String endYear) {
        List<Feesgroup> fg = new ArrayList<>();
        try {
            String sdate = startYear + "-01 00:00:00";
            String edate = endYear + "-31 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            fg = this.em.createQuery("SELECT p.feesGroupId FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear ORDER BY p.feesGroupId.name ASC").setParameter("schid", schid).setParameter("startYear", ts1).setParameter("endYear", ts2).getResultList();
        } catch (Exception exception) {
        }
        return fg;
    }

    public List<Payments> viewPaymentsBySchoolAndDateRange(String schid, String startYear, String endYear) {
        List<Payments> fg = new ArrayList<>();
        try {
            String sdate = startYear + " 00:00:00";
            String edate = endYear + " 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            fg = this.em.createQuery("SELECT p FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid >= :startYear AND p.datePaid <= :endYear ORDER BY p.datePaid DESC").setParameter("schid", schid).setParameter("startYear", ts1).setParameter("endYear", ts2).getResultList();
        } catch (Exception exception) {
        }
        return fg;
    }

    public Map<String, Object> sumPaymentsBySchoolAndDateRange(String schid, String startYear, String endYear) {
        Map<String, Object> result = new HashMap<>();
        Double sum = Double.valueOf(0.0D);
        Long count = Long.valueOf(0L);
        try {
            String sdate = startYear + " 00:00:00";
            String edate = endYear + " 23:59:59";
            Timestamp ts1 = null;
            Timestamp ts2 = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date parsedDate1 = dateFormat.parse(sdate);
                Date parsedDate2 = dateFormat.parse(edate);
                ts1 = new Timestamp(parsedDate1.getTime());
                ts2 = new Timestamp(parsedDate2.getTime());
            } catch (Exception exception) {
            }
            Object[] queryResult = (Object[]) this.em.createQuery("SELECT COALESCE(SUM(p.amount), 0), COUNT(p.id) FROM Payments p WHERE p.schoolId.id = :schid AND p.datePaid BETWEEN :startYear AND :endYear").setParameter("schid", schid).setParameter("startYear", ts1).setParameter("endYear", ts2).getSingleResult();
            if (queryResult != null) {
                sum = Double.valueOf((queryResult[0] != null) ? ((Double) queryResult[0]).doubleValue() : 0.0D);
                count = Long.valueOf((queryResult[1] != null) ? ((Long) queryResult[1]).longValue() : 0L);
            }
        } catch (Exception exception) {
        }
        result.put("totalAmount", sum);
        result.put("entryCount", count);
        return result;
    }

    public List<Payments> getPaymentsByRegnoSessSemFeesgroup(String stdid, String feesgroup, String sess, String sem) {
        List<Payments> payl = new ArrayList<>();
        try {
            payl = this.em.createQuery("SELECT p FROM Payments p WHERE p.payerId = :stdid AND p.feesGroupId.id = :geesgroup AND p.sessionPaid = :sess AND p.semesterPaid = :sem").setParameter("stdid", stdid).setParameter("geesgroup", feesgroup).setParameter("sess", sess).setParameter("sem", sem).getResultList();
        } catch (Exception exception) {
        }
        return payl;
    }

    public List<Payments> getPaymentsByRegno(String stdid) {
        List<Payments> payl = new ArrayList<>();
        String xid = stdid;
        try {
            Students std = getStudentsById(stdid);
            if (std != null) {
                xid = std.getId();
            }
        } catch (Exception exception) {
        }
        try {
            payl = this.em.createQuery("SELECT p FROM Payments p WHERE p.payerId = :stdid OR p.payerRegistrationNo = :stdid2 ORDER BY p.datePaid DESC").setParameter("stdid", xid).setParameter("stdid2", xid).getResultList();
        } catch (Exception exception) {
        }
        return payl;
    }

    public List<PaymentDetails> aggregatePayments(List<Payments> paymentsList) {
        Map<String, Double> grouped = (Map<String, Double>) paymentsList.stream().collect(Collectors.groupingBy(p -> String.valueOf(p.getFeesGroupId()) + "|" + String.valueOf(p.getFeesGroupId()) + "|" + p.getSemesterPaid(),
                Collectors.summingDouble(p -> p.getAmount())));
        return (List<PaymentDetails>) grouped.entrySet().stream()
                .map(entry -> {
                    String[] parts = ((String) entry.getKey()).split("\\|");
                    return new PaymentDetails(parts[0], ((Double) entry.getValue()).doubleValue(), parts[1], parts[2], 0.0D);
                }).collect(Collectors.toList());
    }

    public Paymentreference updatePaymentReference(String id) {
        Paymentreference pr = getPaymentreference(id);
        try {
            if (pr != null) {
                String status = "FAILED";
                PaymentNotification resp = null;
                InterswitchUtil paymentUtil = new InterswitchUtil();
                String verify = paymentUtil.getPaymentNotification(pr.getId(), pr.getAmount());
                if (verify != null && verify.trim().length() > 0) {
                    Gson gson = new Gson();
                    try {
                        resp = (PaymentNotification) gson.fromJson(verify, PaymentNotification.class);
                    } catch (Exception exception) {
                    }
                    if (resp != null
                            && "10;11;00".contains(resp.getResponseCode())) {
                        status = "SUCCESSFUL";
                        try {
                            String bankCode = "WebPay";
                            Banks ban = null;
                            try {
                                bankCode = resp.getPaymentReference().split("\\|")[0];
                            } catch (Exception exception) {
                            }
                            pr.setResponseText(resp.getResponseDescription());
                            pr.setPaymentRef(resp.getPaymentReference());
                            pr.setBankCode(bankCode);
                            pr.setBankName(resp.getCardNumber());
                            pr.setDatePaid(this.settings.getCurrentDateTime());
                            pr.setPaidStatus("PAID");
                            try {
                                ban = getBanks(bankCode);
                                if (ban == null) {
                                    ban = new Banks(bankCode);
                                    ban.setName(bankCode);
                                    newEntry(ban);
                                }
                            } catch (Exception exception) {
                            }
                            updatePaymentreference(pr.getId(), resp.getResponseDescription(), resp
                                    .getPaymentReference(), bankCode, resp
                                            .getCardNumber(), this.settings.getCurrentDateTime(), status);
                            try {
                                Payments pay = new Payments(pr.getId());
                                pay.setAmount(pr.getAmount());
                                pay.setDatePaid(this.settings.getCurrentDateTime());
                                pay.setPayerId(pr.getPayerId());
                                pay.setPayerRegistrationNo(pr.getPayerRegistrationIo());
                                pay.setPayerFullname(pr.getPayerName());
                                pay.setSessionPaid(pr.getSession());
                                pay.setSemesterPaid(pr.getSemester());
                                Courses co = null;
                                Programmes prog = null;
                                try {
                                    co = getCourses(pr.getCourseId());
                                    if (co != null) {
                                        prog = co.getSchoolProgrammeId().getProgrammeId();
                                    }
                                } catch (Exception exception) {
                                }
                                pay.setCourseId(co);
                                pay.setFeesGroupId(pr.getFeesGroupId());
                                pay.setProgrammeId(prog);
                                pay.setSchoolId(pr.getSchoolId());
                                pay.setLevel(pr.getLevel());
                                pay.setBankId(ban);
                                newEntry(pay);
                            } catch (Exception exception) {
                            }
                        } catch (Exception exception) {
                        }
                    }
                }
            }
        } catch (Exception exception) {
        }
        return pr;
    }

    public List<Paymentreference> getPaymentreferenceByRegno(String stdid) {
        List<Paymentreference> payl = new ArrayList<>();
        String xid = stdid;
        try {
            Students std = getStudentsById(stdid);
            if (std != null) {
                xid = std.getId();
            }
        } catch (Exception exception) {
        }
        try {
            payl = this.em.createQuery("SELECT p FROM Paymentreference p WHERE p.payerId = :stdid ORDER BY p.dateGenerated DESC").setParameter("stdid", xid).getResultList();
        } catch (Exception exception) {
        }
        return payl;
    }

    public List<Userlogins> getUserlogins(String id) {
        List<Userlogins> logins = new ArrayList<>();
        try {
            logins = this.em.createQuery("SELECT l FROM Userlogins l WHERE l.userId = :id ORDER BY l.datelogin DESC").setParameter("id", id).setMaxResults(10).getResultList();
        } catch (Exception exception) {
        }
        return logins;
    }

    public Sessionmanager getCurrentSessionManagerBySchoolAndOperation(String schoolId, String operation) {
        Sessionmanager sm = null;
        try {
            sm = (Sessionmanager) this.em.createQuery("SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op AND l.status = 'OPEN' ORDER BY l.name DESC, l.semester DESC").setParameter("sch", schoolId).setParameter("op", operation).setMaxResults(1).getSingleResult();
        } catch (Exception k) {
            try {
                sm = (Sessionmanager) this.em.createQuery("SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op ORDER BY l.name DESC, l.semester DESC").setParameter("sch", schoolId).setParameter("op", operation).setMaxResults(1).getSingleResult();
            } catch (Exception exception) {
            }
        }
        return sm;
    }

    /**
     * Get SessionManager by school, session name, and operation
     * This method finds the specific session that matches the applicant's session
     * 
     * @param schoolId The school ID
     * @param sessionName The session name (e.g., "2025/2026")
     * @param operation The operation type (e.g., "APPLICATION")
     * @return The matching Sessionmanager or null if not found
     */
    public Sessionmanager getSessionManagerBySchoolSessionAndOperation(String schoolId, String sessionName, String operation) {
        Sessionmanager sm = null;
        try {
            // DEBUG: Log the search parameters
            System.out.println("=== SEARCHING FOR SESSION MANAGER ===");
            System.out.println("School ID: " + schoolId);
            System.out.println("Session Name: " + sessionName);
            System.out.println("Operation: " + operation);
            
            sm = (Sessionmanager) this.em.createQuery(
                "SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.name = :session AND l.operation = :op"
            ).setParameter("sch", schoolId)
             .setParameter("session", sessionName)
             .setParameter("op", operation)
             .setMaxResults(1)
             .getSingleResult();
             
            System.out.println("FOUND Session Manager: " + sm.getName() + " (Status: " + sm.getStatus() + ")");
        } catch (Exception exception) {
            // Session not found
            System.out.println("NO SESSION MANAGER FOUND - Exception: " + exception.getMessage());
        }
        return sm;
    }

    public List<Sessionmanager> getAllSessionmanager(String schoolId, String operation, String semester) {
        List<Sessionmanager> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op AND l.semester = :sem ORDER BY l.name DESC, l.semester DESC").setParameter("sch", schoolId).setParameter("op", operation).setParameter("sem", semester).getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Sessionmanager getLatestSession() {
        Sessionmanager sess = null;
        try {
            List<Sessionmanager> sm = this.em.createQuery("SELECT l FROM Sessionmanager l ORDER BY l.name DESC").setMaxResults(1).getResultList();
            sess = sm.get(0);
        } catch (Exception exception) {
        }
        return sess;
    }

    public List<Sessionmanager> getAllSessionmanager() {
        List<Sessionmanager> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Sessionmanager l ORDER BY l.status ASC, l.operation ASC, l.schoolId ASC, l.name ASC, l.semester ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Sessionmanager getSessionmanager(String schoolId, String operation, String semester, String sessions) {
        Sessionmanager sm = null;
        try {
            sm = (Sessionmanager) this.em.createQuery("SELECT l FROM Sessionmanager l WHERE l.schoolId.id = :sch AND l.operation = :op AND l.semester = :sem AND l.name = :sessions ORDER BY l.name DESC, l.semester DESC").setParameter("sch", schoolId).setParameter("op", operation).setParameter("sem", semester).setParameter("sessions", sessions).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Payments getPayments(String id) {
        Payments sm = null;
        try {
            sm = (Payments) this.em.createQuery("SELECT l FROM Payments l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Feesitems> getAllFeesitems() {
        List<Feesitems> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Feesitems l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    @Transactional
    public void updateFeesitems(Integer id, String name, String details) {
        try {
            Feesitems fi = (Feesitems) this.em.find(Feesitems.class, id);
            if (fi != null) {
                fi.setName(name);
                fi.setDetails(details);
                this.em.merge(fi);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error updating fee item", e);
        }
    }

    public boolean isFeesitemInUse(Integer id) {
        try {
            Long count = (Long) this.em.createQuery("SELECT COUNT(f) FROM Feessetup f WHERE f.feesItemsId.id = :itemId").setParameter("itemId", id).getSingleResult();
            return (count.longValue() > 0L);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional
    public void deleteFeesitems(Integer id) {
        try {
            Feesitems fi = (Feesitems) this.em.find(Feesitems.class, id);
            if (fi != null) {
                this.em.remove(fi);
                this.em.flush();
            }
        } catch (Exception e) {
            throw new RuntimeException("Error deleting fee item: " + e.getMessage(), e);
        }
    }

    public Applicants getApplicants(String id) {
        Applicants sm = null;
        try {
            // Use case-insensitive comparison to handle various ID formats
            sm = (Applicants) this.em.createQuery("SELECT l FROM Applicants l WHERE LOWER(l.id) = LOWER(:id)").setParameter("id", id).getSingleResult();
            Admissions adm = getAdmissions(sm.getId());
            if (adm != null) {
                sm.setCourse1(adm.getCourseId());
            }
        } catch (Exception exception) {
        }
        return sm;
    }

    public Admissions getAdmissions(String id) {
        Admissions sm = null;
        try {
            sm = (Admissions) this.em.createQuery("SELECT l FROM Admissions l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Studentprogression getStudentprogressionById(String id) {
        Studentprogression sp = null;
        try {
            sp = (Studentprogression) this.em.find(Studentprogression.class, id);
        } catch (Exception exception) {
        }
        return sp;
    }

    public Paymentreference getPaymentreference(String id) {
        Paymentreference sm = null;
        try {
            sm = (Paymentreference) this.em.createQuery("SELECT l FROM Paymentreference l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Paymentreference> getPaymentreferenceByStatus(String status) {
        List<Paymentreference> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Paymentreference l WHERE l.paidStatus = :status ORDER BY l.dateGenerated DESC").setParameter("status", status).setMaxResults(500).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public Banks getBanks(String id) {
        Banks sm = null;
        try {
            sm = (Banks) this.em.createQuery("SELECT l FROM Banks l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Courses getCourses(String id) {
        Courses sm = null;
        try {
            sm = (Courses) this.em.createQuery("SELECT l FROM Courses l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Courses> getCoursesBySchool(String schoolId) {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Courses l WHERE l.schoolProgrammeId.schoolId.id = :schoolid ORDER BY l.name ASC").setParameter("schoolid", schoolId).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Departments> getAllDepartments() {
        List<Departments> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Departments l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Userfaculties> getUserfacultiesByFaculty(String facultyid) {
        List<Userfaculties> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Userfaculties l WHERE l.facultyId.id = :facultyid ORDER BY l.dateAdded DESC").setParameter("facultyid", facultyid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Userfaculties> getUserfacultiesByUserid(String userid) {
        List<Userfaculties> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Userfaculties l WHERE l.userId.id = :userid ORDER BY l.dateAdded DESC").setParameter("userid", userid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Courses> getCoursesByFaculty(String facultyid) {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Courses l WHERE l.departmentId.facultyId.id = :facultyid ORDER BY l.name ASC").setParameter("facultyid", facultyid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Programmes> getAllProgrammesBySchool(String schoolId) {
        List<Programmes> list = new ArrayList<>();
        try {
            List<Schoolprogrammes> listd = this.em.createQuery("SELECT l FROM Schoolprogrammes l WHERE l.schoolId.id = :schoolid ORDER BY l.programmeId.name ASC").setParameter("schoolid", schoolId).getResultList();
            for (Schoolprogrammes pp : listd) {
                list.add(pp.getProgrammeId());
            }
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Applicants> getApplicantsByEmail(String email) {
        List<Applicants> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Applicants l WHERE LOWER(l.emailAddress) = :email ORDER BY l.session DESC").setParameter("email", email).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public boolean hasDuplicateApplicationForCourse(String email, String courseId) {
        try {
            if (email == null || email.trim().isEmpty() || courseId == null || courseId.trim().isEmpty()) {
                return false;
            }
            Query query = this.em.createQuery("SELECT COUNT(a) FROM Applicants a WHERE LOWER(a.emailAddress) = :email AND a.course1.id = :courseId");
            query.setParameter("email", email.toLowerCase().trim());
            query.setParameter("courseId", courseId.trim());
            Long count = (Long) query.getSingleResult();
            return (count.longValue() > 0L);
        } catch (Exception k) {
            System.out.println("Error checking duplicate application: " + k.getMessage());
            k.printStackTrace();
            return false;
        }
    }

    public Applicants getExistingApplicationForCourse(String email, String courseId) {
        try {
            if (email == null || email.trim().isEmpty() || courseId == null || courseId.trim().isEmpty()) {
                return null;
            }
            Query query = this.em.createQuery("SELECT a FROM Applicants a WHERE LOWER(a.emailAddress) = :email AND a.course1.id = :courseId ORDER BY a.dateInitiated DESC");
            query.setParameter("email", email.toLowerCase().trim());
            query.setParameter("courseId", courseId.trim());
            List<Applicants> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception k) {
            System.out.println("Error getting existing application: " + k.getMessage());
            k.printStackTrace();
            return null;
        }
    }

    public List<Courses> getCoursesBySchoolAndProgramme(String schoolId, String programmeId) {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Courses l WHERE l.schoolProgrammeId.schoolId.id = :schoolid AND l.schoolProgrammeId.programmeId.id = :programmeId ORDER BY l.name ASC").setParameter("schoolid", schoolId).setParameter("programmeId", Integer.valueOf(programmeId)).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Courses> getCoursesBySchoolAndFaculty(String schoolId, String faculty) {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Courses l WHERE l.schoolProgrammeId.schoolId.id = :schoolid AND l.departmentId.facultyId.id = :faculty ORDER BY l.name ASC").setParameter("schoolid", schoolId).setParameter("faculty", faculty).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Admissiontemplateolevel> getAdmissiontemplateolevel(String admt) {
        List<Admissiontemplateolevel> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Admissiontemplateolevel l WHERE l.admissionTemplate.id = :admt ORDER BY l.olevelSubject.name ASC").setParameter("admt", admt).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Admissiontemplateutme> getAdmissiontemplateutme(String admt) {
        List<Admissiontemplateutme> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Admissiontemplateutme l WHERE l.admissionTemplate.id = :admt ORDER BY l.utmesubjects.name ASC").setParameter("admt", admt).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public Admissiontemplate getAdmissiontemplate(String course, String session) {
        Admissiontemplate list = null;
        try {
            list = (Admissiontemplate) this.em.createQuery("SELECT l FROM Admissiontemplate l WHERE l.course.id = :course AND l.session = :sess ORDER BY l.course.name ASC").setParameter("course", course).setParameter("sess", session).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return list;
    }

    public Admissiontemplate getAdmissiontemplate(String id) {
        Admissiontemplate list = null;
        try {
            list = (Admissiontemplate) this.em.createQuery("SELECT l FROM Admissiontemplate l WHERE l.id = :id").setParameter("id", id).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return list;
    }

    public void resetAdmissionTemplateByCourse(String session, String course) {
        try {
            String prev = this.settings.getSessionBefore(session);
            Courses co = getCourses(course);
            if (co != null) {
                Admissiontemplate admt = getAdmissiontemplate(co.getId(), prev);
                if (admt != null) {
                    Admissiontemplate cadmt = getAdmissiontemplate(co.getId(), session);
                    try {
                        this.em.remove(cadmt);
                    } catch (Exception exception) {
                    }
                    String id = this.settings.generateId(this.settings.getTodaysdate().split("-")[0], 10);
                    Admissiontemplate curr = new Admissiontemplate(id);
                    curr.setAptitudePer(admt.getAptitudePer());
                    curr.setCompulsorySubjects(admt.getCompulsorySubjects());
                    curr.setCourse(admt.getCourse());
                    curr.setOlevelPer(admt.getOlevelPer());
                    curr.setOtherSubjects(admt.getOtherSubjects());
                    curr.setSession(session);
                    curr.setUtmePer(admt.getUtmePer());
                    newEntry(curr);
                    for (Admissiontemplateolevel ols : admt.getAdmissiontemplateolevelCollection()) {
                        ols.setId(id + id);
                        ols.setAdmissionTemplate(curr);
                        newEntry(ols);
                    }
                }
            }
        } catch (Exception exception) {
        }
    }

    public void resetAdmissionTemplate(String session, String school) {
        try {
            String prev = this.settings.getSessionBefore(session);
            List<Courses> lc = getCoursesBySchool(school);
            for (Courses co : lc) {
                Admissiontemplate admt = getAdmissiontemplate(co.getId(), prev);
                if (admt != null) {
                    Admissiontemplate cadmt = getAdmissiontemplate(co.getId(), session);
                    try {
                        this.em.remove(cadmt);
                    } catch (Exception exception) {
                    }
                    String id = this.settings.generateId(this.settings.getTodaysdate().split("-")[0], 10);
                    Admissiontemplate curr = new Admissiontemplate(id);
                    curr.setAptitudePer(admt.getAptitudePer());
                    curr.setCompulsorySubjects(admt.getCompulsorySubjects());
                    curr.setCourse(admt.getCourse());
                    curr.setOlevelPer(admt.getOlevelPer());
                    curr.setOtherSubjects(admt.getOtherSubjects());
                    curr.setSession(session);
                    curr.setUtmePer(admt.getUtmePer());
                    newEntry(curr);
                    for (Admissiontemplateolevel ols : admt.getAdmissiontemplateolevelCollection()) {
                        ols.setId(id + id);
                        ols.setAdmissionTemplate(curr);
                        newEntry(ols);
                    }
                }
            }
        } catch (Exception exception) {
        }
    }

    public Olevelsubjects getOlevelsubjects(String id) {
        Olevelsubjects sm = null;
        try {
            sm = (Olevelsubjects) this.em.createQuery("SELECT l FROM Olevelsubjects l WHERE l.id = :id OR l.name = :name").setParameter("id", id).setParameter("name", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Utmesubjects getUtmesubjects(String id) {
        Utmesubjects sm = null;
        try {
            sm = (Utmesubjects) this.em.createQuery("SELECT l FROM Utmesubjects l WHERE l.id = :id OR l.name = :name").setParameter("id", id).setParameter("name", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Olevelsubjects> getAllOlevelsubjects(String status) {
        List<Olevelsubjects> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Olevelsubjects l WHERE l.status = :status ORDER BY l.name ASC", Olevelsubjects.class).setParameter("status", status).getResultList();
        } catch (Exception k) {
            k.printStackTrace();
        }
        return sm;
    }

    public List<Olevelgrades> getAllOlevelgrades() {
        return this.em.createQuery("SELECT g FROM Olevelgrades g ORDER BY g.score ASC, g.id ASC", Olevelgrades.class)
                .getResultList();
    }

    public List<Countries> getAllCountries() {
        List<Countries> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Countries l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Programmes> getAllProgrammes() {
        List<Programmes> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Programmes l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<FacultiesDirectorates> getAllFacultiesDirectorates() {
        List<FacultiesDirectorates> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM FacultiesDirectorates l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Schools> getAllSchoos() {
        List<Schools> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Schools l ORDER BY l.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Utmesubjects> getAlUtmesubjects(String status) {
        List<Utmesubjects> sm = new ArrayList<>();
        try {
            sm = this.em.createQuery("SELECT l FROM Utmesubjects l WHERE l.status = :status ORDER BY l.name ASC").setParameter("status", status).getResultList();
        } catch (Exception exception) {
        }
        return sm;
    }

    @Transactional
    public String saveUtmeSubject(Utmesubjects subject) {
        try {
            Utmesubjects existing = getUtmesubjects(subject.getId());
            if (existing != null) {
                return "Error: Subject ID '" + subject.getId() + "' already exists";
            }
            try {
                Utmesubjects existingByName = (Utmesubjects) this.em.createQuery("SELECT u FROM Utmesubjects u WHERE UPPER(u.name) = :name").setParameter("name", subject.getName().toUpperCase()).getSingleResult();
                if (existingByName != null) {
                    return "Error: Subject name '" + subject.getName() + "' already exists";
                }
            } catch (Exception exception) {
            }
            this.em.persist(subject);
            return "Success";
        } catch (Exception e) {
            return "Error saving subject: " + e.getMessage();
        }
    }

    @Transactional
    public String updateUtmeSubject(Utmesubjects subject) {
        try {
            Utmesubjects existing = getUtmesubjects(subject.getId());
            if (existing == null) {
                return "Error: Subject not found";
            }
            existing.setName(subject.getName());
            existing.setAbbreviation(subject.getAbbreviation());
            existing.setStatus(subject.getStatus());
            this.em.merge(existing);
            return "Success";
        } catch (Exception e) {
            return "Error updating subject: " + e.getMessage();
        }
    }

    @Transactional
    public String deleteUtmeSubject(String id) {
        try {
            Utmesubjects subject = getUtmesubjects(id);
            if (subject == null) {
                return "Error: Subject not found";
            }
            Long count = (Long) this.em.createQuery("SELECT COUNT(a) FROM Applicantsutme a WHERE a.subj2 = :id OR a.subj3 = :id OR a.subj4 = :id").setParameter("id", id).getSingleResult();
            if (count.longValue() > 0L) {
                return "Error: Cannot delete subject. It is being used by " + count + " applicant(s)";
            }
            this.em.remove(subject);
            return "Success";
        } catch (Exception e) {
            return "Error deleting subject: " + e.getMessage();
        }
    }

    public EntityManager getEntityManager() {
        return this.em;
    }

    public Map<String, Object> getUtmeDetailsWithSubjectNames(String applicantId) {
        Map<String, Object> utmeDetails = new HashMap<>();
        try {
            Applicantsutme utme = (Applicantsutme) getSingleObject(Applicantsutme.class, applicantId);
            if (utme != null) {
                utmeDetails.put("engScore", utme.getEngScore());
                utmeDetails.put("totalUtme", utme.getTotalUtme());
                utmeDetails.put("postUtme", utme.getPostUtme());
                if (utme.getSubj2() != null) {
                    Utmesubjects subj2 = getUtmesubjects(utme.getSubj2());
                    utmeDetails.put("subj2Name", (subj2 != null) ? subj2.getName() : "Unknown Subject");
                    utmeDetails.put("subj2Score", utme.getSubj2Score());
                }
                if (utme.getSubj3() != null) {
                    Utmesubjects subj3 = getUtmesubjects(utme.getSubj3());
                    utmeDetails.put("subj3Name", (subj3 != null) ? subj3.getName() : "Unknown Subject");
                    utmeDetails.put("subj3Score", utme.getSubj3Score());
                }
                if (utme.getSubj4() != null) {
                    Utmesubjects subj4 = getUtmesubjects(utme.getSubj4());
                    utmeDetails.put("subj4Name", (subj4 != null) ? subj4.getName() : "Unknown Subject");
                    utmeDetails.put("subj4Score", utme.getSubj4Score());
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting UTME details with subject names: " + e.getMessage());
            e.printStackTrace();
        }
        return utmeDetails;
    }

    public Olevelgrades getOlevelgrades(String id) {
        Olevelgrades sm = null;
        try {
            sm = (Olevelgrades) this.em.createQuery("SELECT l FROM Olevelgrades l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Admissiontemplateolevel getOlevelresultsitem(String id) {
        Admissiontemplateolevel sm = null;
        try {
            sm = (Admissiontemplateolevel) this.em.createQuery("SELECT l FROM Admissiontemplateolevel l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Admissiontemplateutme getOlevelresultsitemUtme(String id) {
        Admissiontemplateutme sm = null;
        try {
            sm = (Admissiontemplateutme) this.em.createQuery("SELECT l FROM Admissiontemplateutme l WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Schools getSchools(String id) {
        Schools sm = null;
        try {
            sm = (Schools) this.em.createQuery("SELECT l FROM Schools l WHERE l.id = :id OR l.name = :name OR l.abbreviation = :abb").setParameter("id", id).setParameter("name", id).setParameter("abb", id).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public Olevelresultsitems getOlevelresultsitem(String appid, String subj) {
        Olevelresultsitems sm = null;
        try {
            sm = (Olevelresultsitems) this.em.createQuery("SELECT l FROM Olevelresultsitems l WHERE l.olevelResultsId.id = :appid AND l.subject = :subj").setParameter("appid", appid).setParameter("subj", subj).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    public List<Olevelresultsitems> getOlevelresultsItems(String appid) {
        List<Olevelresultsitems> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Olevelresultsitems l WHERE l.olevelResultsId.id = :appid ORDER BY l.subject ASC").setParameter("appid", appid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Olevelresults> getOlevelresultsByUserId(String userId) {
        List<Olevelresults> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Olevelresults l WHERE l.userId = :userId ORDER BY l.sitting ASC").setParameter("userId", userId).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Olevelresultsitems> getOlevelresultsItemsByUserId(String userId) {
        List<Olevelresultsitems> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT l FROM Olevelresultsitems l WHERE l.olevelResultsId.userId = :userId ORDER BY l.olevelResultsId.sitting ASC, l.subject ASC").setParameter("userId", userId).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    @Transactional
    public void cleanupDuplicateOlevelSittings(String userId) {
        try {
            List<Olevelresults> results = getOlevelresultsByUserId(userId);
            Map<String, List<Olevelresults>> sittingGroups = new HashMap<>();
            for (Olevelresults result : results) {
                ((List<Olevelresults>) sittingGroups.computeIfAbsent(result.getSitting(), k -> new ArrayList())).add(result);
            }
            for (Map.Entry<String, List<Olevelresults>> entry : sittingGroups.entrySet()) {
                List<Olevelresults> sittingResults = entry.getValue();
                if (sittingResults.size() > 1) {
                    sittingResults.sort((r1, r2) -> r1.getDateAdded().compareTo(r2.getDateAdded()));
                    for (int i = 1; i < sittingResults.size(); i++) {
                        Olevelresults toDelete = sittingResults.get(i);
                        List<Olevelresultsitems> items = getOlevelresultsItems(toDelete.getId());
                        for (Olevelresultsitems item : items) {
                            this.em.remove(item);
                        }
                        this.em.remove(toDelete);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error cleaning up duplicate O-level sittings", e);
        }
    }

    public AdmTempOLDet getAdmTempOLDet(Admissiontemplate adm, Applicants app) {
        AdmTempOLDet det = null;
        try {
            List<Admissiontemplateolevel> admtlU = this.getAdmissiontemplateolevel(adm.getId());

            List<Admissiontemplateolevel> listoc = admtlU.stream()
                    .filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C"))
                    .collect(Collectors.toList());
            List<Admissiontemplateolevel> listoo = admtlU.stream()
                    .filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O"))
                    .collect(Collectors.toList());

            String rm = "";

            Olevelresults olr = this.getOlevelresults(app.getId());
            if (olr != null) {
                List<AdmTempData2> utmeids = new ArrayList();
                // utmeids.add(new
                // AdmTempData2(this.getUtmesubjects(settings.utmeEngId).getName(),
                // apputme.getEngScore()));
                List<AdmTempData2> utmeLoaded = new ArrayList();
                List<Olevelresultsitems> olri = this.getOlevelresultsItems(olr.getId());
                for (Olevelresultsitems items : olri) {
                    // for (Olevelresultsitems items : olr.getOlevelresultsitemsCollection()) {
                    utmeLoaded.add(new AdmTempData2(items.getSubject(), items.getGrade().getId(),
                            items.getGrade().getScore()));
                }

                Iterator<AdmTempData2> iterator = utmeLoaded.iterator();
                while (iterator.hasNext()) {
                    AdmTempData2 sub = iterator.next();
                    boolean matched = false;

                    for (Admissiontemplateolevel comp : listoc) {
                        if (comp.getOlevelSubject() != null && comp.getOlevelSubject().getName() != null
                                && comp.getOlevelSubject().getName().trim().equalsIgnoreCase(sub.getSubj().trim())) {
                            utmeids.add(sub);
                            iterator.remove(); // Safely remove while iterating
                            matched = true;
                            break;
                        }
                    }
                    if (matched) {
                        // Move on to the next `AdmTempData` after a match
                        continue;
                    }
                }

                if (utmeids.size() < 5) {

                    if (listoc.size() > (utmeids.size())) {
                        rm = "";
                        int diff = listoc.size() - utmeids.size();
                        for (int i = 0; i < diff; i++) {
                            utmeids.add(new AdmTempData2(" ", " ", 0));
                        }
                    }

                    utmeLoaded.sort((r1, r2) -> Integer.compare(r2.getScore(), r1.getScore()));

                    int max = adm.getOtherSubjects();
                    int it = 0;
                    Iterator<AdmTempData2> iterator2 = utmeLoaded.iterator();
                    while (iterator2.hasNext() && it < max) {
                        AdmTempData2 dat = iterator2.next();
                        try {
                            boolean exists = listoo.stream()
                                    .filter(data -> data.getOlevelSubject() != null
                                    && data.getOlevelSubject().getName() != null)
                                    .anyMatch(data -> data.getOlevelSubject().getName().equals(dat.getSubj()));

                            if (exists) {
                                utmeids.add(dat);
                                iterator2.remove(); // Safe way to remove an element while iterating
                                it++;
                            }
                        } catch (Exception k) {
                        }
                    }
                    if (max > utmeids.size()) {
                        rm = "Wrong OL combination ";
                        int diff = max - utmeids.size();
                        for (int i = 0; i < diff; i++) {
                            utmeids.add(new AdmTempData2(" ", " ", 0));
                        }
                    }
                    for (AdmTempData2 dat : utmeLoaded) {
                        rm += (dat.getSubj() + " (" + dat.getGrade() + ") ");
                    }
                }
                utmeids.sort(Comparator.comparingInt((AdmTempData2 r) -> {
                    if (r.getSubj().equalsIgnoreCase(this.getOlevelsubjects(settings.olEngId).getName())) {
                        return 0;
                    }
                    if (r.getSubj().equalsIgnoreCase(this.getOlevelsubjects(settings.olMathId).getName())) {
                        return 1;
                    }
                    return 2;
                }).thenComparing(AdmTempData2::getSubj));

                det = new AdmTempOLDet();
                det.setEng(utmeids.get(0).getScore());
                det.setEngGrade(utmeids.get(0).getGrade());
                det.setMath(utmeids.get(1).getScore());
                det.setMathGrade(utmeids.get(1).getGrade());
                det.setRemarks(rm);
                det.setSubj3(utmeids.get(2).getSubj());
                det.setSubj3Grade(utmeids.get(2).getGrade());
                det.setSubj3Point(utmeids.get(2).getScore());
                det.setSubj4(utmeids.get(3).getSubj());
                det.setSubj4Grade(utmeids.get(3).getGrade());
                det.setSubj4Point(utmeids.get(3).getScore());
                det.setSubj5(utmeids.get(4).getSubj());
                det.setSubj5Grade(utmeids.get(4).getGrade());
                det.setSubj5Point(utmeids.get(4).getScore());
                int sit = 2;
                try {
                    sit = Integer.parseInt(olr.getSitting());
                } catch (NumberFormatException k) {
                }
                det.setSittings(sit);
                int total = 0;

                for (AdmTempData2 dd : utmeids) {
                    total += dd.getScore();
                }
                det.setTotaPoints(total);
            }
        } catch (Exception k) {
        }
        return det;

    }

    public AdmTempUTMEDet getAdmTempUTMEDet(Admissiontemplate adm, Applicants app) {
        AdmTempUTMEDet det = null;
        try {
            List<Admissiontemplateutme> admtlU = getAdmissiontemplateutme(adm.getId());
            List<Admissiontemplateutme> listocU = (List<Admissiontemplateutme>) admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("C")).collect(Collectors.toList());
            List<Admissiontemplateutme> listooU = (List<Admissiontemplateutme>) admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("O")).collect(Collectors.toList());
            String rm = "";
            Applicantsutme apputme = app.getApplicantsutme();
            List<AdmTempData> utmeids = new ArrayList<>();
            utmeids.add(new AdmTempData(getUtmesubjects(this.settings.utmeEngId).getName(), apputme.getEngScore().intValue()));
            List<AdmTempData> utmeLoaded = new ArrayList<>();
            utmeLoaded.add(new AdmTempData(apputme.getSubj2(), apputme.getSubj2Score().intValue()));
            utmeLoaded.add(new AdmTempData(apputme.getSubj3(), apputme.getSubj3Score().intValue()));
            utmeLoaded.add(new AdmTempData(apputme.getSubj4(), apputme.getSubj4Score().intValue()));
            Iterator<AdmTempData> iterator = utmeLoaded.iterator();
            while (iterator.hasNext()) {
                AdmTempData sub = iterator.next();
                boolean matched = false;
                for (Admissiontemplateutme comp : listocU) {
                    if (comp.getUtmesubjects() != null && comp.getUtmesubjects().getName() != null && comp
                            .getUtmesubjects().getName().trim().equalsIgnoreCase(sub.getSubj().trim())) {
                        utmeids.add(sub);
                        iterator.remove();
                        matched = true;
                        break;
                    }
                }
                if (matched);
            }
            if (utmeids.size() < 4) {
                if (listocU.size() > utmeids.size() + 1) {
                    rm = "";
                    int diff = listocU.size() - utmeids.size();
                    for (int i = 0; i < diff; i++) {
                        utmeids.add(new AdmTempData(" ", 0));
                    }
                }
                utmeLoaded.sort((r1, r2) -> Integer.compare(r2.getScore(), r1.getScore()));
                int max = adm.getOtherUtme().intValue();
                int it = 0;
                Iterator<AdmTempData> iterator2 = utmeLoaded.iterator();
                while (iterator2.hasNext() && it < max) {
                    AdmTempData dat = iterator2.next();
                    try {
                        boolean exists = listooU.stream().filter(data -> (data.getUtmesubjects() != null && data.getUtmesubjects().getName() != null)).anyMatch(data -> data.getUtmesubjects().getName().equals(dat.getSubj()));
                        if (exists) {
                            utmeids.add(dat);
                            iterator2.remove();
                            it++;
                        }
                    } catch (Exception exception) {
                    }
                }
                if (max > utmeids.size()) {
                    rm = "Wrong UTME Subjects combination ";
                    int diff = max - utmeids.size();
                    for (int i = 0; i < diff; i++) {
                        utmeids.add(new AdmTempData(" ", 0));
                    }
                }
                for (AdmTempData dat : utmeLoaded) {
                    rm = rm + rm + " (" + dat.getSubj() + ") ";
                }
            }
            det = new AdmTempUTMEDet();
            det.setEng(((AdmTempData) utmeids.get(0)).getScore());
            det.setRemarks(rm);
            try {
                det.setSubj2(((AdmTempData) utmeids.get(1)).getSubj());
                det.setSubj2Score(((AdmTempData) utmeids.get(1)).getScore());
            } catch (Exception exception) {
            }
            try {
                det.setSubj3(((AdmTempData) utmeids.get(2)).getSubj());
                det.setSubj3Score(((AdmTempData) utmeids.get(2)).getScore());
            } catch (Exception exception) {
            }
            try {
                det.setSubj4(((AdmTempData) utmeids.get(3)).getSubj());
                det.setSubj4Score(((AdmTempData) utmeids.get(3)).getScore());
            } catch (Exception exception) {
            }
            int total = 0;
            for (AdmTempData dd : utmeids) {
                total += dd.getScore();
            }
            det.setUtmeremitscore(total);
            det.setTotalUtme(apputme.getTotalUtme().intValue());
        } catch (Exception exception) {
        }
        return det;
    }

    public List<Semesterregistrationcourses> getSemesterRegistrationCourses(String coscode, String level, String semester, String status) {
        List<Semesterregistrationcourses> alist = new ArrayList<>();
        try {
            alist = this.em.createQuery("SELECT s FROM Semesterregistrationcourses s WHERE s.courseId.id = :courseid AND s.level = :level AND s.semester = :semester AND s.courseStatus = :status ORDER BY s.courseType ASC, s.semesterCourseId.code ASC").setParameter("courseid", coscode).setParameter("level", level).setParameter("semester", semester).setParameter("status", status).getResultList();
        } catch (Exception ex) {
            System.out.println("ERROR in getSemesterRegistrationCourses: " + ex.getMessage());
            ex.printStackTrace();
        }
        return alist;
    }

    public List<Semesterregistration> getCarryoversByStudentsAndSemester(String regno, String semester) {
        List<Semesterregistration> ali2 = new ArrayList<>();
        try {
            List<Semesterregistration> ali = this.em.createQuery("SELECT s FROM Semesterregistration s WHERE s.studentId.id = :registrationno AND s.semester = :semester AND s.passStatus = '1' ORDER BY s.session DESC").setParameter("registrationno", regno).setParameter("semester", semester).getResultList();
            for (Semesterregistration de : ali) {
                if (!COExist(ali2, de.getSemesterRegistrationCourseId().getId())) {
                    ali2.add(de);
                }
            }
        } catch (Exception exception) {
        }
        return ali2;
    }

    public List<Roles> getRolesByType(String type) {
        List<Roles> ali2 = new ArrayList<>();
        try {
            if (type.equalsIgnoreCase("ALL")) {
                ali2 = this.em.createQuery("SELECT s FROM Roles s ORDER BY s.name ASC").getResultList();
            } else {
                ali2 = this.em.createQuery("SELECT s FROM Roles s WHERE s.roleType = :type ORDER BY s.name ASC").setParameter("type", type).getResultList();
            }
        } catch (Exception exception) {
        }
        return ali2;
    }

    public boolean COExist(List<Semesterregistration> ali2, String courseid) {
        boolean exist = false;
        try {
            for (Semesterregistration de : ali2) {
                if (de.getSemesterRegistrationCourseId().getId().equalsIgnoreCase(courseid)) {
                    exist = true;
                    break;
                }
            }
        } catch (Exception exception) {
        }
        return exist;
    }

    public void resetSemesterRegistration(String stdid, String semester, String session) {
        try {
            List<Semesterregistration> list = getSemesterRegistrationByStudentsSessionAndSemester(stdid, session, semester);
            for (Semesterregistration dd : list) {
                deleteSemesterregistration(dd.getId());
            }
        } catch (Exception exception) {
        }
    }

    public List<Semesterregistration> getSemesterRegistrationByStudentsSessionAndSemester(String regno, String session, String semester) {
        List<Semesterregistration> ali = new ArrayList<>();
        try {
            this.em.clear();
            ali = new ArrayList<>(new LinkedHashSet<>(this.em.createQuery("SELECT s FROM Semesterregistration s JOIN FETCH s.semesterRegistrationCourseId JOIN FETCH s.studentId WHERE s.studentId.id = :regno AND s.session = :session AND s.semester = :semester ORDER BY s.semesterRegistrationCourseId.semesterCourseId.name ASC", Semesterregistration.class).setParameter("regno", regno).setParameter("session", session).setParameter("semester", semester).getResultList()));
        } catch (Exception exception) {
        }
        return ali;
    }

    public boolean checkSemesterregistration(String stdid, String courseid, String session) {
        boolean exist = false;
        String sm = null;
        try {
            sm = (String) this.em.createQuery("SELECT s.id FROM Semesterregistration s WHERE s.studentId.id = :stdid AND s.semesterRegistrationCourseId.id = :courseid AND s.session = :session").setParameter("stdid", stdid).setParameter("courseid", courseid).setParameter("session", session).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        if (sm != null) {
            exist = true;
        }
        return exist;
    }

    public Semesterregistrationcucontrol getSemesterregistrationcucontrol(String courseid, String level, String semester) {
        Semesterregistrationcucontrol det = null;
        try {
            det = (Semesterregistrationcucontrol) this.em.createQuery("SELECT s FROM Semesterregistrationcucontrol s WHERE s.courseId.id = :courseid AND s.level = :level AND s.semester = :semester").setParameter("courseid", courseid).setParameter("level", level).setParameter("semester", semester).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return det;
    }

    public List<Semesterregistrationcucontrol> getSemesterregistrationcucontrolByCourse(String courseid) {
        List<Semesterregistrationcucontrol> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Semesterregistrationcucontrol s WHERE s.courseId.id = :courseid ORDER BY s.level, s.semester").setParameter("courseid", courseid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Students> updateStudentsProgressionAll() {
        List<Students> stdl = new ArrayList<>();
        try {
            stdl = this.em.createQuery("SELECT s FROM Students s where s.addedBy IS NULL order by s.currentClass ASC").setMaxResults(500).getResultList();
            for (Students std : stdl) {
                updateStudentProgression(std);
            }
        } catch (Exception exception) {
        }
        return stdl;
    }

    @Transactional(Transactional.TxType.MANDATORY)
    public void updateStudentProgression2(Students std) {
        try {
            String sessadm = std.getSessionAdmitted();
            String currclass = std.getCurrentClass();
            int maxclass = std.getCourseId().getDefaultMaxLevel().intValue();
            Sessionmanager sessman = getCurrentSessionManagerBySchoolAndOperation(std
                    .getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
            if (sessman != null) {
                String currsess = sessman.getName();
                String currsem = sessman.getSemester();
                Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
                Studentprogression exist = null;
                int nospill = 0;
                try {
                    for (Studentprogression person : prograssion) {
                        if (person.getSessionAdded().equals(currsess) && person.getSemesterAdded().equals(currsem)) {
                            exist = person;
                        }
                        if (person.getLevelAdded().equals("" + maxclass) && person.getSemesterAdded().equals("First")) {
                            nospill++;
                        }
                    }
                } catch (Exception exception) {
                }
                if (exist == null) {
                    String idd = currsess.split("/")[0] + currsess.split("/")[0] + std.getId();
                    Studentprogression proggSecond = new Studentprogression(idd);
                    proggSecond.setCourseId(std.getCourseId());
                    proggSecond.setDateAdded(this.settings.getCurrentDateTime());
                    proggSecond.setLevelAdded(currclass);
                    proggSecond.setRegistrationStatus("0");
                    proggSecond.setSemesterAdded(currsem);
                    proggSecond.setSessionAdded(currsess);
                    proggSecond.setStatus(std.getMatricNo());
                    proggSecond.setStudentsId(std);
                    if (currsem.equalsIgnoreCase("First")) {
                        int maxspill = 1;
                        int currclassi = 100;
                        try {
                            maxspill = std.getCourseId().getDefaultMaxSpill().intValue();
                            maxspill /= 2;
                            currclassi = Integer.parseInt(currclass);
                        } catch (NumberFormatException numberFormatException) {
                        }
                        String othernames = std.getOthernames();
                        if (othernames == null) {
                            othernames = " ";
                        }
                        int nextClass = currclassi + 100;
                        if (nextClass > maxclass && nospill >= maxspill) {
                            std.setExitComment("Auto suspension. Exhausted maximum spillover levels");
                            std.setExitType("SUSPENDED");
                            std.setAddedBy(getUsers("s202410469"));
                            std.setOthernames(othernames);
                            std.setSessionExited(currsess);
                            std.setDateAdded(this.settings.getCurrentDateTime());
                            this.em.merge(std);
                        } else {
                            try {
                                std.setAddedBy(getUsers("s202410469"));
                                std.setOthernames(othernames);
                                std.setDateAdded(this.settings.getCurrentDateTime());
                                std.setCurrentClass("" + nextClass);
                                this.em.merge(std);
                                proggSecond.setLevelAdded("" + nextClass);
                                this.em.persist(proggSecond);
                            } catch (Exception exception) {
                            }
                        }
                    } else {
                        this.em.persist(proggSecond);
                    }
                }
            }
        } catch (Exception k) {
            throw new RuntimeException("Error updating student progression: " + k.getMessage(), k);
        }
    }

    public void updateStudentProgression(Students std) {
        try {
            String sessadm = std.getSessionAdmitted();
            String classadm = std.getClassAdmitted();
            Sessionmanager sessman = getCurrentSessionManagerBySchoolAndOperation(std
                    .getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
            if (sessman != null) {
                String currsess = sessman.getName();
                String currsem = sessman.getSemester();
                String tmpsess = sessadm;
                Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
                int cadm = std.getCourseId().getDefaultMinLevel().intValue();
                if (std.getModeOfEntry().equalsIgnoreCase("DE")) {
                    cadm = 200;
                }
                int maxclass = std.getCourseId().getDefaultMaxLevel().intValue();
                int maxspill = 1;
                int i1 = 100;
                int i2 = 0;
                try {
                    cadm = Integer.parseInt(classadm);
                    maxclass = std.getCourseId().getDefaultMaxLevel().intValue();
                    maxspill = std.getCourseId().getDefaultMaxSpill().intValue();
                    maxspill /= 2;
                } catch (NumberFormatException numberFormatException) {
                }
                while (tmpsess.compareToIgnoreCase(currsess) <= 0 && i2 <= maxspill) {
                    if (!tmpsess.equalsIgnoreCase("2021/2022")) {
                        if (i1 <= maxclass) {
                            Studentprogression proggFirst = null;
                            try {
                                for (Studentprogression person : prograssion) {
                                    if (person.getSessionAdded().equals(tmpsess) && person
                                            .getSemesterAdded().equals("First")) {
                                        proggFirst = person;
                                        break;
                                    }
                                }
                            } catch (Exception exception) {
                            }
                            if (proggFirst == null) {
                                String idd = tmpsess.split("/")[0] + tmpsess.split("/")[0] + std.getId();
                                proggFirst = new Studentprogression(idd);
                                proggFirst.setCourseId(std.getCourseId());
                                proggFirst.setDateAdded(this.settings.getCurrentDateTime());
                                proggFirst.setLevelAdded("" + cadm);
                                proggFirst.setRegistrationStatus("0");
                                proggFirst.setSemesterAdded("First");
                                proggFirst.setSessionAdded(tmpsess);
                                proggFirst.setStatus(std.getMatricNo());
                                proggFirst.setStudentsId(std);
                                newEntry(proggFirst);
                            }
                            Studentprogression proggSecond = null;
                            try {
                                for (Studentprogression person : prograssion) {
                                    if (person.getSessionAdded().equals(tmpsess) && person
                                            .getSemesterAdded().equals("Second")) {
                                        proggSecond = person;
                                        break;
                                    }
                                }
                            } catch (Exception exception) {
                            }
                            if (proggSecond == null) {
                                String idd = tmpsess.split("/")[0] + tmpsess.split("/")[0] + std.getId();
                                proggSecond = new Studentprogression(idd);
                                proggSecond.setCourseId(std.getCourseId());
                                proggSecond.setDateAdded(this.settings.getCurrentDateTime());
                                proggSecond.setLevelAdded("" + cadm);
                                proggSecond.setRegistrationStatus("0");
                                proggSecond.setSemesterAdded("Second");
                                proggSecond.setSessionAdded(tmpsess);
                                proggSecond.setStatus(std.getMatricNo());
                                proggSecond.setStudentsId(std);
                                newEntry(proggSecond);
                            }
                            if (i1 < maxclass) {
                                cadm += 100;
                                i1 += 100;
                            } else {
                                i2++;
                            }
                        } else {
                            break;
                        }
                    }
                    tmpsess = this.settings.getSessionAfter(tmpsess);
                }
                Students ddx = getStudentsById(std.getId());
                if (ddx != null) {
                    String othernames = ddx.getOthernames();
                    if (othernames == null) {
                        othernames = " ";
                    }
                    if (i2 > maxspill) {
                        ddx.setExitComment("Auto suspension. Exhausted maximum spillover levels");
                        ddx.setExitType("SUSPENDED");
                        ddx.setAddedBy(getUsers("s202410469"));
                        ddx.setOthernames(othernames);
                        ddx.setSessionExited(tmpsess);
                        ddx.setDateAdded(this.settings.getCurrentDateTime());
                        updateStudent(ddx);
                    } else {
                        try {
                            ddx.setAddedBy(getUsers("s202410469"));
                            ddx.setOthernames(othernames);
                            ddx.setDateAdded(this.settings.getCurrentDateTime());
                            updateStudent(ddx);
                        } catch (Exception exception) {
                        }
                    }
                }
            }
        } catch (Exception exception) {
        }
    }

    public Studentprogression getMaxStudentprogressionForStudent(String stdid) {
        Studentprogression sessmsnsger = null;
        try {
            sessmsnsger = (Studentprogression) this.em.createQuery("SELECT p FROM Studentprogression p WHERE p.studentsId.id = :stdid ORDER BY p.sessionAdded DESC").setParameter("stdid", stdid).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return sessmsnsger;
    }

    @Transactional
    public void updateStudent(Students obj) {
        try {
            this.em.createQuery("UPDATE Students p SET p.addedBy = :a, p.dateAdded = :b, p.exitType = :c, p.othernames = :d, p.exitComment = :e, p.sessionExited = :f, p.currentClass = :g WHERE p.id = :id")
                    .setParameter("a", obj.getAddedBy())
                    .setParameter("b", obj.getDateAdded())
                    .setParameter("c", obj.getExitType())
                    .setParameter("d", obj.getOthernames())
                    .setParameter("e", obj.getExitComment())
                    .setParameter("f", obj.getSessionExited())
                    .setParameter("g", obj.getCurrentClass())
                    .setParameter("id", obj.getId())
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating student information", e);
        }
    }

    @Transactional
    public void updateSemesterCourseStatus(String courseid, String status) {
        try {
            this.em.createQuery("UPDATE Semestercourses p SET p.status = :a WHERE p.id = :id")
                    .setParameter("a", status)
                    .setParameter("id", courseid)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating SemesterCourse status", e);
        }
    }

    @Transactional
    public void updateSemestercourse(String courseId, String name, String code, String semester, String defaultLevel, Integer creditUnit, String note, String semestercourseCategory) {
        try {
            this.em.createQuery("UPDATE Semestercourses p SET p.name = :name, p.code = :code, p.semester = :semester, p.defaultLevel = :defaultLevel, p.creditUnit = :creditUnit, p.note = :note, p.semestercourseCategory = :category WHERE p.id = :id")
                    .setParameter("name", name)
                    .setParameter("code", code)
                    .setParameter("semester", semester)
                    .setParameter("defaultLevel", defaultLevel)
                    .setParameter("creditUnit", creditUnit)
                    .setParameter("note", note)
                    .setParameter("category", semestercourseCategory)
                    .setParameter("id", courseId)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Semestercourse", e);
        }
    }

    @Transactional
    public void updateSemesterregistrationcucontrol(String id, Integer mi, Integer ma) {
        try {
            this.em.createQuery("UPDATE Semesterregistrationcucontrol p SET p.maxcu = :a, p.mincu = :b WHERE p.id = :id")
                    .setParameter("a", ma)
                    .setParameter("b", mi)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Semesterregistrationcucontrol", e);
        }
    }

    @Transactional
    public void updateSemesterregistrationcoursesStatus(String srcid, String status) {
        try {
            this.em.createQuery("UPDATE Semesterregistrationcourses p SET p.courseStatus = :a WHERE p.id = :id")
                    .setParameter("a", status)
                    .setParameter("id", srcid)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Semesterregistrationcourses status", e);
        }
    }

    @Transactional
    public void registerSemesterCourses(Studentprogression sp, List<String> courseids) {
        try {
            System.out.println("=== REGISTER SEMESTER COURSES DEBUG ===");
            System.out.println("Student: " + sp.getStudentsId().getId());
            System.out.println("Course IDs to register: " + courseids.size());
            for (String id : courseids) {
                System.out.println("  Course ID: " + id);
            }
            System.out.println("Current StudentProgression status: " + sp.getRegistrationStatus());
            resetSemesterRegistration(sp.getStudentsId().getId(), sp.getSemesterAdded(), sp.getSessionAdded());
            System.out.println("Reset previous registrations");
            int registeredCount = 0;
            for (String dx : courseids) {
                Semesterregistrationcourses smc = (Semesterregistrationcourses) getSingleObject(Semesterregistrationcourses.class, dx);
                if (smc != null) {
                    String idy = sp.getStudentsId().getId() + sp.getStudentsId().getId() + this.settings.getTodaysdate().split("-")[0];
                    Semesterregistration smr = new Semesterregistration(idy);
                    smr.setCreditUnit(smc.getCreditUnit());
                    smr.setDateRegistered(this.settings.getCurrentDateTime());
                    smr.setLevel(sp.getLevelAdded());
                    smr.setRegistrationStatus("REGISTERED");
                    smr.setSemester(sp.getSemesterAdded());
                    smr.setSemesterRegistrationCourseId(smc);
                    smr.setSession(sp.getSessionAdded());
                    smr.setStudentId(sp.getStudentsId());
                    this.em.persist(smr);
                    registeredCount++;
                    System.out.println("  Registered: " + smc.getSemesterCourseId().getCode() + " (" + smc
                            .getCreditUnit() + " CU)");
                    continue;
                }
                System.out.println("  ERROR: Could not find Semesterregistrationcourses with ID: " + dx);
            }
            try {
                Studentprogression smr = (Studentprogression) this.em.find(Studentprogression.class, sp.getId());
                if (smr != null) {
                    System.out.println("Updating StudentProgression status from " + smr
                            .getRegistrationStatus() + " to 1");
                    smr.setDateRegistered(this.settings.getCurrentDateTime());
                    smr.setRegistrationStatus("1");
                    this.em.merge(smr);
                    System.out.println("StudentProgression updated successfully");
                } else {
                    System.out.println("ERROR: Could not find StudentProgression with ID: " + sp.getId());
                }
            } catch (Exception k) {
                System.out.println("ERROR updating StudentProgression: " + k.getMessage());
                k.printStackTrace();
            }
            System.out.println("Registration completed: " + registeredCount + " courses registered");
            System.out.println("=== END REGISTER SEMESTER COURSES DEBUG ===");
        } catch (Exception e) {
            System.out.println("ERROR in registerSemesterCourses: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error updating record", e);
        }
    }

    public PaymentreferenceDetail createApplicantsPayments(String regno, String fgi, String session, String sem) {
        PaymentreferenceDetail prd = new PaymentreferenceDetail();
        prd.setPayref("");
        prd.setRefdescription("");
        try {
            Applicants std = getApplicants(regno.toLowerCase());
            Feesgroup fg = (Feesgroup) getSingleObject(Feesgroup.class, fgi);
            if (std != null && fgi != null) {
                regno = std.getId();
                String level = "None";
                String ind = "None";
                String campus = "None";
                String email = std.getEmailAddress();
                Date dfrom = this.settings.getCurrentDateTime();
                Courses co = std.getCourse1();
                Admissions adm = getAdmissions(std.getId());
                if (adm != null) {
                    co = adm.getCourseId();
                }
                Feesgroup fg2 = getFeesgroupByNameAndSchool(fg.getName(), co
                        .getSchoolProgrammeId().getSchoolId().getId());
                if (fg2 != null) {
                    fg = fg2;
                }
                PaymentreferenceDetail det = createPaymentReference2(co
                        .getSchoolProgrammeId().getSchoolId().getId(), "" + co
                                .getSchoolProgrammeId().getProgrammeId().getId(), co
                                .getDepartmentId().getFacultyId().getId(), co.getDepartmentId().getId(), co
                        .getId(), level, ind, campus, dfrom, regno, std.getSurname() + " " + std.getSurname(), std
                        .getPhoneNo(), email, fgi, session, sem);
                prd = det;
            } else {
                prd.setRefdescription("Applicant number " + regno + " is not found or Fees item not found");
            }
        } catch (Exception exception) {
        }
        return prd;
    }

    public PaymentreferenceDetail createStudentsPayments(String regno, String fgi, String session, String sem) {
        PaymentreferenceDetail prd = new PaymentreferenceDetail();
        prd.setPayref("");
        prd.setRefdescription("");
        try {
            Students std = getStudentsById(regno.toLowerCase());
            Feesgroup fg = (Feesgroup) getSingleObject(Feesgroup.class, fgi);
            if (std != null && fgi != null) {
                regno = std.getId();
                String level = "None";
                String ind = "non_indigene";
                String campus = "None";
                String email = (std.getUniversityEmail() != null) ? std.getUniversityEmail() : std.getPersonalEmail();
                Date dfrom = this.settings.getCurrentDateTime();
                Collection<Studentprogression> cl2 = std.getStudentprogressionCollection();
                for (Studentprogression sp : cl2) {
                    if (sp.getSessionAdded().equalsIgnoreCase(session)) {
                        level = sp.getLevelAdded();
                        break;
                    }
                }
                if (std.getStateOfOrigin() != null && std.getStateOfOrigin().getId().intValue() == this.settings.indigeneStateCode) {
                    ind = "indigene";
                }
                PaymentreferenceDetail det = createPaymentReference2(std
                        .getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "" + std
                                .getCourseId().getSchoolProgrammeId().getProgrammeId().getId(), std
                                .getCourseId().getDepartmentId().getFacultyId().getId(), std
                                .getCourseId().getDepartmentId().getId(), std
                                .getCourseId().getId(), level, ind, campus, dfrom, regno, std
                                .getSurname() + " " + std.getSurname(), std.getPhoneNo(), email, fgi, session, sem);
                prd = det;
            } else {
                prd.setRefdescription("Students number " + regno + " is not found or Fees item not found");
            }
        } catch (Exception exception) {
        }
        return prd;
    }

    public PaymentreferenceDetail createSchoolFeesPayments(String regno, String session, String sem) {
        PaymentreferenceDetail prd = new PaymentreferenceDetail();
        prd.setPayref("");
        prd.setRefdescription("");
        try {
            Students std = getStudentsById(regno.toLowerCase());
            if (std != null) {
                regno = std.getId();
                String level = "None";
                String ind = "non_indigene";
                String campus = "None";
                String email = (std.getUniversityEmail() != null) ? std.getUniversityEmail() : std.getPersonalEmail();
                Date dfrom = this.settings.getCurrentDateTime();
                Collection<Studentprogression> cl2 = std.getStudentprogressionCollection();
                for (Studentprogression sp : cl2) {
                    if (sp.getSessionAdded().equalsIgnoreCase(session)) {
                        level = sp.getLevelAdded();
                        break;
                    }
                }
                if (std.getStateOfOrigin() != null && std.getStateOfOrigin().getId().intValue() == this.settings.indigeneStateCode) {
                    ind = "indigene";
                }
                String fgi = "";
                Feesgroup gfg = getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                if (gfg != null) {
                    fgi = gfg.getId();
                }
                PaymentreferenceDetail det = createPaymentReference2(std
                        .getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "" + std
                                .getCourseId().getSchoolProgrammeId().getProgrammeId().getId(), std
                                .getCourseId().getDepartmentId().getFacultyId().getId(), std
                                .getCourseId().getDepartmentId().getId(), std
                                .getCourseId().getId(), level, ind, campus, dfrom, regno, std
                                .getSurname() + " " + std.getSurname(), std.getPhoneNo(), email, fgi, session, sem);
                prd = det;
            } else {
                prd.setRefdescription("Students number " + regno + " is not found");
            }
        } catch (Exception exception) {
        }
        return prd;
    }

    public PaymentreferenceDetail createPaymentReference2(String schid, String prog, String fac, String dept, String course, String level, String ind, String campus, Date dfrom, String regno, String fullname, String phoneno, String email, String feesgroup, String sessions, String sem) {
        PaymentreferenceDetail prd = new PaymentreferenceDetail();
        prd.setPayref("");
        prd.setRefdescription("");
        List<Feessetup> feessetup = getFeessetup(feesgroup, sessions, sem, schid, prog, fac, dept, course, level, ind, campus, dfrom, regno);
        if (!feessetup.isEmpty()) {
            String fgx = ((Feessetup) feessetup.get(0)).getFeesGroupId().getRepeatPayment();
            boolean exist = false;
            if (fgx.equalsIgnoreCase("No")) {
                List<Payments> payl = getPaymentsByRegnoSessSemFeesgroup(regno, feesgroup, sessions, sem);
                if (!payl.isEmpty()) {
                    exist = true;
                }
            }
            if (exist) {
                prd.setRefdescription("This payment has been processed. Kindly select another session, level or semester");
            } else {
                double total = feessetup.stream().mapToDouble(Feessetup::getAmount).sum();
                Feesgroup feesGroupId = ((Feessetup) feessetup.get(0)).getFeesGroupId();
                String id = this.settings.generateId(this.settings.getTodaysdate().replaceAll("-", ""), 14);
                Paymentreference pr = new Paymentreference(id, total, regno, this.settings.getCurrentDateTime(), "PENDING", null, sessions, sem, "", "", "", "", fullname, phoneno, email, "", feesGroupId, getSchools(schid));
                pr.setPayerRegistrationIo(regno);
                pr.setCourseId(course);
                pr.setLevel(level);
                newEntry(pr);
                prd.setPayref(id);
                prd.setRefdescription("SUCCESS");
            }
        } else {
            prd.setRefdescription("No fees setup for this category of payment. Kindly check back later");
        }
        return prd;
    }

    public boolean checkPaymentNotification(String PaymentLogId, String Amount, String PaymentCustReference, String PaymentReference, boolean bitReversal) {
        boolean ok = false;
        try {
            String transid = PaymentLogId + PaymentLogId;
            Paymentnotification pn = (Paymentnotification) getSingleObject(Paymentnotification.class, transid);
            ok = (pn != null);
        } catch (Exception exception) {
        }
        return ok;
    }

    public void addToPayment(String id, double amount, String payerId, String payerRegno, String fullname, String session, String semester, String courseId, String feesGroup, String level, String bankid) {
        Payments pay = getPayments(id);
        if (pay == null)
      try {
            pay = new Payments(id);
            pay.setAmount(amount);
            pay.setDatePaid(this.settings.getCurrentDateTime());
            pay.setPayerId(payerId);
            pay.setPayerRegistrationNo(payerRegno);
            pay.setPayerFullname(fullname);
            pay.setSessionPaid(session);
            pay.setSemesterPaid(semester);
            Courses co = null;
            Programmes prog = null;
            Feesgroup fg = null;
            Schools sch = null;
            Banks bank = null;
            try {
                co = getCourses(courseId);
                if (co != null) {
                    prog = co.getSchoolProgrammeId().getProgrammeId();
                    sch = co.getSchoolProgrammeId().getSchoolId();
                }
                bank = (Banks) getSingleObject(Banks.class, bankid);
                fg = (Feesgroup) getSingleObject(Feesgroup.class, feesGroup);
            } catch (Exception exception) {
            }
            pay.setCourseId(co);
            pay.setFeesGroupId(fg);
            pay.setProgrammeId(prog);
            pay.setSchoolId(sch);
            pay.setLevel(level);
            pay.setBankId(bank);
            newEntry(pay);
            if (id.startsWith("PR")) {
                this.settings.postPaymentStatus(id, true);
            }
            // COMMENTED OUT: Acceptance Letter payment check before generating admission letter
            // Re-enable this block to require acceptance letter payment before granting access
            /*
            Feesgroup accep = getFeesgroupByNameAndSchool(this.settings.acceptanceLetter, sch.getId());
            if (pay.getFeesGroupId().getId().equals(accep.getId())) {
                List<Payments> pay1 = getPaymentsByRegnoSessSemFeesgroup(pay.getPayerId(), pay
                        .getFeesGroupId().getId(), pay.getSessionPaid(), "Session");
                if (pay1.size() > 0 && (sch.getId().equalsIgnoreCase("S001") || sch.getId().equalsIgnoreCase("S003") || sch
                        .getId().equalsIgnoreCase("S006"))) {
                    generateAdmissionLetter(pay.getPayerId(), "s202410818");
                }
            }
            */
            if (pay.getFeesGroupId().getId().equalsIgnoreCase("10160")) {
                Hostelapplication app = getHostelapplication(pay.getPayerId(), pay.getSessionPaid());
                if (app != null
                        && app.getApplicationStatus().equalsIgnoreCase("PENDING")) {
                    reserveRoom(app.getId());
                }
            }
            if (pay.getFeesGroupId().getId().equalsIgnoreCase("10155")) {
                Hostelapplication app = getHostelapplication(pay.getPayerId(), pay.getSessionPaid());
                if (app != null
                        && app.getApplicationStatus().equalsIgnoreCase("RESERVED")) {
                    allocateRoom(app.getId());
                }
            }
        } catch (Exception exception) {
        }
    }

    public List<Paymentreference> updatePayments() {
        List<Paymentreference> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Paymentreference u WHERE u.paidStatus = 'SUCCESSFUL'").setMaxResults(1000).getResultList();
            for (Paymentreference dd : list) {
                try {
                    addToPayment(dd.getId(), dd.getAmount(), dd.getPayerId(), dd.getPayerRegistrationIo(), dd
                            .getPayerName(), dd.getSession(), dd.getSemester(), dd.getCourseId(), dd
                            .getFeesGroupId().getId(), dd
                                    .getLevel(), dd.getBankCode());
                    updatePaymentreference(dd.getId(), dd.getResponseText(), dd.getPaymentRef(), dd.getBankCode(), dd
                            .getBankCode(), this.settings.getCurrentDateTime(), "PAID");
                } catch (Exception exception) {
                }
            }
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Applicantsreferees> getApplicantsrefereesByRegno(String regno) {
        List<Applicantsreferees> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT a FROM Applicantsreferees a WHERE a.applicantsId.id = :regno").setParameter("regno", regno).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Uploadeddocuments> getUploadeddocumentsByRegno(String regno) {
        List<Uploadeddocuments> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Uploadeddocuments u WHERE u.groupId = :regno ORDER BY u.dateAdded DESC").setParameter("regno", regno).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Schoolsattended> getSchoolsattendedByRegno(String regno) {
        List<Schoolsattended> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Schoolsattended u WHERE u.appId = :regno ORDER BY u.startDate DESC").setParameter("regno", regno).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Users> getUsersByRole(String roleid) {
        Integer in = Integer.valueOf(0);
        try {
            in = Integer.valueOf(roleid);
        } catch (NumberFormatException numberFormatException) {
        }
        List<Users> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Users u WHERE u.defaultRole.id = :roleid ORDER BY u.username ASC").setParameter("roleid", in).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<UsersDTO> searchUser(String text, String searchfrom) {
        List<UsersDTO> users = new ArrayList<>();
        try {
            text = text.toLowerCase();
            text = "%" + text + "%";
            if (searchfrom.equalsIgnoreCase("Applicant")) {
                List<Applicants> lapp = this.em.createQuery("SELECT a FROM Applicants a WHERE LOWER(a.applicantsutme) LIKE :a OR LOWER(a.emailAddress) LIKE :b OR LOWER(a.othernames) LIKE :c OR LOWER(a.phoneNo) LIKE :d OR LOWER(a.surname) = :e").setParameter("a", text).setParameter("b", text).setParameter("c", text).setParameter("d", text).setParameter("e", text).getResultList();
                for (Applicants ap : lapp) {
                    UsersDTO data = new UsersDTO();
                    Users usd = getUsers(ap.getId());
                    if (usd != null) {
                        data.setEmail(ap.getEmailAddress());
                        data.setFullname(ap.getSurname() + " " + ap.getSurname());
                        data.setIdno(ap.getId());
                        data.setPhoneno(ap.getPhoneNo());
                        data.setRole(usd.getDefaultRole().getName());
                        data.setUsername(usd.getUsername());
                        users.add(data);
                    }
                }
            }
            if (searchfrom.equalsIgnoreCase("Staff")) {
                List<Staff> lapp = this.em.createQuery("SELECT a FROM Staff a WHERE LOWER(a.officialEmailAddress) LIKE :a OR LOWER(a.othernames) LIKE :b OR LOWER(a.phoneNo) LIKE :c OR LOWER(a.staffNo) LIKE :d OR LOWER(a.surname) = :e").setParameter("a", text).setParameter("b", text).setParameter("c", text).setParameter("d", text).setParameter("e", text).getResultList();
                for (Staff ap : lapp) {
                    UsersDTO data = new UsersDTO();
                    Users usd = getUsers(ap.getId());
                    if (usd != null) {
                        data.setEmail(ap.getOfficialEmailAddress());
                        data.setFullname(ap.getSurname() + " " + ap.getSurname());
                        data.setIdno(ap.getStaffNo());
                        data.setPhoneno(ap.getPhoneNo());
                        data.setRole(usd.getDefaultRole().getName());
                        data.setUsername(usd.getUsername());
                        users.add(data);
                    }
                }
            }
            if (searchfrom.equalsIgnoreCase("Student")) {
                List<Students> lapp = this.em.createQuery("SELECT a FROM Students a WHERE LOWER(a.matricNo) LIKE :a OR LOWER(a.othernames) LIKE :b OR LOWER(a.phoneNo) LIKE :c OR LOWER(a.registrationNo) LIKE :d OR LOWER(a.surname) = :e").setParameter("a", text).setParameter("b", text).setParameter("c", text).setParameter("d", text).setParameter("e", text).getResultList();
                for (Students ap : lapp) {
                    UsersDTO data = new UsersDTO();
                    Users usd = getUsers(ap.getId());
                    if (usd != null) {
                        data.setEmail(ap.getUniversityEmail());
                        data.setFullname(ap.getSurname() + " " + ap.getSurname());
                        data.setIdno(ap.getMatricNo() + " (" + ap.getMatricNo() + ")");
                        data.setPhoneno(ap.getPhoneNo());
                        data.setRole(usd.getDefaultRole().getName());
                        data.setUsername(usd.getUsername());
                        users.add(data);
                    }
                }
            }
        } catch (Exception exception) {
        }
        return users;
    }

    public List<Semestercourses> getAllSemestercoursesByStatusAndProgramme(String status, String programme) {
        List<Semestercourses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Semestercourses s WHERE s.status = :status AND s.programmeId.id = :prog").setParameter("status", status).setParameter("prog", Integer.valueOf(programme)).getResultList();
        } catch (NumberFormatException numberFormatException) {
        }
        return list;
    }

    public List<Semestercourses> getSemesterCoursesForSummerReg(String stdid) {
        List<Semestercourses> list = new ArrayList<>();
        Students std = getStudentsById(stdid);
        if (std != null) {
            Sessionmanager sessman = getCurrentSessionManagerBySchoolAndOperation(std
                    .getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
            if (sessman != null) {
                Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
                Studentprogression stdp = null;
                try {
                    Optional<Studentprogression> rego = prograssion.stream().filter(person -> (person.getSessionAdded().equals(sessman.getName()) && person.getSemesterAdded().equals("First"))).findFirst();
                    stdp = rego.get();
                } catch (Exception exception) {
                }
                if (stdp != null) {
                    String lev = stdp.getLevelAdded();
                    try {
                        list = this.em.createQuery("SELECT s FROM Semestercourses s WHERE s.status = 'ACTIVE' AND s.programmeId.id = :prog AND s.defaultLevel <= :lev ORDER BY s.defaultLevel DESC, s.name ASC").setParameter("lev", lev).setParameter("prog", std.getCourseId().getSchoolProgrammeId().getProgrammeId().getId()).getResultList();
                    } catch (NumberFormatException numberFormatException) {
                    }
                }
            }
        }
        return list;
    }

    public List<Semestercourses> getSemesterCourseList(String lev, int prog) {
        List<Semestercourses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Semestercourses s WHERE s.status = 'ACTIVE' AND s.programmeId.id = :prog AND s.defaultLevel <= :lev ORDER BY s.defaultLevel DESC, s.name ASC").setParameter("lev", lev).setParameter("prog", Integer.valueOf(prog)).getResultList();
        } catch (NumberFormatException numberFormatException) {
        }
        return list;
    }

    public Semesterregistrationcourses getSemesterregistrationcourses(String semcourseId, String courseId) {
        Semesterregistrationcourses semcou = null;
        try {
            semcou = (Semesterregistrationcourses) this.em.createQuery("SELECT s FROM Semesterregistrationcourses s WHERE s.semesterCourseId.id = :semcourseId AND s.courseId.id = :courseId").setParameter("semcourseId", semcourseId).setParameter("courseId", courseId).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return semcou;
    }

    public Semestercourses getSemestercoursesByCodeAndProgramme(String code, String programme) {
        code = code.toUpperCase();
        Semestercourses data = null;
        try {
            int programmeId = Integer.parseInt(programme);
            data = (Semestercourses) this.em.createQuery("SELECT s FROM Semestercourses s WHERE s.code = :code AND s.programmeId.id = :prog").setParameter("code", code).setParameter("prog", Integer.valueOf(programmeId)).setMaxResults(1).getSingleResult();
        } catch (NumberFormatException numberFormatException) {

        } catch (NoResultException noResultException) {
        }
        return data;
    }

    public List<Semesterregistrationcourses> getSemesterregistrationcoursesBySemestercourseid(String semestercourseid) {
        List<Semesterregistrationcourses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Semesterregistrationcourses s WHERE s.semesterCourseId.id = :semestercourseid ORDER BY s.courseId.name ASC").setParameter("semestercourseid", semestercourseid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Studentprogression> getStudentprogressionBySchooFacultySessionSemester(String schoolid, String facultyid, String session, String semester) {
        List<Studentprogression> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Studentprogression s WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolid AND s.courseId.departmentId.facultyId.id = :facultyid AND s.sessionAdded = :session AND s.semesterAdded = :semester ORDER BY s.courseId.departmentId.name ASC, s.courseId.name ASC, s.levelAdded ASC").setParameter("facultyid", facultyid).setParameter("schoolid", schoolid).setParameter("session", session).setParameter("semester", semester).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<String> getStudentprogressionByCourseSessionSemester(String course, String startsess, String endsess, String semester) {
        List<String> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT DISTINCT s.studentsId.id FROM Studentprogression s WHERE s.courseId.id = :course AND (s.sessionAdded >= :startsess AND s.sessionAdded <= :endsess) AND s.semesterAdded = :semester ORDER BY s.studentsId.id ASC", String.class).setParameter("course", course).setParameter("startsess", startsess).setParameter("endsess", endsess).setParameter("semester", semester).getResultList();
        } catch (Exception k) {
            k.printStackTrace();
        }
        return list;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterRegstatus(String courseid, String levelat, String session, String semester, String reegstatus) {
        List<Students> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Students s, Studentprogression r WHERE s.id = r.studentsId.id AND r.courseId.id = :courseid AND r.levelAdded = :level AND r.sessionAdded = :session AND r.semesterAdded = :semester AND r.registrationStatus = :status ORDER BY s.matricNo ASC").setParameter("courseid", courseid).setParameter("level", levelat).setParameter("session", session).setParameter("semester", semester).setParameter("status", reegstatus).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterRegstatusIndigene(String courseid, String levelat, String session, String semester, String reegstatus) {
        List<Students> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Students s, Studentprogression r WHERE s.id = r.studentsId.id AND r.courseId.id = :courseid AND s.stateOfOrigin.id = :ind AND r.levelAdded = :level AND r.sessionAdded = :session AND r.semesterAdded = :semester AND r.registrationStatus = :status ORDER BY s.matricNo ASC").setParameter("courseid", courseid).setParameter("ind", Integer.valueOf(this.settings.indigeneStateCode)).setParameter("level", levelat).setParameter("session", session).setParameter("semester", semester).setParameter("status", reegstatus).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterRegstatusNoIndigene(String courseid, String levelat, String session, String semester, String reegstatus) {
        List<Students> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Students s, Studentprogression r WHERE s.id = r.studentsId.id AND r.courseId.id = :courseid AND s.stateOfOrigin.id != :ind AND r.levelAdded = :level AND r.sessionAdded = :session AND r.semesterAdded = :semester AND r.registrationStatus = :status ORDER BY s.matricNo ASC").setParameter("courseid", courseid).setParameter("ind", Integer.valueOf(this.settings.indigeneStateCode)).setParameter("level", levelat).setParameter("session", session).setParameter("semester", semester).setParameter("status", reegstatus).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterPayment(String courseId, String level, String session, String semester) {
        List<Students> studentsList = new ArrayList<>();
        try {
            studentsList = this.em.createQuery("SELECT s FROM Students s JOIN Studentprogression r ON s.id = r.studentsId.id JOIN Payments p ON s.id = p.payerId JOIN Courses c ON r.courseId.id = c.id JOIN Feesgroup fg ON fg.schoolId.id = c.schoolProgrammeId.schoolId.id WHERE r.courseId.id = :courseid AND r.sessionAdded = :session1 AND p.sessionPaid = :session1 AND r.semesterAdded = :semester1 AND p.semesterPaid = :semester1 AND r.levelAdded = :level AND p.feesGroupId.id = fg.id ORDER BY s.matricNo ASC", Students.class).setParameter("courseid", courseId).setParameter("session1", session).setParameter("semester1", semester).setParameter("level", level).getResultList();
        } catch (Exception exception) {
        }
        return studentsList;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterPaymentNoIndigene(String courseId, String level, String session, String semester) {
        List<Students> studentsList = new ArrayList<>();
        try {
            studentsList = this.em.createQuery("SELECT s FROM Students s JOIN Studentprogression r ON s.id = r.studentsId.id JOIN Payments p ON s.id = p.payerId JOIN Courses c ON r.courseId.id = c.id JOIN Feesgroup fg ON fg.schoolId.id = c.schoolProgrammeId.schoolId.id WHERE r.courseId.id = :courseid AND r.sessionAdded = :session1 AND p.sessionPaid = :session1 AND s.stateOfOrigin.id != :indigeneState AND r.semesterAdded = :semester1 AND p.semesterPaid = :semester1 AND r.levelAdded = :level AND p.feesGroupId.id = fg.id ORDER BY s.matricNo ASC", Students.class).setParameter("indigeneState", Integer.valueOf(this.settings.indigeneStateCode)).setParameter("courseid", courseId).setParameter("session1", session).setParameter("semester1", semester).setParameter("level", level).getResultList();
        } catch (Exception exception) {
        }
        return studentsList;
    }

    public List<Students> getStudentsByCourseLevelatSessionSemesterPaymentIndigene(String courseId, String level, String session, String semester) {
        List<Students> studentsList = new ArrayList<>();
        try {
            studentsList = this.em.createQuery("SELECT s FROM Students s JOIN Studentprogression r ON s.id = r.studentsId.id JOIN Payments p ON s.id = p.payerId JOIN Courses c ON r.courseId.id = c.id JOIN Feesgroup fg ON fg.schoolId.id = c.schoolProgrammeId.schoolId.id WHERE r.courseId.id = :courseid AND r.sessionAdded = :session1 AND p.sessionPaid = :session1 AND r.semesterAdded = :semester1 AND s.stateOfOrigin.id = :indigeneState AND p.semesterPaid = :semester1 AND r.levelAdded = :level AND p.feesGroupId.id = fg.id ORDER BY s.matricNo ASC", Students.class).setParameter("indigeneState", Integer.valueOf(this.settings.indigeneStateCode)).setParameter("courseid", courseId).setParameter("session1", session).setParameter("semester1", semester).setParameter("level", level).getResultList();
        } catch (Exception exception) {
        }
        return studentsList;
    }

    public List<StudentStats> getAggregatedStudentStats(String schoolId, String facultyId, String session, String semester) {
        List<StudentStats> statsList = new ArrayList<>();
        String ejbql = "    SELECT new com.mnl.bsum.EduPortal.util.StudentStats(\n        c.id, c.name, d.name, r.levelAdded,\n        COUNT(DISTINCT s.id),\n        COUNT(CASE WHEN s.stateOfOrigin.id = :indigeneState THEN 1 END),\n        COUNT(CASE WHEN s.stateOfOrigin.id != :indigeneState THEN 1 END),\n        COUNT(CASE WHEN r.registrationStatus = '1' THEN 1 END),\n        COUNT(CASE WHEN r.registrationStatus = '0' THEN 1 END),\n        COUNT(CASE WHEN p.id IS NOT NULL THEN 1 END),\n        COUNT(CASE WHEN p.id IS NOT NULL AND s.stateOfOrigin.id = :indigeneState THEN 1 END),\n        COUNT(CASE WHEN p.id IS NOT NULL AND s.stateOfOrigin.id != :indigeneState THEN 1 END),\n        COUNT(CASE WHEN p.id IS NULL THEN 1 END),\n        COUNT(CASE WHEN p.id IS NULL AND s.stateOfOrigin.id = :indigeneState THEN 1 END),\n        COUNT(CASE WHEN p.id IS NULL AND s.stateOfOrigin.id != :indigeneState THEN 1 END)\n    )\n    FROM Students s\n    JOIN Studentprogression r\n               ON r.studentsId.id=s.id\n    JOIN r.courseId c\n    JOIN c.departmentId d\n    LEFT JOIN Payments p ON s.id = p.payerId\n        AND p.sessionPaid = r.sessionAdded\n        AND p.semesterPaid = r.semesterAdded\n    WHERE c.schoolProgrammeId.schoolId.id = :schoolId\n      AND c.departmentId.facultyId.id = :facultyId\n      AND r.sessionAdded = :session\n      AND r.semesterAdded = :semester\n    GROUP BY c.id, d.name, r.levelAdded\n    ORDER BY d.name, c.name, r.levelAdded\n";
        try {
            TypedQuery<StudentStats> query = this.em.createQuery(ejbql, StudentStats.class);
            query.setParameter("indigeneState", Integer.valueOf(this.settings.indigeneStateCode));
            query.setParameter("schoolId", schoolId);
            query.setParameter("facultyId", facultyId);
            query.setParameter("session", session);
            query.setParameter("semester", semester);
            statsList = query.getResultList();
        } catch (Exception exception) {
        }
        return statsList;
    }

    public List<CourseSummaryDTO> getCourseSummary(String school, String faculty) {
        List<CourseSummaryDTO> list = new ArrayList<>();
        Sessionmanager sessionManager = getCurrentSessionManagerBySchoolAndOperation(school, "REGISTRATION");
        String session = sessionManager.getName();
        String semester = sessionManager.getSemester();
        System.out.println("=== COURSE SUMMARY DEBUG ===");
        System.out.println("School: " + school);
        System.out.println("Faculty: " + faculty);
        System.out.println("Current Session: " + session);
        System.out.println("Current Semester: " + semester);
        List<Courses> allCourses = getCoursesBySchoolAndFaculty(school, faculty);
        System.out.println("Total courses found for school/faculty: " + allCourses.size());
        for (Courses course : allCourses) {
            System.out.println("  Course: " + course.getId() + " - " + course.getName());
        }
        List<Studentprogression> progressions = getStudentprogressionBySchooFacultySessionSemester(school, faculty, session, semester);
        System.out.println("Total student progressions found: " + progressions.size());
        for (Studentprogression prog : progressions) {
            System.out.println("  Progression: Course=" + prog.getCourseId().getId() + " (" + prog
                    .getCourseId().getName() + "), Level=" + prog.getLevelAdded() + ", Session=" + prog
                    .getSessionAdded() + ", Semester=" + prog.getSemesterAdded());
        }
        for (Courses course : allCourses) {
            List<Semesterregistrationcucontrol> controls = getSemesterregistrationcucontrolByCourse(course.getId());
            System.out.println("Credit unit controls for course " + course.getId() + " (" + course.getName() + "): " + controls
                    .size());
            for (Semesterregistrationcucontrol control : controls) {
                System.out.println("  Control: Level=" + control.getLevel() + ", Semester=" + control.getSemester() + ", Min=" + control
                        .getMincu() + ", Max=" + control.getMaxcu());
            }
            if (course.getId().equals("C44829") || course.getName().contains("TAXATION")) {
                System.out.println("*** FOUND TARGET COURSE: " + course.getId() + " - " + course.getName() + " ***");
                System.out.println("  School: " + course.getSchoolProgrammeId().getSchoolId().getId());
                System.out.println("  Department: " + course.getDepartmentId().getName());
                System.out.println("  Faculty: " + course.getDepartmentId().getFacultyId().getId());
                List<Studentprogression> courseProgressions = (List<Studentprogression>) progressions.stream().filter(p -> p.getCourseId().getId().equals(course.getId())).collect(Collectors.toList());
                System.out.println("  Student progressions for this course: " + courseProgressions.size());
                for (Studentprogression cp : courseProgressions) {
                    System.out.println("    Level=" + cp.getLevelAdded() + ", Session=" + cp.getSessionAdded() + ", Semester=" + cp
                            .getSemesterAdded());
                }
            }
        }
        String query = "SELECT new com.mnl.eduportal.util.CourseSummaryDTO( c.id, d.name, c.name, sp.levelAdded, (SELECT COUNT(sp2.id) FROM Studentprogression sp2 WHERE sp2.courseId.id = c.id AND sp2.levelAdded = sp.levelAdded AND sp2.sessionAdded = :sess AND sp2.semesterAdded = :sem), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'First' AND sc.courseType = 'GST' AND sc.courseStatus = 'ACTIVE'), (SELECT SUM(sc.creditUnit) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'First' AND sc.courseType = 'GST' AND sc.courseStatus = 'ACTIVE'), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'First' AND sc.courseType = 'CORE' AND sc.courseStatus = 'ACTIVE'), (SELECT SUM(sc.creditUnit) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'First' AND sc.courseType = 'CORE' AND sc.courseStatus = 'ACTIVE'), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'First' AND sc.courseType = 'ELECTIVE' AND sc.courseStatus = 'ACTIVE'), (SELECT cu1.mincu FROM Semesterregistrationcucontrol cu1 WHERE cu1.courseId.id = c.id AND cu1.level = sp.levelAdded AND cu1.semester = 'First'), (SELECT cu1.maxcu FROM Semesterregistrationcucontrol cu1 WHERE cu1.courseId.id = c.id AND cu1.level = sp.levelAdded AND cu1.semester = 'First'), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'Second' AND sc.courseType = 'GST' AND sc.courseStatus = 'ACTIVE'), (SELECT SUM(sc.creditUnit) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'Second' AND sc.courseType = 'GST' AND sc.courseStatus = 'ACTIVE'), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'Second' AND sc.courseType = 'CORE' AND sc.courseStatus = 'ACTIVE'), (SELECT SUM(sc.creditUnit) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'Second' AND sc.courseType = 'CORE' AND sc.courseStatus = 'ACTIVE'), (SELECT COUNT(sc) FROM Semesterregistrationcourses sc WHERE sc.courseId.id = c.id AND sc.level = sp.levelAdded AND sc.semester = 'Second' AND sc.courseType = 'ELECTIVE' AND sc.courseStatus = 'ACTIVE'), (SELECT cu2.mincu FROM Semesterregistrationcucontrol cu2 WHERE cu2.courseId.id = c.id AND cu2.level = sp.levelAdded AND cu2.semester = 'Second'), (SELECT cu2.maxcu FROM Semesterregistrationcucontrol cu2 WHERE cu2.courseId.id = c.id AND cu2.level = sp.levelAdded AND cu2.semester = 'Second') ) FROM Courses c JOIN Departments d ON d.id = c.departmentId.id JOIN Studentprogression sp ON sp.courseId.id = c.id WHERE c.schoolProgrammeId.schoolId.id = :school AND d.facultyId.id = :faculty AND sp.sessionAdded = :sess AND sp.semesterAdded = :sem GROUP BY c.id, d.name, c.name, sp.levelAdded";
        System.out.println("Executing query with parameters:");
        System.out.println("  school: " + school);
        System.out.println("  faculty: " + faculty);
        System.out.println("  sess: " + session);
        System.out.println("  sem: " + semester);
        try {
            list = this.em.createQuery(query, CourseSummaryDTO.class).setParameter("school", school).setParameter("faculty", faculty).setParameter("sess", session).setParameter("sem", semester).getResultList();
            System.out.println("Query executed successfully. Results found: " + list.size());
            for (CourseSummaryDTO dto : list) {
                System.out.println("  Result: Course=" + dto.getCourseId() + ", Department=" + dto.getDepartmentName() + ", Level=" + dto
                        .getLevel() + ", Students=" + dto.getTotalStudents());
            }
            System.out.println("=== END COURSE SUMMARY DEBUG ===");
        } catch (Exception k) {
            System.out.println("ERROR in getCourseSummary: " + k.getMessage());
            k.printStackTrace();
        }
        return list;
    }

    public String getFullname(Users user) {
        String fullname = "";
        try {
            if (user.getDefaultRole().getRoleType().equalsIgnoreCase("STAFF_PUBLIC")) {
                Staff stf = getStaffById(user.getId());
                if (stf != null) {
                    fullname = stf.getSurname() + " " + stf.getSurname();
                }
            } else if (user.getDefaultRole().getRoleType().equalsIgnoreCase("STUDENTS")) {
                Students stf = getStudentsById(user.getId());
                if (stf != null) {
                    fullname = stf.getSurname() + " " + stf.getSurname();
                }
            } else if (user.getDefaultRole().getRoleType().equalsIgnoreCase("APPLICANTS")) {
                Applicants stf = getApplicantsById(user.getId());
                if (stf != null) {
                    fullname = stf.getSurname() + " " + stf.getSurname();
                }
            }
        } catch (Exception exception) {
        }
        return fullname;
    }

    public List<PaymentSummaryDTO> getPaymentSummary(String sessions, String semester, String schoolid) {
        Query query = this.em.createQuery("SELECT p.feesGroupId.id, p.feesGroupId.name, SUM(p.amount), COUNT(DISTINCT p.payerId) FROM Payments p WHERE p.schoolId.id = :schoolid AND p.sessionPaid = :sessions AND p.semesterPaid = :semester GROUP BY p.feesGroupId.id, p.feesGroupId.name ORDER BY p.feesGroupId.name ASC");
        query.setParameter("schoolid", schoolid);
        query.setParameter("sessions", sessions);
        query.setParameter("semester", semester);
        List<Object[]> results = query.getResultList();
        return (List<PaymentSummaryDTO>) results.stream()
                .map(r -> new PaymentSummaryDTO((String) r[0], (String) r[1], (Double) r[2], (Long) r[3]))
                .collect(Collectors.toList());
    }

    @Transactional
    public void changeCourseApplicationStatus(String id, String newcourse) {
        try {
            Applicants genapp = (Applicants) this.em.find(Applicants.class, id);
            if (genapp != null) {
                genapp.setCourse1(getCourses(newcourse));
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void changePaymentreferenceStatus(String id, String status) {
        try {
            Paymentreference genapp = (Paymentreference) this.em.find(Paymentreference.class, id);
            if (genapp != null) {
                genapp.setPaidStatus(status);
            }
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void approveDeferment(String id, String staffno, String sessionapp, String semesterapp, String dateapp) {
        try {
            String sdate = dateapp + " 00:00:00";
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date parsedDate = dateFormat.parse(sdate);
            Timestamp ts1 = new Timestamp(parsedDate.getTime());
            this.em.createQuery("UPDATE Deferments p SET p.approvalStatus = 'APPROVED', p.approvedBy.id = :staffno, p.dateApproved = :dateapp, p.expectedResumptionSemester = :expsem, p.expectedResumptionSession = :expsess WHERE p.id = :id")
                    .setParameter("staffno", staffno)
                    .setParameter("dateapp", ts1)
                    .setParameter("expsem", semesterapp)
                    .setParameter("expsess", sessionapp)
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error approving Deferment", e);
        }
    }

    public Deferments getDefermentsByStudentSessSem(String stdid, String sess, String sem) {
        Deferments fs = null;
        try {
            List<Deferments> list = this.em.createQuery("SELECT p FROM Deferments p JOIN FETCH p.studentId WHERE p.studentId.id = :stdid AND p.session = :sess AND p.semester = :sem").setParameter("stdid", stdid).setParameter("sess", sess).setParameter("sem", sem).getResultList();
            if (!list.isEmpty()) {
                fs = list.get(0);
            }
        } catch (Exception exception) {
        }
        return fs;
    }

    public Feesgroup getFeesgroupByNameAndSchool(String name, String schId) {
        Feesgroup fs = null;
        try {
            String tex = "SELECT p FROM Feesgroup p WHERE p.schoolId.id = :schid AND p.name = :name";
            List<Feesgroup> list = this.em.createQuery(tex).setParameter("schid", schId).setParameter("name", name).getResultList();
            if (!list.isEmpty()) {
                fs = list.get(0);
            }
        } catch (Exception exception) {
        }
        return fs;
    }

    public Deferments getDeferments(String id) {
        Deferments sm = null;
        try {
            sm = (Deferments) this.em.createQuery("SELECT l FROM Deferments l JOIN FETCH l.studentId WHERE l.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return sm;
    }

    @Transactional
    public void deleteDeferments(String id) {
        try {
            this.em.createQuery("DELETE FROM Deferments p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Deferments", e);
        }
    }

    @Transactional
    public void deleteSemesterregistrationcourses(String id) {
        try {
            this.em.createQuery("DELETE FROM Semesterregistrationcourses p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Semesterregistrationcourses", e);
        }
    }

    @Transactional
    public void deleteAdmissions(String id) {
        try {
            this.em.createQuery("DELETE FROM Admissions p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Admissions", e);
        }
    }

    @Transactional
    public void deleteHostelallocation(String id) {
        try {
            this.em.createQuery("DELETE FROM Hostelallocation p WHERE p.id = :id")
                    .setParameter("id", id)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting Hostelallocation", e);
        }
    }

    public Summerschoolapplication getSummerschoolapplicationByStudent(String stdid, String summerid) {
        Summerschoolapplication data = null;
        try {
            data = (Summerschoolapplication) this.em.createQuery("SELECT s FROM Summerschoolapplication s JOIN FETCH s.studentsId WHERE s.studentsId.id = :stdid AND s.summerSchoolStatusId.id = :summerid ORDER BY s.dateApplied DESC").setParameter("summerid", summerid).setParameter("stdid", stdid).setMaxResults(1).getSingleResult();
        } catch (Exception exception) {
        }
        return data;
    }

    public Summerschoolapplication getSummerschoolapplicationById(String id) {
        Summerschoolapplication data = null;
        try {
            data = (Summerschoolapplication) this.em.createQuery("SELECT s FROM Summerschoolapplication s JOIN FETCH s.studentsId WHERE s.id = :id").setParameter("id", id).setMaxResults(1).getSingleResult();
        } catch (Exception k) {
            k.printStackTrace();
        }
        return data;
    }

    public List<Summerschoolapplication> getSummerschoolapplicationByStudent(String stdid) {
        List<Summerschoolapplication> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Summerschoolapplication s JOIN FETCH s.studentsId WHERE s.studentsId.id = :stdid ORDER BY s.dateApplied DESC").setParameter("stdid", stdid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Summerschoolregistration> getSummerschoolregistrationByStudent(String stdid) {
        List<Summerschoolregistration> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Summerschoolregistration s WHERE s.applicationId.id = :stdid ORDER BY s.semesterCourseId.name ASC").setParameter("stdid", stdid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Summerschoolstatus> getAllSummerschoolstatusBySchoolProgramme(String schprogid) {
        List<Summerschoolstatus> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT s FROM Summerschoolstatus s WHERE s.schoolProgrammeId.id = :schprogid ORDER BY s.sessionStarted DESC").setParameter("schprogid", schprogid).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Users> updateUsers() {
        List<Users> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Users u WHERE u.id LIKE 'pg%' AND u.email IS NULL").getResultList();
            for (Users u : list) {
                Applicants app = getApplicantsById(u.getId());
                if (app != null) {
                    Users us = getUsersByEmail(app.getEmailAddress());
                    if (us != null) {
                        Users f = (Users) this.em.find(Users.class, u.getId());
                        if (f != null) {
                            f.setEmail(app.getEmailAddress());
                        }
                    }
                }
            }
        } catch (Exception exception) {
        }
        return list;
    }

    public boolean validateToken(String token) {
        return true;
    }

    public Sessionmanager getSessionmanager(String id) {
        Sessionmanager user = null;
        try {
            user = (Sessionmanager) this.em.createQuery("SELECT s FROM Sessionmanager AS s WHERE s.id = :id").setParameter("id", id).getSingleResult();
        } catch (Exception exception) {
        }
        return user;
    }

    @Deprecated
    public void createSessionProgression(String id) {
        Sessionmanager sm = getSessionmanager(id);
        if (sm != null
                && sm.getOperation().equalsIgnoreCase("REGISTRATION"))
      try {
            TypedQuery<Students> query = this.em.createQuery("SELECT s FROM Students s JOIN FETCH s.courseId JOIN FETCH s.courseId.schoolProgrammeId JOIN FETCH s.courseId.schoolProgrammeId.schoolId WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId", Students.class);
            query.setParameter("schoolId", sm.getSchoolId().getId());
            List<Students> students = query.getResultList();
            for (Students std : students) {
                updateStudentProgression2(std);
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public Map<String, Object> createSessionProgressionBatched(String id) {
        Map<String, Object> result = new HashMap<>();
        List<String> errors = new ArrayList<>();
        List<Integer> failedBatches = new ArrayList<>();
        int totalStudents = 0;
        int processedStudents = 0;
        int failedStudents = 0;
        ProgressionProgress progress = new ProgressionProgress();
        progressionTracking.put(id, progress);
        Sessionmanager sm = getSessionmanager(id);
        if (sm == null) {
            result.put("error", "Sessionmanager not found");
            progress.completed = true;
            return result;
        }
        if (!sm.getOperation().equalsIgnoreCase("REGISTRATION")) {
            result.put("message", "Session is not for REGISTRATION, no progression needed");
            progress.completed = true;
            return result;
        }
        try {
            TypedQuery<Long> countQuery = this.em.createQuery("SELECT COUNT(s) FROM Students s WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId", Long.class);
            countQuery.setParameter("schoolId", sm.getSchoolId().getId());
            totalStudents = ((Long) countQuery.getSingleResult()).intValue();
            result.put("totalStudents", Integer.valueOf(totalStudents));
            progress.totalStudents = totalStudents;
            if (totalStudents == 0) {
                result.put("message", "No students found for this school");
                progress.completed = true;
                return result;
            }
            int batchSize = 50;
            int totalBatches = (int) Math.ceil(totalStudents / batchSize);
            int processedBatches = 0;
            int consecutiveFailures = 0;
            int maxConsecutiveFailures = 5;
            progress.totalBatches = totalBatches;
            System.out.println("Starting progression processing: " + totalStudents + " students in " + totalBatches + " batches (batch size: " + batchSize + ")");
            AtomicInteger successCount = new AtomicInteger(0);
            AtomicInteger failureCount = new AtomicInteger(0);
            int offset;
            for (offset = 0; offset < totalStudents; offset += batchSize) {
                int currentBatchNumber = processedBatches + 1;
                progress.currentBatch = currentBatchNumber;
                progress.processedStudents = successCount.get();
                progress.failedStudents = failureCount.get();
                try {
                    retryBatch(currentBatchNumber, offset, batchSize, sm.getSchoolId().getId(), successCount, failureCount);
                    processedBatches++;
                    consecutiveFailures = 0;
                    if (processedBatches % 5 == 0) {
                        Thread.sleep(1000L);
                    }
                    if (processedBatches % 50 == 0 || processedBatches == totalBatches / 4 || processedBatches == totalBatches / 2 || processedBatches == 3 * totalBatches / 4 || processedBatches == totalBatches) {
                        int currentSuccess = successCount.get();
                        int percentage = (int) (currentSuccess * 100.0D / totalStudents);
                        System.out.println("Progress: " + currentSuccess + "/" + totalStudents + " students (" + percentage + "%) - Batch " + processedBatches + "/" + totalBatches);
                    }
                } catch (Exception batchError) {
                    consecutiveFailures++;
                    int batchFailedCount = Math.min(batchSize, totalStudents - offset);
                    failedBatches.add(Integer.valueOf(currentBatchNumber));
                    String errorMsg = "Batch " + currentBatchNumber + " (offset " + offset + ", size " + batchFailedCount + ") failed after retries: " + batchError.getMessage();
                    errors.add(errorMsg);
                    System.err.println(errorMsg);
                    if (consecutiveFailures >= maxConsecutiveFailures) {
                        String circuitBreakerMsg = "CIRCUIT BREAKER TRIGGERED: " + consecutiveFailures + " consecutive batch failures. Stopping to prevent infinite retry loop. Processed: " + successCount.get() + "/" + totalStudents + " students.";
                        errors.add(circuitBreakerMsg);
                        System.err.println(circuitBreakerMsg);
                        break;
                    }
                }
            }
            processedStudents = successCount.get();
            failedStudents = failureCount.get();
            progress.processedStudents = processedStudents;
            progress.failedStudents = failedStudents;
            progress.currentBatch = totalBatches;
            progress.completed = true;
            result.put("processedStudents", Integer.valueOf(processedStudents));
            result.put("failedStudents", Integer.valueOf(failedStudents));
            result.put("batchSize", Integer.valueOf(batchSize));
            result.put("totalBatches", Integer.valueOf(totalBatches));
            result.put("errors", errors);
            result.put("success", Boolean.valueOf((failedStudents == 0)));
            System.out.println("Progression processing completed: " + processedStudents + " succeeded, " + failedStudents + " failed");
        } catch (Exception e) {
            result.put("error", "Fatal error: " + e.getMessage());
            result.put("processedStudents", Integer.valueOf(processedStudents));
            result.put("failedStudents", Integer.valueOf(failedStudents));
            progress.completed = true;
            e.printStackTrace();
        }
        return result;
    }

    private void retryBatch(int batchNumber, int offset, int batchSize, String schoolId, AtomicInteger successCount, AtomicInteger failureCount) throws Exception {
        int maxRetries = 2;
        int retryCount = 0;
        Exception lastException = null;
        while (retryCount <= maxRetries) {
            try {
                com.mnl.eduportal.sessions.MainSession self = (com.mnl.eduportal.sessions.MainSession) this.sessionContext.getBusinessObject(com.mnl.eduportal.sessions.MainSession.class);
                self.processStudentBatch(offset, batchSize, schoolId, successCount, failureCount);
                return;
            } catch (Exception e) {
                lastException = e;
                retryCount++;
                if (isTransactionOrLockIssue(e)) {
                    System.err.println("Batch " + batchNumber + " attempt " + retryCount + " failed with transaction/lock issue - will retry");
                    if (retryCount <= maxRetries) {
                        long waitTime = 1000L * (1 << retryCount - 1);
                        try {
                            Thread.sleep(waitTime);
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            throw new RuntimeException("Retry interrupted", ie);
                        }
                        continue;
                    }
                    System.err.println("Batch " + batchNumber + " failed after " + maxRetries + " retries: Persistence error - will retry");
                    failureCount.addAndGet(batchSize);
                    throw lastException;
                }
                System.err.println("Batch " + batchNumber + " failed with non-retryable error: " + e.getMessage());
                failureCount.addAndGet(batchSize);
                throw e;
            }
        }
        if (lastException != null) {
            throw lastException;
        }
    }

    private boolean isTransactionOrLockIssue(Exception e) {
        if (e == null) {
            return false;
        }
        String message = (e.getMessage() != null) ? e.getMessage().toLowerCase() : "";
        return (message.contains("status_rolledback") || message
                .contains("status_marked_rollback") || message
                .contains("transaction") || message
                .contains("lock") || message
                .contains("deadlock") || message
                .contains("connection") || message
                .contains("timeout") || e instanceof OptimisticLockException || e instanceof jakarta.persistence.PessimisticLockException);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void processStudentBatch(int offset, int batchSize, String schoolId, AtomicInteger successCount, AtomicInteger failureCount) {
        try {
            TypedQuery<Students> query = this.em.createQuery("SELECT DISTINCT s FROM Students s JOIN FETCH s.courseId JOIN FETCH s.courseId.schoolProgrammeId JOIN FETCH s.courseId.schoolProgrammeId.schoolId WHERE s.courseId.schoolProgrammeId.schoolId.id = :schoolId ORDER BY s.id", Students.class);
            query.setParameter("schoolId", schoolId);
            query.setFirstResult(offset);
            query.setMaxResults(batchSize);
            query.setHint("jakarta.persistence.query.timeout", Integer.valueOf(60000));
            query.setHint("jakarta.persistence.lock.timeout", Integer.valueOf(10000));
            List<Students> students = query.getResultList();
            if (!students.isEmpty()) {
                TypedQuery<Students> progressionQuery = this.em.createQuery("SELECT s FROM Students s LEFT JOIN FETCH s.studentprogressionCollection WHERE s IN :students", Students.class);
                progressionQuery.setParameter("students", students);
                progressionQuery.setHint("jakarta.persistence.query.timeout", Integer.valueOf(60000));
                progressionQuery.getResultList();
            }
            for (Students std : students) {
                try {
                    updateStudentProgression2(std);
                    successCount.incrementAndGet();
                } catch (Exception studentError) {
                    System.err.println("Failed to update progression for student " + std.getId() + ": " + studentError.getMessage());
                    failureCount.incrementAndGet();
                }
            }
            this.em.flush();
            this.em.clear();
        } catch (PersistenceException pe) {
            System.err.println("Persistence error at offset " + offset + ": " + pe.getMessage());
            if (isTransactionOrLockIssue((Exception) pe)) {
                System.err.println("Connection/Transaction/Lock issue detected - batch will be retried");
            }
            throw new RuntimeException("Persistence error - will retry", pe);
        } catch (Exception e) {
            System.err.println("Batch processing error at offset " + offset + ": " + e.getMessage());
            throw new RuntimeException("Batch processing error", e);
        }
    }

    @Transactional
    public void updateSessionmanager(Sessionmanager adm) {
        try {
            Sessionmanager ss = (Sessionmanager) this.em.find(Sessionmanager.class, adm.getId());
            if (ss != null) {
                this.em.merge(adm);
            }
        } catch (Exception exception) {
        }
    }

    public void autoUnScreen() {
        Sessionmanager sessmanx = getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
        List<Courses> coursesl = getCoursesBySchoolAndProgramme("S001", "1001");
        coursesl.addAll(getCoursesBySchoolAndProgramme("S003", "1001"));
        for (Courses course : coursesl) {
            List<Admissions> appl = getAdmissionsByCourseStatus(course.getId(), sessmanx.getName(), "CLEARED", "ALL", "S001",
                    Integer.valueOf(1001));
            appl.addAll(getAdmissionsByCourseStatus(course.getId(), sessmanx.getName(), "CLEARED", "ALL", "S003",
                    Integer.valueOf(1001)));
            for (Admissions adm : appl) {
                unClearApplicant(adm.getId(), getUsers("s202410818"));
            }
        }
    }

    public void autoScreen(String school, int prog) {
        try {
            Sessionmanager sessmanx = getCurrentSessionManagerBySchoolAndOperation(school, "APPLICATION");
            List<Courses> coursesl = getCoursesBySchoolAndProgramme(school, "" + prog);
            for (Courses course : coursesl) {
                List<Admissions> appl = getAdmissionsByCourseStatus(course.getId(), sessmanx.getName(), "PENDING", "ALL", school,
                        Integer.valueOf(prog));
                for (Admissions adm : appl) {
                    Feesgroup check = getFeesgroupByNameAndSchool(this.settings.admissionChecking, adm
                            .getSchoolId().getId());
                    Feesgroup accep = getFeesgroupByNameAndSchool(this.settings.acceptanceLetter, adm
                            .getSchoolId().getId());
                    List<Payments> pay1 = getPaymentsByRegnoSessSemFeesgroup(adm.getId(), check.getId(), sessmanx
                            .getName(), "Session");
                    List<Payments> pay2 = getPaymentsByRegnoSessSemFeesgroup(adm.getId(), accep.getId(), sessmanx
                            .getName(), "Session");
                    if (pay1.size() > 0 && pay2.size() > 0) {
                        clearApplicant(adm.getId(), getUsers("s202410818"));
                    }
                }
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
    }

    public void clearApplicant(String id, Users user) {
        Admissions adm = getAdmissions(id);
        if (adm != null) {
            adm.setAdmissionStatus("CLEARED");
            addUpdateAdmission(adm);
            Users usd = getUsers(id);
            if (usd != null) {
                // FIXED: Set user status to ACTIVE when clearing
                usd.setStatus("ACTIVE");
                updateUserRole(adm.getId(), 1059);
            }
            Students std = getStudentsById(id);
            if (std == null) {
                std = new Students(id);
                std.setAddedBy(user);
                std.setClassAdmitted("" + adm.getCourseId().getDefaultMinLevel());
                std.setCourseId(adm.getCourseId());
                std.setCurrentClass("" + adm.getCourseId().getDefaultMinLevel());
                std.setDateAdded(this.settings.getCurrentDateTime());
                std.setDateOfBirth(adm.getDateOfBirth());
                std.setGender(adm.getGender());
                std.setLga(adm.getLgaId());
                std.setModeOfEntry(adm.getModeOfEntry());
                std.setNationality(adm.getNationalityId());
                std.setOthernames(adm.getOthernames());
                std.setRegistrationNo(adm.getId());
                std.setSessionAdmitted(adm.getSession());
                std.setStateOfOrigin(adm.getStateOfOriginId());
                std.setSurname(adm.getSurname());
                newStudent(std);
                String idd = adm.getSession().split("/")[0] + adm.getSession().split("/")[0] + adm.getId();
                Studentprogression proggSecond = new Studentprogression(idd);
                proggSecond.setCourseId(adm.getCourseId());
                proggSecond.setDateAdded(this.settings.getCurrentDateTime());
                proggSecond.setLevelAdded("" + adm.getCourseId().getDefaultMinLevel());
                proggSecond.setRegistrationStatus("0");
                proggSecond.setSemesterAdded("First");
                proggSecond.setSessionAdded(adm.getSession());
                // FIXED: Set status to ACTIVE instead of admission ID
                proggSecond.setStatus("ACTIVE");
                proggSecond.setStudentsId(std);
                newEntry(proggSecond);
            }
            if (adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S006")) {
                generateAdmissionLetterSW(adm.getId(), "s202410818");
            } else if (adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S002")) {
                generateAdmissionLetterPG(adm.getId(), "s202410818");
            } else {
                generateAdmissionLetter(adm.getId(), "s202410818");
            }
        }
    }

    public void unClearApplicant(String id, Users user) {
        Admissions adm = getAdmissions(id);
        if (adm != null) {
            adm.setAdmissionStatus("PENDING");
            addUpdateAdmission(adm);
            Users usd = getUsers(id);
            if (usd != null) {
                updateUserRole(adm.getId(), 1063);
            }
            Students std = getStudentsById(id);
            if (std != null) {
                List<Studentprogression> plist = getStudentprogression(id);
                for (Studentprogression da : plist) {
                    deleteStudentprogression(da.getId());
                }
                deleteStudent(id);
            }
        }
    }

    public void generateAdmissionLetter(String id, String userid) {
        try {
            String url = this.settings.documentroot + "/docs";
            String filename = "Adm_letter_" + id + ".pdf";
            String basename = url + "/" + filename;
            String docurl = "docs/" + filename;
            File loc = new File(url);
            if (!loc.exists()) {
                loc.mkdir();
            }
            Document document = new Document(PageSize.A4);
            PdfWriter pdfWriter = PdfWriter.getInstance(document, new FileOutputStream(basename));
            pdfWriter.setEncryption(null, null, -17, 1);
            pdfWriter.createXmpMetadata();
            WatermarkPageEvent watermarkEvent = new WatermarkPageEvent();
            pdfWriter.setPageEvent((PdfPageEvent) watermarkEvent);
            FooterPageEvent event = new FooterPageEvent();
            pdfWriter.setPageEvent((PdfPageEvent) event);
            document.setMargins(20.0F, 20.0F, 5.0F, 5.0F);
            Objects.requireNonNull(this.settings);
            document.addAuthor("Akawe Torkula Polytechnic, MAKURDI");
            document.addCreator("BDIC Plc");
            document.addSubject(filename);
            document.addCreationDate();
            document.addTitle(filename);
            document.open();
            Admissions adm = getAdmissions(id);
            if (adm != null)
        try {
                PdfPTable body = new PdfPTable(1);
                body.setWidthPercentage(100.0F);
                try {
                    body.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                body.getDefaultCell().setBorder(0);
                PdfPTable head1 = new PdfPTable(4);
                head1.setWidthPercentage(100.0F);
                try {
                    head1.setWidths(new int[]{5, 10, 80, 5});
                } catch (DocumentException documentException) {
                }
                head1.getDefaultCell().setBorder(0);
                PdfPCell space = new PdfPCell(new Phrase(" ", new Font(Font.FontFamily.TIMES_ROMAN, 18.0F, 1, BaseColor.BLACK)));
                space.setHorizontalAlignment(1);
                space.setBorder(0);
                head1.addCell(space);
                Image image1 = Image.getInstance(this.settings.baseurl + "/" + this.settings.baseurl);
                image1.setAlignment(1);
                head1.addCell(image1);
                PdfPTable head1b = new PdfPTable(1);
                head1b.setWidthPercentage(100.0F);
                try {
                    head1b.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                head1b.getDefaultCell().setBorder(0);
                Objects.requireNonNull(this.settings);
                PdfPCell head10 = new PdfPCell(new Phrase("Akawe Torkula Polytechnic, MAKURDI".toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14.0F, 1, BaseColor.BLACK)));
                head10.setHorizontalAlignment(1);
                head10.setBorder(0);
                head1b.addCell(head10);
                Objects.requireNonNull(this.settings);
                PdfPCell head1a = new PdfPCell(new Phrase("P.M.B. 102211,MAKURDI, Nigeria", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                head1a.setHorizontalAlignment(1);
                head1a.setBorder(0);
                head1b.addCell(head1a);
                PdfPCell head1a2 = new PdfPCell(new Phrase(adm.getCourseId().getSchoolProgrammeId().getSchoolId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 3, BaseColor.BLACK)));
                head1a2.setHorizontalAlignment(1);
                head1a2.setBorder(0);
                head1b.addCell(head1a2);
                head1.addCell(head1b);
                head1.addCell(space);
                body.addCell(head1);
                PdfPTable head2 = new PdfPTable(2);
                head2.setWidthPercentage(100.0F);
                try {
                    head2.setWidths(new int[]{25, 75});
                } catch (DocumentException documentException) {
                }
                head2.getDefaultCell().setBorder(0);
                head2.addCell("Date:");
                PdfPCell ad10 = new PdfPCell(new Phrase(this.settings.getTodaysdate(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad10.setHorizontalAlignment(0);
                ad10.setBorder(0);
                head2.addCell(ad10);
                head2.addCell("Applicant's Name:");
                PdfPCell ad1 = new PdfPCell(new Phrase(adm.getSurname() + " " + adm.getSurname(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad1.setHorizontalAlignment(0);
                ad1.setBorder(0);
                head2.addCell(ad1);
                head2.addCell("Registration Number:");
                PdfPCell ad2 = new PdfPCell(new Phrase(adm.getRegistrationNo().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad2.setHorizontalAlignment(0);
                ad2.setBorder(0);
                head2.addCell(ad2);
                body.addCell(head2);
                PdfPTable details = new PdfPTable(1);
                details.setWidthPercentage(100.0F);
                try {
                    details.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                details.getDefaultCell().setBorder(0);
                PdfPCell ad3 = new PdfPCell(new Phrase("CONFIRMATION OF OFFER OF ADMISSION:", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad3.setHorizontalAlignment(1);
                ad3.setBorder(0);
                details.addCell(ad3);
                PdfPCell ad4 = new PdfPCell(new Phrase(adm.getSession() + " ACADEMIC SESSION", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad4.setHorizontalAlignment(1);
                ad4.setBorder(0);
                details.addCell(ad4);
                body.addCell(details);
                Objects.requireNonNull(this.settings);
                body.addCell("I am pleased to confirm your offer of provisional admission into the " + "Akawe Torkula Polytechnic, MAKURDI" + " as approved by JAMB as follows:");
                PdfPTable head3 = new PdfPTable(2);
                head3.setWidthPercentage(100.0F);
                try {
                    head3.setWidths(new int[]{30, 70});
                } catch (DocumentException documentException) {
                }
                head3.getDefaultCell().setBorder(0);
                head3.addCell("Course:");
                PdfPCell ad5 = new PdfPCell(new Phrase(adm.getCourseId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                ad5.setHorizontalAlignment(0);
                ad5.setBorder(0);
                head3.addCell(ad5);
                head3.addCell("Programme:");
                PdfPCell ad6 = new PdfPCell(new Phrase(adm.getCourseId().getSchoolProgrammeId().getProgrammeId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                ad6.setHorizontalAlignment(0);
                ad6.setBorder(0);
                head3.addCell(ad6);
                head3.addCell("Faculty:");
                PdfPCell ad7 = new PdfPCell(new Phrase(adm.getCourseId().getDepartmentId().getFacultyId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                ad7.setHorizontalAlignment(0);
                ad7.setBorder(0);
                head3.addCell(ad7);
                head3.addCell("Level:");
                String leveld = "" + adm.getCourseId().getDefaultMinLevel();
                try {
                    Students std = getStudentsById(adm.getId());
                    if (std != null) {
                        leveld = std.getClassAdmitted();
                    }
                } catch (Exception exception) {
                }
                PdfPCell ad8 = new PdfPCell(new Phrase(leveld, new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                ad8.setHorizontalAlignment(0);
                ad8.setBorder(0);
                head3.addCell(ad8);
                head3.addCell("Duration:");
                PdfPCell ad9 = new PdfPCell(new Phrase("" + adm.getCourseId().getDefaultDuration() + " Semesters", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad9.setHorizontalAlignment(0);
                ad9.setBorder(0);
                head3.addCell(ad9);
                body.addCell(head3);
                List<Feessetup> feessetupf = new ArrayList<>();
                List<Feessetup> feessetups = new ArrayList<>();
                String fgi = "";
                String totam = "Not Set";
                try {
                    Feesgroup gfg = getSchoolFeesId(adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if (gfg != null) {
                        fgi = gfg.getId();
                    }
                } catch (Exception exception) {
                }
                String ind = "None";
                String sch = "None";
                String prog = "None";
                String fac = "None";
                String dept = "None";
                String course = "None";
                String level = "None";
                String campus = "None";
                String regno = "";
                String fullname = "";
                String coursename = "";
                Date dfrom = this.settings.getCurrentDateTime();
                try {
                    regno = adm.getId();
                    fullname = adm.getSurname() + " " + adm.getSurname();
                    coursename = adm.getCourseId().getName();
                    sch = adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = "" + adm.getCourseId().getSchoolProgrammeId().getProgrammeId().getId();
                    fac = adm.getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = adm.getCourseId().getDepartmentId().getId();
                    course = adm.getCourseId().getId();
                    if (adm.getStateOfOriginId().getId().intValue() == this.settings.indigeneStateCode) {
                        ind = "indigene";
                    } else {
                        ind = "non_indigene";
                    }
                    level = "" + adm.getCourseId().getDefaultMinLevel();
                    feessetupf = getFeessetup(fgi, adm.getSession(), "First", sch, prog, fac, dept, course, level, ind, campus, dfrom, adm
                            .getId());
                    feessetups = getFeessetup(fgi, adm.getSession(), "Second", sch, prog, fac, dept, course, level, ind, campus, dfrom, adm
                            .getId());
                    if (feessetupf.size() > 0 && feessetups.size() > 0) {
                        double totalf = feessetupf.stream().mapToDouble(Feessetup::getAmount).sum();
                        double totals = feessetups.stream().mapToDouble(Feessetup::getAmount).sum();
                        totam = "N" + this.settings.formatno.format(totalf + totals);
                    }
                } catch (Exception exception) {
                }
                int duration = adm.getCourseId().getDefaultDuration().intValue();
                ConvertNumberToWord words = new ConvertNumberToWord();
                String inwords = words.convert(duration);
                body.addCell("1. The polytechnic shall commence registration of Fresh Students for the First Semester of " + adm
                        .getSession() + " Academic Session from 10th March  May, 2026");
                body.addCell("2. This admission is only provisional as only candidates who are successful at the screening exercise would be registered.");
                body.addCell("3. Successfully screened candidates are to proceed and pay appropriate user charges immediately in order to validate their admission.");
                body.addCell("4. There shall be physical screening of certificates at the faculties.");
                body.addCell("5. Please note that if any discrepancies or issues are discovered with your admission credentials, academic records, or supporting documents, you will be required to withdraw from the University.");
                body.addCell("6. Congratulations on your admission.");
                PdfPTable signtbl = new PdfPTable(3);
                signtbl.setWidthPercentage(100.0F);
                try {
                    signtbl.setWidths(new int[]{5, 20, 75});
                } catch (DocumentException documentException) {
                }
                signtbl.getDefaultCell().setBorder(0);
                signtbl.addCell(space);
                Image signimg = Image.getInstance(this.settings.baseurl + "/assets/img/signatures/acdm_offc.jpg");
                signimg.setAlignment(1);
                signtbl.addCell(signimg);
                signtbl.addCell(space);
                body.addCell(signtbl);
                PdfPCell cell = new PdfPCell();
                cell.setBorder(0);
                Phrase phrase = new Phrase();
                phrase.add((Element) new Chunk("Aondover Zwawua, "));
                Chunk smallItalic = new Chunk("MCIA");
                smallItalic.setFont(FontFactory.getFont("Helvetica", 8.0F, 2));
                phrase.add((Element) smallItalic);
                cell.setPhrase(phrase);
                body.addCell(cell);
                body.addCell("Deputy Registrar (Academic Office)");
                body.addCell("For: Registrar ");
                body.addCell(space);
                QRCodeManagement qr = new QRCodeManagement();
                String encoded = "BEGIN:VCARD\nVERSION:3.0\nFN:" + fullname + "\nNOTE:Registration No: " + regno.toUpperCase() + "\\nCourse: " + coursename + "\\nSession Admitted: " + adm.getSession() + "\\nFaculty: " + adm.getCourseId().getDepartmentId().getFacultyId().getName() + "\nURL:" + this.settings.baseurl + "/verifyadm?id=" + adm.getId() + "\nEND:VCARD";
                byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);
                Image qrcode = Image.getInstance(qrcodebyte);
                PdfPTable qrtable = new PdfPTable(2);
                qrtable.setWidthPercentage(100.0F);
                try {
                    qrtable.setWidths(new int[]{80, 20});
                } catch (DocumentException documentException) {
                }
                qrtable.getDefaultCell().setBorder(0);
                PdfPCell hh = new PdfPCell(new Phrase(" "));
                hh.setHorizontalAlignment(2);
                hh.setBorder(0);
                qrtable.addCell(hh);
                qrtable.addCell(qrcode);
                body.addCell(qrtable);
                document.add((Element) body);
                try {
                    Uploadeddocuments uploads = new Uploadeddocuments("admletter_" + adm.getId());
                    uploads.setDateAdded(this.settings.getCurrentDateTime());
                    uploads.setGroupId(adm.getId());
                    uploads.setName("Admission Letter");
                    uploads.setUploadedBy(userid);
                    uploads.setUrl(docurl);
                    newUploadeddocuments(uploads);
                } catch (Exception exception) {
                }
            } catch (DocumentException | java.io.IOException documentException) {
            }
            document.close();
        } catch (Exception exception) {
        }
    }

    public void generateAdmissionLetterPG(String id, String userid) {
        try {
            String url = this.settings.documentroot + "/docs";
            String filename = "Adm_letter_" + id + ".pdf";
            String basename = url + "/" + filename;
            String docurl = "docs/" + filename;
            File loc = new File(url);
            if (!loc.exists()) {
                loc.mkdir();
            }
            Document document = new Document(PageSize.A4);
            PdfWriter pdfWriter = PdfWriter.getInstance(document, new FileOutputStream(basename));
            pdfWriter.setEncryption(null, null, -17, 1);
            pdfWriter.createXmpMetadata();
            WatermarkPageEvent watermarkEvent = new WatermarkPageEvent();
            pdfWriter.setPageEvent((PdfPageEvent) watermarkEvent);
            document.setMargins(15.0F, 15.0F, 5.0F, 5.0F);
            Objects.requireNonNull(this.settings);
            document.addAuthor("Akawe Torkula Polytechnic, MAKURDI");
            document.addCreator("Mfedoo Nig Ltd (07032163353)");
            document.addSubject(filename);
            document.addCreationDate();
            document.addTitle(filename);
            document.open();
            Admissions adm = getAdmissions(id);
            if (adm != null)
        try {
                PdfPTable body = new PdfPTable(1);
                body.setWidthPercentage(100.0F);
                try {
                    body.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                body.getDefaultCell().setBorder(0);
                PdfPTable head1 = new PdfPTable(4);
                head1.setWidthPercentage(100.0F);
                try {
                    head1.setWidths(new int[]{5, 10, 80, 5});
                } catch (DocumentException documentException) {
                }
                head1.getDefaultCell().setBorder(0);
                PdfPCell space = new PdfPCell(new Phrase(" ", new Font(Font.FontFamily.TIMES_ROMAN, 18.0F, 1, BaseColor.BLACK)));
                space.setHorizontalAlignment(1);
                space.setBorder(0);
                head1.addCell(space);
                Image image1 = Image.getInstance(this.settings.baseurl + "/" + this.settings.baseurl);
                image1.setAlignment(1);
                head1.addCell(image1);
                PdfPTable head1b = new PdfPTable(1);
                head1b.setWidthPercentage(100.0F);
                try {
                    head1b.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                head1b.getDefaultCell().setBorder(0);
                Objects.requireNonNull(this.settings);
                PdfPCell head10 = new PdfPCell(new Phrase("Akawe Torkula Polytechnic, MAKURDI".toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14.0F, 1, BaseColor.BLACK)));
                head10.setHorizontalAlignment(1);
                head10.setBorder(0);
                head1b.addCell(head10);
                Objects.requireNonNull(this.settings);
                PdfPCell head1a = new PdfPCell(new Phrase("P.M.B. 102211,MAKURDI, Nigeria", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                head1a.setHorizontalAlignment(1);
                head1a.setBorder(0);
                head1b.addCell(head1a);
                PdfPCell head1a2 = new PdfPCell(new Phrase("(Office of the Dean, Postgraduate School)", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 3, BaseColor.BLACK)));
                head1a2.setHorizontalAlignment(1);
                head1a2.setBorder(0);
                head1b.addCell(head1a2);
                head1.addCell(head1b);
                head1.addCell(space);
                body.addCell(head1);
                PdfPTable head2 = new PdfPTable(2);
                head2.setWidthPercentage(100.0F);
                try {
                    head2.setWidths(new int[]{25, 75});
                } catch (DocumentException documentException) {
                }
                head2.getDefaultCell().setBorder(0);
                head2.addCell("Date:");
                PdfPCell ad10 = new PdfPCell(new Phrase(this.settings.getTodaysdate(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad10.setHorizontalAlignment(0);
                ad10.setBorder(0);
                head2.addCell(ad10);
                head2.addCell("Applicant's Name:");
                PdfPCell ad1 = new PdfPCell(new Phrase(adm.getSurname() + " " + adm.getSurname(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad1.setHorizontalAlignment(0);
                ad1.setBorder(0);
                head2.addCell(ad1);
                head2.addCell("Registration Number:");
                PdfPCell ad2 = new PdfPCell(new Phrase(adm.getRegistrationNo().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad2.setHorizontalAlignment(0);
                ad2.setBorder(0);
                head2.addCell(ad2);
                body.addCell(head2);
                PdfPTable details = new PdfPTable(1);
                details.setWidthPercentage(100.0F);
                try {
                    details.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                details.getDefaultCell().setBorder(0);
                PdfPCell ad3 = new PdfPCell(new Phrase("PROVISIONAL OFFER OF ADMISSION", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad3.setHorizontalAlignment(1);
                ad3.setBorder(0);
                details.addCell(ad3);
                PdfPCell ad4 = new PdfPCell(new Phrase(adm.getSession() + " ACADEMIC SESSION", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad4.setHorizontalAlignment(1);
                ad4.setBorder(0);
                details.addCell(ad4);
                body.addCell(details);
                body.addCell("With reference to your application, I have the pleasure to inform you that you been offered provisional admission to pursue a Postgraduate School course leading to the award of " + adm
                        .getCourseId().getName() + " in the Department of " + adm
                                .getCourseId().getDepartmentId().getName() + " as Full Time for the session.");
                body.addCell("The programme is for a minimum duration of " + adm
                        .getCourseId().getDefaultDuration() + " semesters and a maximum duration of " + adm
                                .getCourseId().getDefaultDuration().intValue() + adm.getCourseId().getDefaultMaxSpill().intValue() + " semesters starting from " + adm
                        .getSession());
                body.addCell("Your admission is subject to the terms and conditions stated hereunder:");
                List<Feessetup> feessetupf = new ArrayList<>();
                List<Feessetup> feessetups = new ArrayList<>();
                List<Feessetup> feessetupaccept = new ArrayList<>();
                String fgi = "";
                String totam = "Not Set";
                String acceptance = "N25,000.00";
                try {
                    Feesgroup gfg = getSchoolFeesId(adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if (gfg != null) {
                        fgi = gfg.getId();
                    }
                } catch (Exception exception) {
                }
                String ind = "None";
                String sch = "None";
                String prog = "None";
                String fac = "None";
                String dept = "None";
                String course = "None";
                String level = "None";
                String campus = "None";
                String regno = "";
                String fullname = "";
                String coursename = "";
                Date dfrom = this.settings.getCurrentDateTime();
                try {
                    regno = adm.getId();
                    fullname = adm.getSurname() + " " + adm.getSurname();
                    coursename = adm.getCourseId().getName();
                    sch = adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = "" + adm.getCourseId().getSchoolProgrammeId().getProgrammeId().getId();
                    fac = adm.getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = adm.getCourseId().getDepartmentId().getId();
                    course = adm.getCourseId().getId();
                    if (adm.getStateOfOriginId().getId().intValue() == this.settings.indigeneStateCode) {
                        ind = "indigene";
                    } else {
                        ind = "non_indigene";
                    }
                    level = "" + adm.getCourseId().getDefaultMinLevel();
                    feessetupf = getFeessetup(fgi, adm.getSession(), "First", sch, prog, fac, dept, course, level, ind, campus, dfrom, adm
                            .getId());
                    feessetups = getFeessetup(fgi, adm.getSession(), "Second", sch, prog, fac, dept, course, level, ind, campus, dfrom, adm
                            .getId());
                    feessetupaccept = getFeessetup("10003", adm.getSession(), "Session", sch, prog, fac, dept, course, "None", "None", "None", dfrom, adm
                            .getId());
                    if (feessetupf.size() > 0 && feessetups.size() > 0) {
                        double totalf = feessetupf.stream().mapToDouble(Feessetup::getAmount).sum();
                        double totals = feessetups.stream().mapToDouble(Feessetup::getAmount).sum();
                        totam = "N" + this.settings.formatno.format(totalf + totals);
                        double dacceptance = feessetupaccept.stream().mapToDouble(Feessetup::getAmount).sum();
                        if (dacceptance > 0.0D) {
                            acceptance = "N" + this.settings.formatno.format(dacceptance);
                        }
                    }
                } catch (Exception exception) {
                }
                int duration = adm.getCourseId().getDefaultDuration().intValue();
                ConvertNumberToWord words = new ConvertNumberToWord();
                String inwords = words.convert(duration);
                body.addCell("1. You are expected to accept this provisional offer of admission within four weeks of the date of this letter.");
                body.addCell("2. You are required to pay a non-refundable deposit of " + acceptance + " to the Bursar, obtain a receipt for same and attach the photocopy of the receipt to your letter.");
                body.addCell("3. The admission requires that you shall pay the stipulated fees and register for each semester as contained in the academic calendar, failing which you shall be deemed to have lost the semester.");
                body.addCell("4. Note that failure to duly register for up to two (2) successive semesters (one session) shall lead to automatic loss of studentship in the University.");
                body.addCell("5. At any point during the course of the postgraduate programme you are found to have falsified any information leading to your admission or failed to pay fees each semester until you defend and submit clean copies of your dissertation you will be required to withdraw.");
                body.addCell("6. You shall not be a registered student in another Department or Faculty of this or any other University pursuing two courses concurrently.");
                body.addCell("7. You will send to us the photocopies of your certificates including NYSC Certificate of National Service and you will request your former University/College/Polytechnic to send us all your transcript.");
                body.addCell("Failure to comply with the above conditions will automatically lead to withdrawal of the offer of admission.");
                String proj = "Thesis";
                int prg = adm.getProgrammeId().getId().intValue();
                if (prg == 1004) {
                    proj = "Project";
                }
                if (prg == 1005) {
                    proj = "Dissertation";
                }
                if (prg == 1002) {
                    proj = "Thesis";
                }
                body.addCell("Details of your programme will be discussed with you at an interview with the Head of your Department on your arrival here. You are advised to obtain a copy of the current prospectus of the Postgraduate School and your Department's prospectus for further details of the courses regarding registration, courses of study, duration of programme, examinations and submissions of " + proj + ".");
                body.addCell("You are to report at the Office of the Dean, Postgraduate School for necessary screening and registration before proceeding on the programme.");
                Sessionmanager smx = getCurrentSessionManagerBySchoolAndOperation(adm.getSchoolId().getId(), "REGISTRATION");
                String regstart = "";
                String regend = "";
                if (smx != null) {
                    regstart = this.settings.formatDate(smx.getStartDate());
                    regend = this.settings.getDateAhead(regstart, 14L);
                }
                body.addCell("Registration commences from Wednesday 30th April to Friday 30th May 2025. During registration, you are to produce your ORIGINAL certificates and six passport size photographs of yourself. Registration by PROXY IS NOT ALLOWED.");
                PdfPCell signna = new PdfPCell(new Phrase("REQUEST FOR DEFERMENT OF ADMISSION WILL NOT BE ENTERTAINED", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                signna.setHorizontalAlignment(0);
                signna.setBorder(0);
                body.addCell(signna);
                body.addCell("Please find enclosed:");
                body.addCell("1 copy of Letter of Acceptance, 1 copy of Personal Data Forms, Schedule of Fees, Health Service Questionnaire and Student Entrance Medical Examination Form for your necessary action.");
                body.addCell(space);
                body.addCell("Yours faithfully,");
                PdfPTable signtbl = new PdfPTable(4);
                signtbl.setWidthPercentage(100.0F);
                try {
                    signtbl.setWidths(new int[]{2, 40, 42, 15});
                } catch (DocumentException documentException) {
                }
                signtbl.getDefaultCell().setBorder(0);
                signtbl.addCell(space);
                PdfPTable signx = new PdfPTable(1);
                signx.setWidthPercentage(100.0F);
                try {
                    signx.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                signx.getDefaultCell().setBorder(0);
                Image signimg = Image.getInstance(this.settings.baseurl + "/assets/img/signatures/pg_sec.jpg");
                signimg.setAlignment(1);
                PdfPTable signtbla = new PdfPTable(2);
                signtbla.setWidthPercentage(100.0F);
                try {
                    signtbla.setWidths(new int[]{40, 60});
                } catch (DocumentException documentException) {
                }
                signtbla.getDefaultCell().setBorder(0);
                signtbla.addCell(signimg);
                signtbla.addCell(space);
                signx.addCell(signtbla);
                PdfPCell signn = new PdfPCell(new Phrase("Mike Shima-Na Nongo", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                signn.setHorizontalAlignment(0);
                signn.setBorder(0);
                signx.addCell(signn);
                signx.addCell("Secretary, Postgraduate School");
                signtbl.addCell(signx);
                signtbl.addCell(space);
                QRCodeManagement qr = new QRCodeManagement();
                String encoded = "BEGIN:VCARD\nVERSION:3.0\nFN:" + fullname + "\nNOTE:Registration No: " + regno.toUpperCase() + "\\nCourse: " + coursename + "\\nSession Admitted: " + adm.getSession() + "\\nFaculty: " + adm.getCourseId().getDepartmentId().getFacultyId().getName() + "\nURL:" + this.settings.baseurl + "/verifyadm?id=" + adm.getId() + "\nEND:VCARD";
                byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);
                Image qrcode = Image.getInstance(qrcodebyte);
                signtbl.addCell(qrcode);
                body.addCell(signtbl);
                document.add((Element) body);
                try {
                    Uploadeddocuments uploads = new Uploadeddocuments("admletter_" + adm.getId());
                    uploads.setDateAdded(this.settings.getCurrentDateTime());
                    uploads.setGroupId(adm.getId());
                    uploads.setName("Admission Letter");
                    uploads.setUploadedBy(userid);
                    uploads.setUrl(docurl);
                    newUploadeddocuments(uploads);
                } catch (Exception exception) {
                }
            } catch (DocumentException | java.io.IOException documentException) {
            }
            document.close();
        } catch (Exception exception) {
        }
    }

    public void generateAdmissionLetterSW(String id, String userid) {
        try {
            String url = this.settings.documentroot + "/docs";
            String filename = "Adm_letter_" + id + ".pdf";
            String basename = url + "/" + filename;
            String docurl = "docs/" + filename;
            File loc = new File(url);
            if (!loc.exists()) {
                loc.mkdir();
            }
            Document document = new Document(PageSize.A4);
            PdfWriter pdfWriter = PdfWriter.getInstance(document, new FileOutputStream(basename));
            pdfWriter.setEncryption(null, null, -17, 1);
            pdfWriter.createXmpMetadata();
            WatermarkPageEvent watermarkEvent = new WatermarkPageEvent();
            pdfWriter.setPageEvent((PdfPageEvent) watermarkEvent);
            FooterPageEvent event = new FooterPageEvent();
            pdfWriter.setPageEvent((PdfPageEvent) event);
            document.setMargins(20.0F, 20.0F, 5.0F, 5.0F);
            Objects.requireNonNull(this.settings);
            document.addAuthor("Akawe Torkula Polytechnic, MAKURDI");
            document.addCreator("Mfedoo Nig Ltd (07032163353)");
            document.addSubject(filename);
            document.addCreationDate();
            document.addTitle(filename);
            document.open();
            Admissions adm = getAdmissions(id);
            if (adm != null)
        try {
                PdfPTable body = new PdfPTable(1);
                body.setWidthPercentage(100.0F);
                try {
                    body.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                body.getDefaultCell().setBorder(0);
                PdfPTable head1u = new PdfPTable(3);
                head1u.setWidthPercentage(100.0F);
                try {
                    head1u.setWidths(new int[]{45, 10, 45});
                } catch (DocumentException documentException) {
                }
                head1u.getDefaultCell().setBorder(0);
                PdfPCell space = new PdfPCell(new Phrase(" ", new Font(Font.FontFamily.TIMES_ROMAN, 18.0F, 1, BaseColor.BLACK)));
                space.setHorizontalAlignment(1);
                space.setBorder(0);
                head1u.addCell(space);
                Image image1 = Image.getInstance(this.settings.baseurl + "/" + this.settings.baseurl);
                image1.setAlignment(1);
                head1u.addCell(image1);
                head1u.addCell(space);
                PdfPTable head1b = new PdfPTable(1);
                head1b.setWidthPercentage(100.0F);
                try {
                    head1b.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                head1b.getDefaultCell().setBorder(0);
                Objects.requireNonNull(this.settings);
                PdfPCell head10 = new PdfPCell(new Phrase("Akawe Torkula Polytechnic, MAKURDI".toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14.0F, 1, BaseColor.BLACK)));
                head10.setHorizontalAlignment(1);
                head10.setBorder(0);
                head1b.addCell(head10);
                Objects.requireNonNull(this.settings);
                PdfPCell head1a = new PdfPCell(new Phrase("P.M.B. 102211,MAKURDI, Nigeria", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 0, BaseColor.BLACK)));
                head1a.setHorizontalAlignment(1);
                head1a.setBorder(0);
                head1b.addCell(head1a);
                PdfPCell head1a2 = new PdfPCell(new Phrase(adm.getCourseId().getSchoolProgrammeId().getSchoolId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 3, BaseColor.BLACK)));
                head1a2.setHorizontalAlignment(1);
                head1a2.setBorder(0);
                head1b.addCell(head1a2);
                body.addCell(head1u);
                body.addCell(head1b);
                PdfPTable head2 = new PdfPTable(2);
                head2.setWidthPercentage(100.0F);
                try {
                    head2.setWidths(new int[]{25, 75});
                } catch (DocumentException documentException) {
                }
                head2.getDefaultCell().setBorder(0);
                head2.addCell("Date:");
                PdfPCell ad10 = new PdfPCell(new Phrase(this.settings.getTodaysdate(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad10.setHorizontalAlignment(0);
                ad10.setBorder(0);
                head2.addCell(ad10);
                head2.addCell("Applicant's Name:");
                PdfPCell ad1 = new PdfPCell(new Phrase(adm.getSurname() + " " + adm.getSurname(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad1.setHorizontalAlignment(0);
                ad1.setBorder(0);
                head2.addCell(ad1);
                head2.addCell("Registration Number:");
                PdfPCell ad2 = new PdfPCell(new Phrase(adm.getRegistrationNo().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad2.setHorizontalAlignment(0);
                ad2.setBorder(0);
                head2.addCell(ad2);
                body.addCell(head2);
                PdfPTable details = new PdfPTable(1);
                details.setWidthPercentage(100.0F);
                try {
                    details.setWidths(new int[]{100});
                } catch (DocumentException documentException) {
                }
                details.getDefaultCell().setBorder(0);
                PdfPCell ad3 = new PdfPCell(new Phrase("OFFER OF PROVISIONAL ADMISSION INTO SANDWICH (UNDERGRADUATE) PROGRAMMES OF THE UNIVERSITY FOR THE " + adm.getSession() + " CONTACT SESSION", new Font(Font.FontFamily.TIMES_ROMAN, 12.0F, 1, BaseColor.BLACK)));
                ad3.setHorizontalAlignment(1);
                ad3.setBorder(0);
                details.addCell(ad3);
                body.addCell(details);
                Objects.requireNonNull(this.settings);
                body.addCell("I am pleased to inform you that you have been offered provisional admission into the " + "Akawe Torkula Polytechnic, MAKURDI" + " to pursue SANDWICH undergraduate degree course leading to " + adm
                        .getCourseId().getName());
                body.addCell(space);
                int duration = adm.getCourseId().getDefaultDuration().intValue();
                ConvertNumberToWord words = new ConvertNumberToWord();
                String inwords = words.convert(duration);
                body.addCell("The Duration of the programme is " + inwords + "(" + duration + ") contact sessions. Registration and orientation will commence on . Your admission lapse after thirteen (13) days of commencement of registration.");
                body.addCell(space);
                body.addCell("Furthermore, the admission is subject to the following conditions:");
                body.addCell(space);
                body.addCell("      1. At the time of registration, you will be required to present originals of the credentials, or any other acceptable evidence of the qualification on which this offer of admission has been based");
                body.addCell("      2. If it is discovered at any time, that you do not posses any of the qualifications, which you claimed to have obtained, you will be required to withdraw from the University.");
                List<Feessetup> feessetupf = new ArrayList<>();
                String fgi = "";
                String totam = "Not Set";
                try {
                    Feesgroup gfg = getSchoolFeesId(adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if (gfg != null) {
                        fgi = gfg.getId();
                    }
                } catch (Exception exception) {
                }
                String ind = "None";
                String sch = "None";
                String prog = "None";
                String fac = "None";
                String dept = "None";
                String course = "None";
                String level = "None";
                String campus = "None";
                String regno = "";
                String fullname = "";
                String coursename = "";
                Date dfrom = this.settings.getCurrentDateTime();
                try {
                    regno = adm.getId();
                    fullname = adm.getSurname() + " " + adm.getSurname();
                    coursename = adm.getCourseId().getName();
                    sch = adm.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = "" + adm.getCourseId().getSchoolProgrammeId().getProgrammeId().getId();
                    fac = adm.getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = adm.getCourseId().getDepartmentId().getId();
                    course = adm.getCourseId().getId();
                    if (adm.getStateOfOriginId().getId().intValue() == this.settings.indigeneStateCode) {
                        ind = "indigene";
                    } else {
                        ind = "non_indigene";
                    }
                    level = "" + adm.getCourseId().getDefaultMinLevel();
                    feessetupf = getFeessetup(fgi, adm.getSession(), "First", sch, prog, fac, dept, course, level, ind, campus, dfrom, adm
                            .getId());
                    if (feessetupf.size() > 0) {
                        double totalf = feessetupf.stream().mapToDouble(Feessetup::getAmount).sum();
                        totam = "N" + this.settings.formatno.format(totalf);
                    }
                } catch (Exception exception) {
                }
                body.addCell("      3. Fees for the programme per contact is: " + totam);
                body.addCell("All fees are payable once and online (E-payment platform) using your Registration number as User ID and password.");
                body.addCell("Please accept my congratulations on your admission");
                PdfPTable signtbl = new PdfPTable(3);
                signtbl.setWidthPercentage(100.0F);
                try {
                    signtbl.setWidths(new int[]{5, 20, 75});
                } catch (DocumentException documentException) {
                }
                signtbl.getDefaultCell().setBorder(0);
                signtbl.addCell(space);
                Image signimg = Image.getInstance(this.settings.baseurl + "/assets/img/signatures/acdm_offc.jpg");
                signimg.setAlignment(1);
                signtbl.addCell(signimg);
                signtbl.addCell(space);
                body.addCell(signtbl);
                PdfPCell cell = new PdfPCell();
                cell.setBorder(0);
                Phrase phrase = new Phrase();
                phrase.add((Element) new Chunk("Aondover Zwawua, "));
                Chunk smallItalic = new Chunk("MCIA");
                smallItalic.setFont(FontFactory.getFont("Helvetica", 8.0F, 2));
                phrase.add((Element) smallItalic);
                cell.setPhrase(phrase);
                body.addCell(cell);
                body.addCell("Deputy Registrar (Academic Office)");
                body.addCell("For: Registrar ");
                body.addCell(space);
                QRCodeManagement qr = new QRCodeManagement();
                String encoded = "BEGIN:VCARD\nVERSION:3.0\nFN:" + fullname + "\nNOTE:Registration No: " + regno.toUpperCase() + "\\nCourse: " + coursename + "\\nSession Admitted: " + adm.getSession() + "\\nFaculty: " + adm.getCourseId().getDepartmentId().getFacultyId().getName() + "\nURL:" + this.settings.baseurl + "/verifyadm?id=" + adm.getId() + "\nEND:VCARD";
                byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);
                Image qrcode = Image.getInstance(qrcodebyte);
                PdfPTable qrtable = new PdfPTable(2);
                qrtable.setWidthPercentage(100.0F);
                try {
                    qrtable.setWidths(new int[]{80, 20});
                } catch (DocumentException documentException) {
                }
                qrtable.getDefaultCell().setBorder(0);
                PdfPCell hh = new PdfPCell(new Phrase(" "));
                hh.setHorizontalAlignment(2);
                hh.setBorder(0);
                qrtable.addCell(hh);
                qrtable.addCell(qrcode);
                body.addCell(qrtable);
                document.add((Element) body);
                Uploadeddocuments uploads = new Uploadeddocuments("admletter_" + adm.getId());
                uploads.setDateAdded(this.settings.getCurrentDateTime());
                uploads.setGroupId(adm.getId());
                uploads.setName("Admission Letter");
                uploads.setUploadedBy(userid);
                uploads.setUrl(docurl);
                newUploadeddocuments(uploads);
            } catch (DocumentException | java.io.IOException documentException) {
            }
            document.close();
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void newUploadeddocuments(Uploadeddocuments data) {
        try {
            // Use merge instead of persist to handle re-generation (duplicate key)
            this.em.merge(data);
        } catch (Exception e) {
            throw new RuntimeException("Error persisting Uploadeddocuments", e);
        }
    }

    public List<Hostelapplication> getHostelapplication(String stdid) {
        List<Hostelapplication> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostelapplication h WHERE h.studentId.id = :id ORDER BY h.dateStarted DESC").setParameter("id", stdid).getResultList();
        } catch (Exception k) {
            k.printStackTrace();
        }
        return list;
    }

    public List<Hostelapplication> getHostelapplicationBySession(String sess) {
        List<Hostelapplication> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostelapplication h WHERE h.sessions = :sess ORDER BY h.dateStarted ASC").setParameter("sess", sess).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Hostelapplication> getHostelapplicationBySessionAndStatus(String sess, String status) {
        List<Hostelapplication> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostelapplication h WHERE h.sessions = :sess AND h.applicationStatus = :status ORDER BY h.dateStarted ASC").setParameter("sess", sess).setParameter("status", status).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Hostelallocation> getEmptyReservedRooms(String session, String gender) {
        List<Hostelallocation> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostelallocation h WHERE h.hostelRoomId.hostelId.gender = :gender AND h.session = :sess AND (h.studentId.id='' OR h.studentId.id IS NULL) ORDER BY h.hostelRoomId.hostelId.name ASC, h.hostelRoomId.roomNo ASC").setParameter("sess", session).setParameter("gender", gender).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public long countHostelapplicationBySessionAndStatus(String sess, String status) {
        long count = 0L;
        try {
            count = ((Long) this.em.createQuery("SELECT COUNT(h) FROM Hostelapplication h WHERE h.sessions = :sess AND h.applicationStatus = :status")
                    .setParameter("sess", sess)
                    .setParameter("status", status)
                    .getSingleResult()).longValue();
        } catch (Exception exception) {
        }
        return count;
    }

    public long countHostelapplicationByHostelSessionAndStatus(String hostel, String sess, String status) {
        long count = 0L;
        try {
            count = ((Long) this.em.createQuery("SELECT COUNT(h) FROM Hostelapplication h WHERE h.hostelId.id = :hostel AND h.sessions = :sess AND h.applicationStatus = :status")
                    .setParameter("sess", sess)
                    .setParameter("status", status)
                    .setParameter("hostel", hostel)
                    .getSingleResult()).longValue();
        } catch (Exception exception) {
        }
        return count;
    }

    public List<Hostelrooms> getHostelsRooms(String id) {
        List<Hostelrooms> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostelrooms h WHERE h.hostelId.id = :id ORDER BY h.orderValue ASC").setParameter("id", id).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Hostels> getHostelsByStatusAndGender(String status, String gender) {
        List<Hostels> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Hostels h WHERE h.status = :status AND h.gender = :gender").setParameter("status", status).setParameter("gender", gender).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public Hostelapplication getHostelapplication(String stdid, String session) {
        List<Hostelapplication> list = getHostelapplication(stdid);
        Hostelapplication det = null;
        for (Hostelapplication data : list) {
            if (data.getSessions().equalsIgnoreCase(session)) {
                det = data;
                break;
            }
        }
        return det;
    }

    public void updateAdmissionLetters() {
        try {
            List<Uploadeddocuments> list = this.em.createQuery("SELECT u FROM Uploadeddocuments u WHERE u.url like 'docs/Adm%'").getResultList();
            for (Uploadeddocuments data : list) {
                generateAdmissionLetter(data.getGroupId(), "s202410818");
            }
        } catch (Exception exception) {
        }
    }

    public void pgAdmissionLetters() {
        try {
            List<Admissions> list = this.em.createQuery("SELECT u FROM Admissions u WHERE u.schoolId.id = 'S002'").getResultList();
            for (Admissions data : list) {
                generateAdmissionLetterPG(data.getId(), "s202410818");
            }
        } catch (Exception exception) {
        }
    }

    public List<Hostelallocation> getHostelAllocationByRoomNo(String roomid) {
        List<Hostelallocation> all = new ArrayList<>();
        try {
            all = this.em.createQuery("SELECT a FROM Hostelallocation a WHERE a.hostelRoomId.id = :roomid").setParameter("roomid", roomid).getResultList();
        } catch (Exception exception) {
        }
        return all;
    }

    public void allocateRoom(String appid) {
        try {
            Hostelapplication app = (Hostelapplication) getSingleObject(Hostelapplication.class, appid);
            if (app != null) {
                Hostelallocation all = getHostelallocation(app.getStudentId().getId(), app.getSessions());
                if (all != null
                        && all.getStatus().equalsIgnoreCase("RESERVED")) {
                    all.setStatus("ALLOCATED");
                    app.setApplicationStatus("ALLOCATED");
                    app.setDateAllocated(this.settings.getCurrentDateTime());
                    updateHostelallocation(all);
                    updateHostelapplication(app);
                    Students std = app.getStudentId();
                    if (std != null) {
                        String email = (std.getUniversityEmail() != null) ? std.getUniversityEmail() : std.getPersonalEmail();
                        if (email != null) {
                            String msg = "Dear " + std.getSurname() + ", " + std.getOthernames() + ",<br/>You have been allocated Room " + all.getHostelRoomId().getRoomNo() + " in " + all.getHostelRoomId().getHostelId().getName() + "<br/>You are required to print your allocation slip and take it to the hostel/porters for documentation.<br/>Thank you.";
                            msg = this.settings.generateEmailBody(msg);
                            String title = "Hostel Room Allocation";
                            String label = "BSU Hostels";
                            MailClient mc = new MailClient();
                            try {
                                String str = mc.sendEmailWithAttachment(email, null, null, title, msg, label);
                            } catch (Exception exception) {
                            }
                        }
                    }
                }
            }
        } catch (Exception exception) {
        }
    }

    public void autoReserveRooms() {
        try {
            List<Hostelapplication> all = (List<Hostelapplication>) em.createQuery(
                    "SELECT a FROM Hostelapplication a WHERE a.applicationStatus = 'PENDING' ORDER BY a.dateStarted ASC")
                    .getResultList();
            for (Hostelapplication data : all) {
                List<Payments> payap = this.getPaymentsByRegnoSessSemFeesgroup(data.getStudentId().getId(), "10160",
                        data.getSessions(), "Session");
                if (payap.size() > 0) {
                    String com = this.reserveRoom(data.getId());
                }
            }
        } catch (Exception ka) {
        }
    }

    public void reserveRoomSingle(String stdid, String session, String roomid) {
        try {
            Hostelapplication app = getHostelapplication(stdid, session);
            if (app != null && (app.getApplicationStatus().equalsIgnoreCase("PENDING") || app
                    .getApplicationStatus().equalsIgnoreCase("RESERVED"))) {
                Hostelallocation hallo = getHostelallocation(stdid, session);
                if (hallo != null
                        && hallo.getStatus().equalsIgnoreCase("RESERVED")) {
                    deleteHostelallocation(hallo.getId());
                }
                app.setApplicationStatus("RESERVED");
                app.setDateAllocated(this.settings.getCurrentDateTime());
                updateHostelapplication(app);
                Hostelallocation ha = (Hostelallocation) getSingleObject(Hostelallocation.class, roomid);
                if (ha != null) {
                    ha.setDateAdded(this.settings.getCurrentDateTime());
                    ha.setStudentId(app.getStudentId());
                    updateRecord(ha);
                    Students std = app.getStudentId();
                    if (std != null) {
                        String email = (std.getUniversityEmail() != null) ? std.getUniversityEmail() : std.getPersonalEmail();
                        if (email != null) {
                            String msg = "Dear " + std.getSurname() + ", " + std.getOthernames() + ",<br/>You have been resevred Room " + ha.getHostelRoomId().getRoomNo() + " of " + ha.getHostelRoomId().getHostelId().getName() + " in " + ha.getHostelRoomId().getHostelId().getLocation() + "<br/>You are required to pay the stipulated accommodation fees within 48 hours to keep the room otherwise it will be revoked and reallocated to another student.<br/>Kindly login to the portal and make payment in order to take ownership of the room.<br/><br/>Thank you.";
                            msg = this.settings.generateEmailBody(msg);
                            String title = "Hostel Room Reservation";
                            String label = "BSU Hostels";
                            MailClient mc = new MailClient();
                            try {
                                String str = mc.sendEmailWithAttachment(email, null, null, title, msg, label);
                            } catch (Exception exception) {
                            }
                        }
                    }
                }
            }
        } catch (Exception exception) {
        }
    }

    public String reserveRoom(String appid) {
        String com = "";
        try {
            Hostelapplication app = (Hostelapplication) this.getSingleObject(Hostelapplication.class, appid);
            if (app != null) {
                if (app.getApplicationStatus().equalsIgnoreCase("PENDING")) {
                    List<Hostelrooms> hrl = this.getHostelsRooms(app.getHostelId().getId());
                    boolean found = false;
                    for (Hostelrooms hrdata : hrl) {
                        List<Hostelallocation> hallo = (List<Hostelallocation>) em
                                .createQuery("SELECT a FROM Hostelallocation a WHERE a.hostelRoomId.id = :roomid")
                                .setParameter("roomid", hrdata.getId())
                                .getResultList();
                        if (hallo.size() < hrdata.getMaxCapacity()) {
                            found = true;
                            app.setApplicationStatus("RESERVED");
                            this.updateHostelapplication(app);
                            String id = app.getSessions().split("/")[0]
                                    + hrdata.getId()
                                    + settings.generateId("", 4);
                            Hostelallocation ha = new Hostelallocation(id);
                            ha.setDateAdded(settings.getCurrentDateTime());
                            ha.setHostelRoomId(hrdata);
                            ha.setSession(app.getSessions());
                            ha.setStatus("RESERVED");
                            ha.setStudentId(app.getStudentId());
                            this.newHostelallocation(ha);
                            Students std = app.getStudentId();
                            if (std != null) {
                                String email = std.getUniversityEmail() != null ? std.getUniversityEmail()
                                        : std.getPersonalEmail();
                                if (email != null) {
                                    String msg = "Dear " + std.getSurname() + ", " + std.getOthernames() + ",<br/>"
                                            + "You have been resevred Room " + hrdata.getRoomNo() + " in "
                                            + hrdata.getHostelId().getName() + "<br/>"
                                            + "You are required to pay the stipulated accommodation fees within 48 hours to keep the room otherwise it will be revoked and reallocated to another student.<br/>"
                                            + "Kindly login to the portal and make payment in order to take ownership of the room.<br/><br/>"
                                            + "Thank you.";
                                    msg = settings.generateEmailBody(msg);
                                    String title = "Hostel Room Reservation";
                                    String label = "BSU Hostels";
                                    MailClient mc = new MailClient();
                                    try {
                                        String te = mc.sendEmailWithAttachment(email, null, null, title, msg, label);
                                    } catch (Exception k) {
                                    }
                                }
                            }

                            break;
                        }
                    }
                    if (found) {
                        com = "SUCCESS";
                    } else {
                        com = "All rooms has been fully booked";
                    }
                }
                if (app.getApplicationStatus().equalsIgnoreCase("RESERVED")) {
                    com = "Already Reserved";
                }
                if (app.getApplicationStatus().equalsIgnoreCase("ALLOCATED")) {
                    com = "Already Allocated";
                }

            } else {
                com = "No application found";
            }
        } catch (Exception k) {
            k.printStackTrace();
        }
        return com;
    }

    @Transactional
    public void newHostelallocation(Hostelallocation obj) {
        try {
            this.em.persist(obj);
        } catch (Exception e) {
            throw new RuntimeException("Error persisting Hostelallocation", e);
        }
    }

    @Transactional
    public void updateHostelallocation(Hostelallocation adm) {
        try {
            this.em.createQuery("UPDATE Hostelallocation p SET p.status = :a WHERE p.id = :id")
                    .setParameter("a", adm.getStatus())
                    .setParameter("id", adm.getId())
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Hostelallocation status", e);
        }
    }

    @Transactional
    public void updateHostelapplication(Hostelapplication adm) {
        try {
            this.em.createQuery("UPDATE Hostelapplication p SET p.applicationStatus = :a WHERE p.id = :id")
                    .setParameter("a", adm.getApplicationStatus())
                    .setParameter("id", adm.getId())
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Hostelapplication status", e);
        }
    }

    public Hostelallocation getHostelallocation(String stdid, String session) {
        Hostelallocation all = null;
        try {
            all = (Hostelallocation) this.em.createQuery("SELECT h FROM Hostelallocation h WHERE h.studentId.id = :stdid AND h.session = :sess").setParameter("stdid", stdid).setParameter("sess", session).setMaxResults(1).getSingleResult();
        } catch (Exception ka) {
            ka.printStackTrace();
        }
        return all;
    }

    public Paymentreference getPaymentreferenceingle(String fgi, String regno, String session, String semester) {
        Paymentreference pr = null;
        try {
            List<Paymentreference> lpr = this.em.createQuery("SELECT p FROM Paymentreference p WHERE p.feesGroupId.id = :fgi AND p.payerId = :regno AND p.session = :sess AND p.semester = :sem").setParameter("fgi", fgi).setParameter("regno", regno).setParameter("sess", session).setParameter("sem", semester).getResultList();
            if (lpr.size() > 0) {
                pr = lpr.get(0);
            }
        } catch (Exception exception) {
        }
        return pr;
    }

    public List<Feeswaiver> getFeeswaiverBySession(String sess) {
        List<Feeswaiver> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT h FROM Feeswaiver h WHERE h.sessionAdded = :sess ORDER BY h.dateAdded DESC").setParameter("sess", sess).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Courses> getAllCourses() {
        List<Courses> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT c FROM Courses c ORDER BY c.name", Courses.class).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Schoolprogrammes> getAllSchoolprogrammes() {
        List<Schoolprogrammes> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT sp FROM Schoolprogrammes sp ORDER BY sp.schoolId.name, sp.programmeId.name", Schoolprogrammes.class).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Departments> getDepartmentsBySchool(String schoolId) {
        List<Departments> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT DISTINCT d FROM Departments d JOIN Courses c ON c.departmentId = d WHERE c.schoolProgrammeId.schoolId.id = :schoolId ORDER BY d.name", Departments.class).setParameter("schoolId", schoolId).getResultList();
            if (list.isEmpty()) {
                System.out.println("DEBUG: No departments found with existing courses for school " + schoolId + ", returning all departments");
                list = getAllDepartments();
            }
        } catch (Exception k) {
            System.out.println("DEBUG: Error in getDepartmentsBySchool: " + k.getMessage());
            k.printStackTrace();
            list = getAllDepartments();
        }
        return list;
    }

    public List<Users> getAllStaff() {
        List<Users> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Users u WHERE u.userType = 'STAFF' ORDER BY u.surname, u.othernames", Users.class).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Positions> getAllPositions() {
        List<Positions> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT p FROM Positions p ORDER BY p.name", Positions.class).getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    public List<Units> getAllUnits() {
        List<Units> list = new ArrayList<>();
        try {
            list = this.em.createQuery("SELECT u FROM Units u ORDER BY u.name ASC").getResultList();
        } catch (Exception exception) {
        }
        return list;
    }

    @Transactional
    public void updateObject(Object obj) {
        try {
            this.em.merge(obj);
        } catch (Exception exception) {
        }
    }

    @Transactional
    public void updateCourse(String courseId, String name, String code, String schoolProgrammeId, String departmentId, String headId, String headTitle, Integer defaultMinLevel, Integer defaultMaxLevel, Integer defaultMaxSpill, Integer defaultDuration, String entryRequirements) {
        try {
            this.em.createNativeQuery("UPDATE courses SET name = ?1, code = ?2, school_programme_id = ?3, department_id = ?4, head_id = ?5, head_title = ?6, default_min_level = ?7, default_max_level = ?8, default_max_spill = ?9, default_duration = ?10, entry_requirements = ?11 WHERE id = ?12")
                    .setParameter(1, name)
                    .setParameter(2, code)
                    .setParameter(3, schoolProgrammeId)
                    .setParameter(4, departmentId)
                    .setParameter(5, headId)
                    .setParameter(6, headTitle)
                    .setParameter(7, defaultMinLevel)
                    .setParameter(8, defaultMaxLevel)
                    .setParameter(9, defaultMaxSpill)
                    .setParameter(10, defaultDuration)
                    .setParameter(11, entryRequirements)
                    .setParameter(12, courseId)
                    .executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating Course", e);
        }
    }
}
