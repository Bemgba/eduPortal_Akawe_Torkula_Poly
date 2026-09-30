/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet;

import com.mnl.eduportal.entities.Admissions;
import com.mnl.eduportal.entities.Accounts;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.entities.Feesgroup;
import com.mnl.eduportal.entities.Lgas;
import com.mnl.eduportal.entities.Pages;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Programmes;
import com.mnl.eduportal.entities.Roles;
import com.mnl.eduportal.entities.Schoolprogrammes;
import com.mnl.eduportal.entities.Schools;
import com.mnl.eduportal.entities.Semesterregistrationcourses;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.Staff;
import com.mnl.eduportal.entities.States;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.entities.Uploadeddocuments;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FileTypeDetector;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author eaglescan
 */
public class AjaxServlet extends HttpServlet {
    
    @Inject
    private MainSession sess;
    
    Settings settings = new Settings();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String targetId = request.getParameter("id");
        String id2 = request.getParameter("id2");
        String id3 = request.getParameter("id3");
        StringBuilder sb = new StringBuilder();
        if (targetId != null) {
            targetId = targetId.trim().toLowerCase();
        }
        
        if (action.equals("loadItemsAndSessions")) {
            if ("".equals(id2)) {
            } else {
                List<Feesgroup> lfg = sess.getFeesgroupBySchoolAndCategory(id2, "ALL");
                
                // Auto-create SCHOOL FEES fee group if none exists for this school
                if (lfg.isEmpty()) {
                    try {
                        Schools school = sess.getSchools(id2);
                        if (school != null) {
                            String fgId = "SF" + id2 + settings.generateId("", 3);
                            Feesgroup fg = new Feesgroup(fgId);
                            fg.setName("SCHOOL FEES");
                            fg.setSchoolId(school);
                            fg.setAccountId((Accounts) sess.getSingleObject(Accounts.class, 100));
                            fg.setDescription("School fees for " + school.getName());
                            fg.setSessionSemester("Session");
                            fg.setRepeatPayment("Yes");
                            fg.setCategory("Students");
                            fg.setVisibility("Public");
                            sess.newEntry(fg);
                            
                            // Refresh the list
                            lfg = sess.getFeesgroupBySchoolAndCategory(id2, "ALL");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                
                Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation(id2, "REGISTRATION");
                String sessions = "";
                String initsess = settings.listSession;
                try {
                    if (sm != null) {
                        sessions = sm.getName();
                        sessions = settings.getSessionAfter(sessions);
                    }
                } catch (Exception k) {
                }
                
                sb.append("<option value=\"\">Select Fees Item</option>");
                if (!lfg.isEmpty()) {
                    for (Feesgroup data : lfg) {
                        sb.append("<option value=\"").append(data.getId()).append("\">").append(data.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                sb.append("::");
                sb.append("<option value=\"\">Select Session</option>");
                if (sessions.length() > 0) {
                    while (sessions.compareTo(initsess) >= 0) {
                        sb.append("<option value=\"").append(sessions).append("\">").append(sessions).append("</option>");
                        sessions = settings.getSessionBefore(sessions);
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadDodument")) {
            if ("".equals(id2)) {
            } else {
                
                Uploadeddocuments docs = (Uploadeddocuments) sess.getSingleObject(Uploadeddocuments.class, id2);
                if (docs != null) {
                    if (docs.getUrl() != null) {
                        String mime = FileTypeDetector.getMimeType(docs.getUrl());
                        String url = settings.docUrl + "/" + docs.getUrl();
                        sb.append("<object data=\"").append(url).append("\" type=\"").append(mime).append("\" width=\"100%\" height=\"600px\">");
                        sb.append("<p>Your browser does not support displaying this file. <a href=\"").append(url).append("\">Download it instead</a>.</p>");
                        sb.append("</object>");
                    }
                    
                } else {
                    sb.append("Document not found");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadState")) {
            if ("".equals(targetId)) {
            } else {
                
                List<States> lgas = sess.getAllStatesInCountry(Integer.valueOf(targetId));
                
                sb.append("<option value=\"\">Select LGA</option>");
                if (!lgas.isEmpty()) {
                    for (States city : lgas) {
                        sb.append("<option value=\"").append(city.getId()).append("\">").append(city.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        if (action.equals("loadPages")) {
            if ("".equals(id2)) {
            } else {
                List<Pages> userl = sess.getAllPagesforRole(id2);
                if (!userl.isEmpty()) {
                    sb.append("<table class=\"table table-striped table-hover\">");
                    sb.append("<thead>");
                    sb.append("<tr>");
                    sb.append("<th class=\"center\">#</th>");
                    sb.append("<th>Page Name</th>");
                    sb.append("<th>Menu</th>");
                    sb.append("<th>Users</th>");
                    sb.append("</tr>");
                    sb.append("</thead>");
                    sb.append("<tbody>");
                    int i = 1;
                    for (Pages usd : userl) {
                        
                        sb.append("<tr>");
                        sb.append("<td class=\"center\">").append(i).append("</td>");
                        sb.append("<td>").append(usd.getDescription()).append("</td>");
                        sb.append("<td>").append(usd.getManuId().getName()).append("</td>");
                        String users = "";
                        try {
                            String[] ttx = usd.getRoles().split(";");
                            for (String rox : ttx) {
                                Integer in = 0;
                                try {
                                    in = Integer.valueOf(rox);
                                } catch (NumberFormatException k) {
                                }
                                Roles ro = sess.getRoles(in);
                                if (ro != null) {
                                    users += (ro.getName() + ", ");
                                }
                            }
                        } catch (Exception k) {
                        }
                        sb.append("<td>").append(users).append("</td>");
                        sb.append("</tr>");
                        i++;
                        
                    }
                    
                    sb.append("</tbody>");
                    sb.append("</table>");
                } else {
                    sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        if (action.equals("loadUsers")) {
            if ("".equals(id2)) {
            } else {
                
                List<Users> userl = sess.getUsersByRole(id2);
                if (!userl.isEmpty()) {
                    sb.append("<table class=\"table table-striped table-hover\">");
                    sb.append("<thead>");
                    sb.append("<tr>");
                    sb.append("<th class=\"center\">#</th>");
                    sb.append("<th>Staff No</th>");
                    sb.append("<th>Full Name</th>");
                    sb.append("<th>Phone Noe</th>");
                    sb.append("<th>Email Address</th>");
                    sb.append("</tr>");
                    sb.append("</thead>");
                    sb.append("<tbody>");
                    int i = 1;
                    for (Users usd : userl) {
                        Staff stf = sess.getStaffById(usd.getId());
                        if (stf != null) {
                            sb.append("<tr>");
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            sb.append("<td>").append(stf.getStaffNo().toUpperCase()).append("</td>");
                            sb.append("<td class=\"right\">").append(stf.getSurname()).append(" ").append(stf.getOthernames()).append("</td>");
                            sb.append("<td>").append(stf.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(stf.getOfficialEmailAddress()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                    }
                    
                    sb.append("</tbody>");
                    sb.append("</table>");
                } else {
                    sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("getCoursesTakingsemco")) {
            if ("".equals(id2)) {
            } else {
                List<Semesterregistrationcourses> list = sess.getSemesterregistrationcoursesBySemestercourseid(id2);
                
                if (!list.isEmpty()) {
                    sb.append("<table class=\"table table-striped table-hover\">");
                    sb.append("<thead>");
                    sb.append("<tr>");
                    sb.append("<th class=\"center\">#</th>");
                    sb.append("<th>Course</th>");
                    sb.append("<th>Type</th>");
                    sb.append("<th>Level</th>");
                    sb.append("<th>Credit Unit</th>");
                    sb.append("<th>Semester</th>");
                    sb.append("<th>Per. Practicals</th>");
                    sb.append("<th>Per. CA</th>");
                    sb.append("<th>Per. Exam</th>");
                    sb.append("</tr>");
                    sb.append("</thead>");
                    sb.append("<tbody>");
                    int i = 1;
                    for (Semesterregistrationcourses pay : list) {
                        sb.append("<tr>");
                        sb.append("<td class=\"center\">").append(i).append("</td>");
                        sb.append("<td>").append(pay.getCourseId().getName()).append("</td>");
                        sb.append("<td>").append(pay.getCourseType()).append("</td>");
                        sb.append("<td>").append(pay.getLevel()).append("</td>");
                        sb.append("<td>").append(pay.getCreditUnit()).append("</td>");
                        sb.append("<td>").append(pay.getSemester()).append("</td>");
                        sb.append("<td>").append(pay.getPerPractical()).append("</td>");
                        sb.append("<td>").append(pay.getPerca()).append("</td>");
                        sb.append("<td>").append(pay.getPerexam()).append("</td>");
                        sb.append("</tr>");
                        i++;
                    }
                    
                    sb.append("</tbody>");
                    sb.append("</table>");
                    sb.append("</div>");
                } else {
                    sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        if (action.equals("loadPayment1")) {
            if ("".equals(id2)) {
            } else {
                
                if (id2 != null && id2.contains(";")) {
                    String[] split = id2.split(";");
                    String itemid = split[0];
                    String sc = split[1];
                    String month = split[2];
                    List<Payments> list = sess.listPaymentByItemSchoolMonth(itemid, sc, month);
                    if (!list.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Reference No</th>");
                        sb.append("<th class=\"right\">Amount</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Date Paid</th>");
                        sb.append("<th>Session</th>");
                        sb.append("<th>Semester</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Payments pay : list) {
                            sb.append("<tr>");
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String link = "href=\"/DownloadReceipt?id=" + pay.getId() + "\" target=\"_blank\"";
                            sb.append("<td><a ").append(link).append(" class=\"btn btn-link px-0\">").append(pay.getId()).append("</a></td>");
                            sb.append("<td class=\"right\">").append(settings.formatno.format(pay.getAmount())).append("</td>");
                            sb.append("<td>").append(pay.getPayerFullname()).append("</td>");
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String formattedDate = sdf.format(pay.getDatePaid());
                            sb.append("<td>").append(formattedDate).append("</td>");
                            sb.append("<td>").append(pay.getSessionPaid()).append("</td>");
                            sb.append("<td>").append(pay.getSemesterPaid()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        sb.append("</div>");
                    } else {
                        sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                    }
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadPayment3")) {
            if ("".equals(id2)) {
            } else {
                
                if (id2 != null && id2.contains(";")) {
                    String[] split = id2.split(";");
                    String itemid = split[0];
                    String sc = split[1];
                    String sessiond = split[2];
                    sessiond = sessiond.replaceAll("_", "/");
                    String semester = split[3];
                    List<Payments> list = sess.listPaymentByItemSchoolSessionSemester(itemid, sc, sessiond, semester);
                    if (!list.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Reference No</th>");
                        sb.append("<th class=\"right\">Amount</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Date Paid</th>");
                        sb.append("<th>Registration No</th>");
                        sb.append("<th>Course</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Payments pay : list) {
                            sb.append("<tr>");
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String link = "href=\"/DownloadReceipt?id=" + pay.getId() + "\" target=\"_blank\"";
                            sb.append("<td><a ").append(link).append(" class=\"btn btn-link px-0\">").append(pay.getId()).append("</a></td>");
                            sb.append("<td class=\"right\">").append(settings.formatno.format(pay.getAmount())).append("</td>");
                            sb.append("<td>").append(pay.getPayerFullname()).append("</td>");
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String formattedDate = sdf.format(pay.getDatePaid());
                            sb.append("<td>").append(formattedDate).append("</td>");
                            String regno = pay.getPayerId();
                            Students std = sess.getStudentsById(pay.getPayerId());
                            if (std != null) {
                                regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                            }
                            sb.append("<td>").append(regno).append("</td>");
                            sb.append("<td>").append(pay.getCourseId().getName()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        sb.append("</div>");
                    } else {
                        sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                    }
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("viewPayments")) {
            if ("".equals(id2) && "".equals(id3)) {
            } else {
                
                try {
                    if (id2 != null && id3 != null && id3.contains("_")) {
                        String[] schools = id2.split("_");
                        String xdate = id3.replaceAll("_", "-");
                        List<Payments> payl = new ArrayList();
                        for (String sc : schools) {
                            List<Payments> dd = sess.viewPaymentsBySchoolAndDateRange(sc, xdate, xdate);
                            payl.addAll(dd);
                        }
                        
                        if (!payl.isEmpty()) {
                            sb.append("<table class=\"table table-striped table-hover\">");
                            sb.append("<thead>");
                            sb.append("<tr>");
                            sb.append("<th class=\"center\">#</th>");
                            sb.append("<th>Reference No</th>");
                            sb.append("<th class=\"right\">Amount</th>");
                            sb.append("<th>Registration No</th>");
                            sb.append("<th>Course</th>");
                            sb.append("<th>Full Name</th>");
                            sb.append("<th>Date Paid</th>");
                            sb.append("<th>Session</th>");
                            sb.append("<th>Semester</th>");
                            sb.append("</tr>");
                            sb.append("</thead>");
                            sb.append("<tbody>");
                            int i = 1;
                            for (Payments pay : payl) {
                                String regno = pay.getPayerRegistrationNo();
                                try{
                                    Students stx = sess.getStudentsById(pay.getPayerId());
                                    if(stx != null){
                                        regno = stx.getMatricNo() != null ? stx.getMatricNo() : stx.getRegistrationNo();
                                    }
                                }catch(Exception k){}
                                sb.append("<td class=\"center\">").append(i).append("</td>");
                                String link = "href=\"/DownloadReceipt?id=" + pay.getId() + "\" target=\"_blank\"";
                                sb.append("<td><a ").append(link).append(" class=\"btn btn-link px-0\">").append(pay.getId()).append("</a></td>");
                                sb.append("<td class=\"right\">").append(settings.formatno.format(pay.getAmount())).append("</td>");
                                sb.append("<td>").append(regno).append("</td>");
                                sb.append("<td>").append(pay.getCourseId().getName()).append("</td>");
                                sb.append("<td>").append(pay.getPayerFullname()).append("</td>");
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String formattedDate = sdf.format(pay.getDatePaid());
                                sb.append("<td>").append(formattedDate).append("</td>");
                                sb.append("<td>").append(pay.getSessionPaid()).append("</td>");
                                sb.append("<td>").append(pay.getSemesterPaid()).append("</td>");
                                sb.append("</tr>");
                                i++;
                            }
                            
                            sb.append("</tbody>");
                            sb.append("</table>");
                            sb.append("</div>");
                        } else {
                            sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                        }
                    }
                } catch (Exception k) {
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        if (action.equals("viewStaffDetails")) {
            if ("".equals(id2)) {
            } else {
                
                Staff stf = sess.getStaffById(id2);
                if (stf != null) {
                    sb.append("<table class=\"table table-striped table-hover\">");
                    sb.append("<tbody>");
                    sb.append("<tr>");
                    sb.append("<td>Staff No</td>");
                    sb.append("<td>").append(stf.getStaffNo().toUpperCase()).append("</td>");
                    String role = "";
                    try {
                        Users usd = sess.getUsers(stf.getId());
                        if (usd != null) {
                            role = usd.getDefaultRole().getName();
                        }
                    } catch (Exception k) {
                    }
                    sb.append("<td>Role</td>");
                    sb.append("<td>").append(role).append("</td>");
                    sb.append("<td>Full Name</td>");
                    sb.append("<td>").append(stf.getSurname()).append(" ").append(stf.getOthernames()).append("</td>");
                    sb.append("<td>Phone Noo</td>");
                    sb.append("<td>").append(stf.getPhoneNo()).append("</td>");
                    sb.append("<td>University Email</td>");
                    sb.append("<td>").append(stf.getOfficialEmailAddress()).append("</td>");
                    sb.append("</tr>");
                    sb.append("</tbody>");
                    sb.append("</table>");
                } else {
                    sb.append("<div class=\"alert alert-warning\">No record found!</div>");
                }
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        if (action.equals("updatePaymentRef")) {
            if ("".equals(targetId)) {
            } else {
                
                Paymentreference pr = sess.updatePaymentReference(targetId);
                
                if (pr != null) {
                    String sty = "danger";
                    String status = pr.getPaidStatus();
                    String labe = "Not found";
                    String link = "href=\"#\"";
                    
                    if (pr.getPaidStatus().equalsIgnoreCase("PAID")) {
                        sty = "success";
                        link = "href=\"/DownloadReceipt?id=" + pr.getId() + "\" target=\"_blank\"";
                        labe = "Download Receipt";
                    }
                    String idx = "<span class=\"alert alert-" + sty + "\">" + status + "</span>";
                    String idy = "<a " + link + " class=\"btn btn-link px-0\">" + labe + "</a>";
                    sb.append(idx);
                    sb.append("::");
                    sb.append(idy);
                    
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadlga")) {
            if ("".equals(targetId)) {
            } else {
                
                List<Lgas> lgas = sess.getAllLgasInStte(Integer.valueOf(targetId));
                
                sb.append("<option value=\"\">Select LGA</option>");
                if (!lgas.isEmpty()) {
                    for (Lgas city : lgas) {
                        sb.append("<option value=\"").append(city.getId()).append("\">").append(city.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadSessions")) {
            String schoolId = request.getParameter("schoolId");
            if (schoolId == null || schoolId.isEmpty()) {
                sb.append("<option value=\"\">Please select a school first</option>");
            } else {
                try {
                    Sessionmanager smx = sess.getCurrentSessionManagerBySchoolAndOperation(schoolId, "REGISTRATION");
                    
                    if (smx != null) {
                        String start = settings.listSession;
                        String currsess = smx.getName();
                        
                        sb.append("<option value=\"\">Select Session</option>");
                        
                        while (currsess.compareToIgnoreCase(start) >= 0) {
                            sb.append("<option value=\"").append(currsess).append("\">").append(currsess).append("</option>");
                            currsess = settings.getSessionBefore(currsess);
                        }
                    } else {
                        sb.append("<option value=\"\">No sessions available for this school</option>");
                    }
                } catch (Exception e) {
                    sb.append("<option value=\"\">Error loading sessions</option>");
                    e.printStackTrace();
                }
            }
            
            response.setContentType("text/html");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(sb.toString());
        }
        
        if (action.equals("loadSchoolProgrammes")) {
            if ("".equals(id2)) {
            } else {
                
                List<Programmes> lgas = sess.getAllProgrammesBySchool(id2);
                
                sb.append("<option value=\"\">Select Programme</option>");
                if (!lgas.isEmpty()) {
                    for (Programmes city : lgas) {
                        sb.append("<option value=\"").append(city.getId()).append("\">").append(city.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadCourses")) {
            if ("".equals(id2)) {
            } else {
                
                List<Courses> lgas = sess.getCoursesBySchoolAndProgramme(id2, id3);
                
                sb.append("<option value=\"\">Select Course</option>");
                if (!lgas.isEmpty()) {
                    for (Courses city : lgas) {
                        sb.append("<option value=\"").append(city.getId()).append("\">").append(city.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">Not applicable</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadCoursesBySchoolFaculty")) {
            String schoolId = request.getParameter("schoolId");
            String facultyId = request.getParameter("facultyId");
            
            if (schoolId != null && facultyId != null && !schoolId.isEmpty() && !facultyId.isEmpty()) {
                List<Courses> courses = sess.getCoursesBySchoolAndFaculty(schoolId, facultyId);
                
                sb.append("<option value=\"\">Select Course</option>");
                if (!courses.isEmpty()) {
                    for (Courses course : courses) {
                        sb.append("<option value=\"").append(course.getId()).append("\">").append(course.getName()).append("</option>");
                    }
                } else {
                    sb.append("<option value=\"NA\">No courses found</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadDepartmentsBySchoolProgramme")) {
            String schoolProgrammeId = request.getParameter("schoolProgrammeId");
            
            System.out.println("DEBUG: loadDepartmentsBySchoolProgramme called with schoolProgrammeId: " + schoolProgrammeId);
            
            if (schoolProgrammeId != null && !schoolProgrammeId.isEmpty()) {
                try {
                    Schoolprogrammes sp = (Schoolprogrammes) sess.getSingleObject(Schoolprogrammes.class, schoolProgrammeId);
                    if (sp != null) {
                        System.out.println("DEBUG: Found school programme: " + sp.getSchoolId().getName() + " - " + sp.getProgrammeId().getName());
                        
                        // Use improved method that falls back to all departments if none found for school
                        List<Departments> departments = sess.getDepartmentsBySchool(sp.getSchoolId().getId());
                        System.out.println("DEBUG: Found " + departments.size() + " departments for school: " + sp.getSchoolId().getId());
                        
                        for (Departments dept : departments) {
                            System.out.println("DEBUG: Department - " + dept.getId() + ": " + dept.getName());
                            sb.append("<option value=\"").append(dept.getId()).append("\">")
                              .append(dept.getName()).append("</option>");
                        }
                    } else {
                        System.out.println("DEBUG: School programme not found for ID: " + schoolProgrammeId);
                    }
                } catch (Exception e) {
                    System.out.println("DEBUG: Error in loadDepartmentsBySchoolProgramme: " + e.getMessage());
                    e.printStackTrace();
                }
                
                if (sb.length() == 0) {
                    sb.append("<option value=\"\">No departments found</option>");
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("loadsesssem")) {
            if ("".equals(targetId)) {
            } else {
                Feesgroup fg = (Feesgroup) sess.getSingleObject(Feesgroup.class, targetId);
                
                if (fg != null) {
                    if (fg.getSessionSemester().equalsIgnoreCase("Semester")) {
                        sb.append("<option value=\"First\">First</option>");
                        sb.append("<option value=\"Second\">Second</option>");
                    } else {
                        sb.append("<option value=\"Session\">Session</option>");
                    }
                }
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("viewStudentsa")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "1");
                    List<Students> com2 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "0");
                    com1.addAll(com2);
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        
        if (action.equals("viewStudentsb")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatusIndigene(course, lev, sessd, sem, "1");
                    List<Students> com2 = sess.getStudentsByCourseLevelatSessionSemesterRegstatusIndigene(course, lev, sessd, sem, "0");
                    com1.addAll(com2);
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentsc")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatusNoIndigene(course, lev, sessd, sem, "1");
                    List<Students> com2 = sess.getStudentsByCourseLevelatSessionSemesterRegstatusNoIndigene(course, lev, sessd, sem, "0");
                    com1.addAll(com2);
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentsd")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    
                    List<Students> paid = sess.getStudentsByCourseLevelatSessionSemesterPayment(course, lev, sessd, sem);
                    if (!paid.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : paid) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentse")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    
                    List<Students> paid = sess.getStudentsByCourseLevelatSessionSemesterPaymentIndigene(course, lev, sessd, sem);
                    if (!paid.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : paid) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentsf")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    
                    List<Students> paid = sess.getStudentsByCourseLevelatSessionSemesterPaymentNoIndigene(course, lev, sessd, sem);
                    if (!paid.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : paid) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentsg")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "1");
                    List<Students> com2 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "0");
                    com1.addAll(com2);
                    List<Students> paid = sess.getStudentsByCourseLevelatSessionSemesterPayment(course, lev, sessd, sem);
                    com1.removeAll(paid);
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        
        if (action.equals("viewStudentsj")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "1");
                    
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        if (action.equals("viewStudentsk")) {
            if ("".equals(id2)) {
            } else {
                if (id2 != null && id2.contains("_")) {
                    String[] splitter = id2.split("_");
                    String course = "";
                    String lev = "";
                    String sessd = "";
                    String sem = "";
                    try {
                        course = splitter[0];
                        course = course.toUpperCase();
                        lev = splitter[1];
                        String xsess1 = splitter[2];
                        String xsess2 = splitter[3];
                        sem = splitter[4];
                        String tmp = sem.substring(0, 1).toUpperCase() + sem.substring(1);
                        sem = tmp;
                        sessd = xsess1 + "/" + xsess2;
                    } catch (Exception k) {
                    }
                    List<Students> com1 = sess.getStudentsByCourseLevelatSessionSemesterRegstatus(course, lev, sessd, sem, "0");
                    
                    if (!com1.isEmpty()) {
                        sb.append("<table class=\"table table-striped table-hover\">");
                        sb.append("<thead>");
                        sb.append("<tr>");
                        sb.append("<th class=\"center\">#</th>");
                        sb.append("<th>Matric No No</th>");
                        sb.append("<th>Full Name</th>");
                        sb.append("<th>Phone No</th>");
                        sb.append("<th>Email Adress</th>");
                        sb.append("</tr>");
                        sb.append("</thead>");
                        sb.append("<tbody>");
                        int i = 1;
                        for (Students data : com1) {
                            sb.append("<td class=\"center\">").append(i).append("</td>");
                            String regn = data.getMatricNo() != null ? data.getMatricNo() : data.getRegistrationNo();
                            sb.append("<td>").append(regn).append("</td>");
                            sb.append("<td>").append(data.getSurname()).append(" ").append(data.getOthernames()).append("</td>");
                            sb.append("<td>").append(data.getPhoneNo()).append("</td>");
                            sb.append("<td>").append(data.getUniversityEmail()).append("</td>");
                            sb.append("</tr>");
                            i++;
                        }
                        
                        sb.append("</tbody>");
                        sb.append("</table>");
                        
                    } else {
                        
                    }
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }
            }
        }
        
        if (action.equals("loadUserDetails")) {
            if ("".equals(id2) || id2 == null || targetId == null || "".equals(targetId)) {
            } else {
                
                String fullname = "";
                String username = "";
                String loginemail = "";
                String uniemail = "";
                String peremail = "";
                boolean found = false;
                
                if (id2.equalsIgnoreCase("Applicant")) {
                    Applicants app = sess.getApplicantsById(targetId);
                    if (app != null) {
                        Users us = sess.getUsers(app.getId());
                        if (us != null) {
                            found = true;
                            fullname = app.getSurname() + " " + app.getOthernames();
                            username = us.getUsername();
                            loginemail = us.getEmail();
                            peremail = app.getEmailAddress();
                        }
                    }
                }
                if (id2.equalsIgnoreCase("Staff")) {
                    Staff app = sess.getStaffById(targetId);
                    if (app != null) {
                        Users us = sess.getUsers(app.getId());
                        if (us != null) {
                            found = true;
                            fullname = app.getSurname() + " " + app.getOthernames();
                            username = us.getUsername();
                            loginemail = us.getEmail();
                            peremail = app.getPersonalEmailAddress();
                            uniemail = app.getOfficialEmailAddress();
                        }
                    }
                }
                if (id2.equalsIgnoreCase("Student")) {
                    Students app = sess.getStudentsById(targetId);
                    if (app != null) {
                        Users us = sess.getUsers(app.getId());
                        if (us != null) {
                            found = true;
                            fullname = app.getSurname() + " " + app.getOthernames();
                            username = us.getUsername();
                            loginemail = us.getEmail();
                            peremail = app.getPersonalEmail();
                            uniemail = app.getUniversityEmail();
                        }
                    }
                }
                if (found) {
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append("User Number");
                    sb.append("</span>");
                    sb.append("<input id=\"userno\" name=\"userno\" value=\"").append(targetId).append("\" class=\'form-control\' type=\"text\" readonly=\"\" required=\"\"/>");
                    sb.append("</div>");
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append("User Type");
                    sb.append("</span>");
                    sb.append("<input id=\"usertye\" name=\"usertye\" value=\"").append(id2).append("\" class=\'form-control\' type=\"text\" readonly=\"\" required=\"\"/>");
                    sb.append("</div>");
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append("Full Name");
                    sb.append("</span>");
                    sb.append("<input id=\"fulname\" name=\"fulname\" value=\"").append(fullname).append("\" class=\'form-control\' type=\"text\" readonly=\"\" required=\"\"/>");
                    sb.append(" </div>");
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append(" University Email");
                    sb.append(" </span>");
                    sb.append(" <input id=\"uniemail\" name=\"uniemail\" value=\"").append(uniemail).append("\" class=\'form-control\' type=\"email\" readonly=\"\"/>");
                    sb.append(" </div>");
                    sb.append(" <div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append(" Personal Email   ");
                    sb.append(" </span>");
                    sb.append("<input id=\"peremail\" name=\"peremail\" value=\"").append(peremail).append("\" class=\'form-control\' type=\"email\" readonly=\"\"/>");
                    sb.append("</div>");
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append(" Login Email ");
                    sb.append(" </span>");
                    sb.append("<input id=\"loginemail\" name=\"loginemail\" value=\"").append(loginemail).append("\" class=\'form-control\' type=\"email\" readonly=\"\"/>");
                    sb.append("</div>");
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append(" Login Username   ");
                    sb.append(" </span>");
                    sb.append("<input id=\"username\" name=\"username\" value=\"").append(username).append("\" class=\'form-control\' type=\"text\" required=\"\"/>");
                    sb.append("</div>");
                    
                    sb.append("<div class=\"input-group mb-4\"><span class=\"input-group-text\">");
                    sb.append("New Email Address   ");
                    sb.append(" </span>");
                    sb.append(" <input id=\"newemail\" name=\"newemail\" class=\'form-control\' type=\"email\" required=\"\"/>");
                    sb.append("</div>");
                    
                    sb.append("<div class=\"row\">");
                    sb.append("<div class=\"col-6\">");
                    sb.append(" <input type=\"submit\" name=\"button2\" class=\"btn btn-success px-4\" value=\"Add Record\"/>");
                    sb.append(" </div>");
                    sb.append("</div>");
                } else {
                    sb.append("<div class=\"alert alert-danger\">No record found in ").append(targetId).append(" corresponding to ").append(id2);
                }
                
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(sb.toString());
            }
        }
        
        if (action.equals("clearApplicant")) {
            if ("".equals(id2)) {
            } else {
                try{
                String dd[] = id2.split("_");
                String idx = dd[0];
                String idy=dd[1];
                Admissions adm = sess.getAdmissions(idx);
                Users usr = sess.getUsers(idy);
                String co ="";
                if (adm != null) {
                    String status = adm.getAdmissionStatus();
                    if (status.equalsIgnoreCase("CLEARED")) {
                        sess.unClearApplicant(idx, usr);
                    } else {
                       sess.clearApplicant(idx, usr);
                    }
                    adm = sess.getAdmissions(idx);
                    status = adm.getAdmissionStatus();
                    if (status.equalsIgnoreCase("CLEARED")) {
                        sb.append("success_CLEARED_UNCLEAR_warning");
                    } else {
                        sb.append("danger_PENDING_CLEAR_success");
                    }
                }
                
               
                    
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(sb.toString());
                }catch(Exception k){}
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
