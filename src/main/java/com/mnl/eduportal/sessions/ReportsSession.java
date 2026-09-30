/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/J2EE/EJB40/StatelessEjbClass.java to edit this template
 */
package com.mnl.eduportal.sessions;

import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Studentprogression;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.util.MaxLevelStudentDTO;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.StudentStatisticsDTO;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.ejb.LocalBean;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.UserTransaction;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author eaglescan
 */
@Stateless
@LocalBean
@TransactionManagement(value = TransactionManagementType.BEAN)
public class ReportsSession {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    @Resource
    private UserTransaction userTransaction;

    @Inject
    private MainSession sess;

    Settings settings = new Settings();

    public List<StudentStatisticsDTO> getStudentStatistics(String schoolId, String session, String semester) {
        String query = """
            WITH RegisteredStudents AS (
                SELECT 
                    s.level_added AS level,
                    COUNT(s.id) AS registered_count,
                    f.name AS faculty_name
                FROM 
                    studentprogression AS s
                JOIN 
                    courses AS c
                    ON c.id = s.course_id
                JOIN departments AS d
                    ON d.id = c.department_id
                JOIN faculties_directorates AS f
                    ON f.id = d.faculty_id
                JOIN schoolprogrammes AS sp
                    ON sp.id = c.school_programme_id
                JOIN schools AS sc
                    ON sc.id = sp.school_id
                WHERE 
                    s.session_added = :session 
                    AND s.semester_added = :semester 
                    AND s.registration_status = '1' 
                    AND sc.id = :schoolId
                GROUP BY 
                    s.level_added, 
                    f.name
            ),
            PaidStudents AS (
                SELECT 
                    s.level AS level,
                    COUNT(s.id) AS paid_count,
                    f.name AS faculty_name,
                    SUM(s.amount) AS total_amount
                FROM 
                    payments AS s
                JOIN courses AS c
                    ON c.id = s.course_id
                JOIN departments AS d
                    ON d.id = c.department_id
                JOIN faculties_directorates AS f
                    ON f.id = d.faculty_id
                JOIN schoolprogrammes AS sp
                    ON sp.id = c.school_programme_id
                JOIN schools AS sc
                    ON sc.id = sp.school_id
                WHERE 
                    s.session_paid = :session 
                    AND s.semester_paid = :semester 
                    AND sc.id = :schoolId
                GROUP BY 
                    s.level, f.name
            ),
            AllStudents AS (
                SELECT 
                    s.current_class AS level,
                    COUNT(s.id) AS total_students,
                    f.name AS faculty_name
                FROM 
                    students AS s
                JOIN 
                    courses AS c
                    ON c.id = s.course_id
                JOIN departments AS d
                    ON d.id = c.department_id
                JOIN faculties_directorates AS f
                    ON f.id = d.faculty_id
                JOIN schoolprogrammes AS sp
                    ON sp.id = c.school_programme_id
                JOIN schools AS sc
                    ON sc.id = sp.school_id
                WHERE 
                    s.session_exited IS NULL 
                    AND s.current_class <= '500'
                    AND sc.id = :schoolId
                GROUP BY 
                    s.current_class, 
                    f.name
            )
            SELECT 
                a.faculty_name,
                a.level,
                SUM(a.total_students) AS total_students,
                SUM(COALESCE(r.registered_count, 0)) AS registered_students,
                SUM(COALESCE(p.paid_count, 0)) AS paid_students,
                SUM(a.total_students - COALESCE(r.registered_count, 0)) AS not_registered_students,
                SUM(a.total_students - COALESCE(p.paid_count, 0)) AS not_paid_students,
                SUM(COALESCE(p.total_amount, 0)) AS total_amount_paid,
                ROUND((SUM(COALESCE(r.registered_count, 0))::numeric / SUM(a.total_students)) * 100, 2) AS registered_percentage,
                ROUND((SUM(a.total_students - COALESCE(r.registered_count, 0))::numeric / SUM(a.total_students)) * 100, 2) AS not_registered_percentage,
                ROUND((SUM(COALESCE(p.paid_count, 0))::numeric / SUM(a.total_students)) * 100, 2) AS paid_percentage,
                ROUND((SUM(a.total_students - COALESCE(p.paid_count, 0))::numeric / SUM(a.total_students)) * 100, 2) AS not_paid_percentage
            FROM 
                AllStudents AS a
            LEFT JOIN 
                RegisteredStudents AS r
                ON a.level = r.level AND a.faculty_name = r.faculty_name
            LEFT JOIN 
                PaidStudents AS p
                ON a.level = p.level AND a.faculty_name = p.faculty_name
            GROUP BY 
                a.faculty_name, a.level
            ORDER BY 
                a.faculty_name ASC, 
                a.level ASC;
        """;

        Query nativeQuery = em.createNativeQuery(query, "StudentStatisticsDTOMapping");
        nativeQuery.setParameter("schoolId", schoolId);
        nativeQuery.setParameter("session", session);
        nativeQuery.setParameter("semester", semester);

        List<Object[]> results = nativeQuery.getResultList();
        List<StudentStatisticsDTO> statistics = new ArrayList<>();

        for (Object[] result : results) {
            StudentStatisticsDTO dto = new StudentStatisticsDTO();
            dto.setFacultyName((String) result[0]);
            dto.setLevel((String) result[1]);
            dto.setTotalStudents(((Number) result[2]).intValue());
            dto.setRegisteredStudents(((Number) result[3]).intValue());
            dto.setPaidStudents(((Number) result[4]).intValue());
            dto.setNotRegisteredStudents(((Number) result[5]).intValue());
            dto.setNotPaidStudents(((Number) result[6]).intValue());
            dto.setTotalAmountPaid(((Number) result[7]).doubleValue());
            dto.setRegisteredPercentage(((Number) result[8]).doubleValue());
            dto.setNotRegisteredPercentage(((Number) result[9]).doubleValue());
            dto.setPaidPercentage(((Number) result[10]).doubleValue());
            dto.setNotPaidPercentage(((Number) result[11]).doubleValue());

            statistics.add(dto);
        }

        return statistics;
    }

    public List<MaxLevelStudentDTO> updateMaxSpill() {
        List<MaxLevelStudentDTO> list = new ArrayList();
        try {
            list = this.getMaxLevelStudents("S001", 200);
            System.out.print("111111111111111 " + list.size());
            for (MaxLevelStudentDTO dd : list) {
                Students ddx = sess.getStudentsById(dd.getStudentId()+"");
                System.out.print("22222222222 " + ddx);
                if (ddx != null) {

                    Studentprogression sm = sess.getMaxStudentprogressionForStudent(dd.getStudentId()+"");
                    if (sm != null) {
                        String othernames = ddx.getOthernames();

                        if (othernames == null) {
                            othernames = " ";
                        }
                        System.out.print("3333333333 " + sm);
                        ddx.setExitComment("Auto suspension. Exhausted maximum spillover levels");
                        ddx.setExitType("SUSPENDED");
                        ddx.setAddedBy(sess.getUsers("s202410469"));
                        ddx.setOthernames(othernames);
                        ddx.setSessionExited(sm.getSessionAdded());
                        ddx.setDateAdded(settings.getCurrentDateTime());
                        sess.updateStudent(ddx);
                    }

                }

            }
        } catch (Exception k) {
            k.printStackTrace();
        }
        return list;
    }

    public List<MaxLevelStudentDTO> getMaxLevelStudents(String schoolId, int count) {
        List<MaxLevelStudentDTO> qr = new ArrayList();
String ejbql = """
    SELECT new MaxLevelStudentDTO(
        s.id, 
        sp.courseId.id, 
        sp.levelAdded, 
        COUNT(sp.sessionAdded), 
        MAX(sp.sessionAdded)
    )
    FROM Studentprogression sp
    JOIN sp.courseId c
    JOIN c.schoolProgrammeId spg
    JOIN spg.schoolId sc
    JOIN sp.studentsId s
    WHERE sc.id = :schoolId
      AND s.sessionExited IS NULL
      AND sp.levelAdded = (
          SELECT MAX(innerSp.levelAdded)
          FROM Studentprogression innerSp
          WHERE innerSp.courseId.id = sp.courseId.id
      )
    GROUP BY s.id, sp.courseId.id, sp.levelAdded
    HAVING COUNT(sp.sessionAdded) > 3
    ORDER BY COUNT(sp.sessionAdded) DESC
""";
        try {
            System.err.println("5555555555555555");
            TypedQuery<MaxLevelStudentDTO> query = em.createQuery(ejbql, MaxLevelStudentDTO.class);
            query.setParameter("schoolId", schoolId);

            qr = query.setMaxResults(count).getResultList();
            System.err.println("666666666666" + qr.size());
        } catch (Exception k) {
            k.printStackTrace();
        }

        return qr;
    }

}
