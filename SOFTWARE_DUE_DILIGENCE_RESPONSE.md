# Software Operational Due Diligence Response
## EduPortal Academic Management System

**Date:** February 13, 2026  
**System:** EduPortal v1.0  
**Organization:** BDIC (Benue State University)

---

## SECTION 1: SYSTEM OVERVIEW

### Purpose of the software
**EduPortal** is a comprehensive academic management system designed to digitize and automate university operations including:
- Student admissions (UTME, Direct Entry, Postgraduate)
- Application processing and verification
- Fee management and online payment processing
- Student registration and course management
- Academic records management
- Staff and role management
- Hostel allocation and management

### Key stakeholders and users
1. **Students/Applicants** (~10,000+ active users)
   - Prospective students applying for admission
   - Current students managing registration and payments

2. **Administrative Staff** (~200+ users)
   - Admissions officers
   - Bursary/Finance staff
   - Registry staff
   - Academic planning officers

3. **Academic Staff** (~500+ users)
   - Lecturers
   - Course coordinators
   - Heads of departments
   - Deans

4. **Management**
   - Vice-Chancellor
   - Registrar
   - Bursar
   - Directors

### Business processes supported

1. **Admissions Management**
   - Online application submission
   - Document upload and verification
   - UTME/DE applicant processing
   - Admission list generation
   - Merit allocation (NM, SM, ELG, LM, SPECIAL)

2. **Financial Management**
   - Fee structure configuration
   - Online payment processing (Credo Payment Gateway)
   - Payment verification and reconciliation
   - Fee waivers and exemptions
   - Financial reporting

3. **Student Registration**
   - Course registration per semester
   - Academic progression tracking
   - Session management
   - Level advancement

4. **Academic Operations**
   - Course management
   - Semester course allocation
   - Lecturer course assignment
   - Credit unit management

5. **User Management**
   - Role-based access control
   - Staff management
   - Authentication and authorization
   - Email verification

### Mission criticality level
**CRITICAL** - The system is mission-critical for university operations:
- Handles all student admissions (100% digital)
- Processes all fee payments (primary revenue channel)
- Manages student academic records
- Downtime directly impacts revenue and operations
- No manual fallback for most processes

### Current and projected users
- **Current Active Users:** ~10,000-15,000 (students + staff)
- **Peak Usage:** During admission periods (20,000+ concurrent applicants)
- **Projected Growth:** 15-20% annually
- **Geographic Distribution:** Primarily Nigeria, with international applicants

---

## SECTION 2: ARCHITECTURE & INFRASTRUCTURE


### Architecture style used
**Three-Tier Java EE Architecture:**
1. **Presentation Layer**
   - JSP (JavaServer Pages) for dynamic web pages
   - HTML5, CSS3, JavaScript (CoreUI framework)
   - RESTful APIs for AJAX operations

2. **Business Logic Layer**
   - Enterprise JavaBeans (EJB) for business logic
   - Session beans for transaction management
   - JAX-RS for REST API endpoints

3. **Data Access Layer**
   - JPA (Java Persistence API) with Hibernate
   - Entity beans for ORM
   - MySQL database

**Technology Stack:**
- **Language:** Java 21
- **Framework:** Jakarta EE 11
- **Application Server:** WildFly
- **Database:** MySQL
- **Build Tool:** Maven
- **Version Control:** Git

### Hosting environment
**On-Premises Deployment:**
- Hosted on university-owned servers
- Operating System: Linux (CentOS/RHEL)
- Application Server: WildFly Application Server
- Database Server: MySQL 8.0+
- Web Server: Apache/Nginx (reverse proxy)

**Infrastructure:**
- Physical servers in university data center
- Network: University campus network
- Internet connectivity: Dedicated fiber connection
- Load balancing: Not currently implemented (single server)

### Backup strategy
**Current Implementation:**

1. **Database Backups:**
   - Daily automated MySQL dumps
   - Retention: 30 days
   - Storage: Local and external drives
   - Backup verification: Weekly

2. **Application Backups:**
   - WAR file versioning
   - Configuration file backups
   - Static assets backup

3. **Document Backups:**
   - Uploaded documents (applicant files)
   - Generated reports and invoices

**Recommendations for Improvement:**
- Implement automated cloud backup
- Set up offsite backup location
- Implement continuous backup (transaction logs)
- Regular restore testing

### Disaster recovery RPO/RTO
**Current State:**
- **RPO (Recovery Point Objective):** 24 hours (daily backups)
- **RTO (Recovery Time Objective):** 4-8 hours (manual restoration)

**Limitations:**
- No formal DR plan documented
- No hot standby server
- Manual recovery process
- Single point of failure

**Recommended Targets:**
- RPO: 1 hour (with transaction log backups)
- RTO: 2 hours (with automated failover)

### Environment separation (Dev/Test/Prod)
**Current Setup:**

1. **Production Environment:**
   - Live system serving users
   - Real data and transactions
   - Monitored 24/7

2. **Development Environment:**
   - Local developer machines
   - Test database with sample data
   - Used for feature development

3. **Testing Environment:**
   - Limited - often uses production-like data
   - Manual testing before deployment

**Gaps:**
- No dedicated staging environment
- Testing often done in development
- No automated testing environment

---

## SECTION 3: PERFORMANCE & RELIABILITY

### Uptime SLA
**Current:** No formal SLA documented
**Target:** 99.5% uptime (43.8 hours downtime/year allowed)
**Critical Hours:** 8 AM - 10 PM WAT (peak usage)

### Historical uptime
**Estimated Performance:**
- **Uptime:** ~98% (based on operational reports)
- **Planned Maintenance:** Monthly (2-4 hours)
- **Unplanned Outages:** 2-3 per year (2-6 hours each)

**Common Causes of Downtime:**
- Database connection issues
- Server resource exhaustion
- Network connectivity problems
- Payment gateway integration issues

### Load testing conducted
**Current State:** Limited formal load testing


**Testing Performed:**
- Manual stress testing during admission periods
- Observed performance with ~1,000 concurrent users
- Database query optimization based on production logs

**Recommendations:**
- Implement automated load testing
- Test with 5,000+ concurrent users
- Identify bottlenecks before peak periods
- Performance baseline establishment

### Monitoring and alerts configured
**Current Monitoring:**
1. **Application Logs:**
   - WildFly server logs
   - Application-specific logging
   - Error tracking in logs

2. **Database Monitoring:**
   - MySQL slow query log
   - Connection pool monitoring
   - Manual performance checks

3. **System Resources:**
   - CPU, Memory, Disk usage
   - Manual monitoring via system tools

**Gaps:**
- No automated alerting system
- No real-time monitoring dashboard
- No proactive issue detection
- Manual log review required

**Recommendations:**
- Implement APM (Application Performance Monitoring)
- Set up automated alerts (email/SMS)
- Real-time dashboard for system health
- Integrate with monitoring tools (Prometheus, Grafana)

### Incident response process
**Current Process:**
1. Issue reported by users or staff
2. IT team notified via phone/email
3. Manual investigation and diagnosis
4. Fix applied and tested
5. System restored
6. Informal post-mortem

**Response Times:**
- Critical issues: 1-2 hours
- High priority: 4-8 hours
- Medium priority: 1-2 days
- Low priority: As time permits

**Gaps:**
- No formal incident management system
- No escalation procedures documented
- Limited on-call support
- No SLA tracking

---

## SECTION 4: SECURITY & COMPLIANCE

### Authentication methods
**✅ Implemented:**
1. **Username/Password Authentication**
   - Bcrypt password hashing
   - Password strength requirements (5 criteria)
   - Account lockout after failed attempts

2. **Email Verification**
   - Required for new accounts
   - Token-based verification
   - Prevents unauthorized access

3. **Password Reset**
   - Secure token-based reset
   - 30-minute token expiry
   - Email-based verification

4. **Session Management**
   - Secure session handling
   - Session timeout
   - CSRF protection

**MFA Status:** Partially implemented (email verification acts as second factor)

**Recommendations:**
- Implement full 2FA/MFA (SMS, Authenticator app)
- Add biometric authentication for mobile
- Implement SSO for staff

### Encryption in transit and at rest
**✅ Encryption in Transit:**
- HTTPS/TLS for all web traffic
- Secure payment gateway communication
- Encrypted email transmission

**✅ Encryption at Rest:**
- Database password encryption (Bcrypt)
- Sensitive data encryption in database
- Encrypted backup files

**Implementation Details:**
- TLS 1.2+ for HTTPS
- Strong cipher suites
- Certificate management in place

### Vulnerability scans and penetration tests
**✅ Regular Security Measures:**
1. **Code Review:**
   - Manual code review for security issues
   - Input validation checks
   - SQL injection prevention (parameterized queries)
   - XSS prevention

2. **Dependency Scanning:**
   - Maven dependency checks
   - Regular library updates
   - Known vulnerability monitoring

3. **Security Best Practices:**
   - Prepared statements for database queries
   - Input sanitization
   - Output encoding
   - Session security

**Gaps:**
- No automated vulnerability scanning
- No formal penetration testing
- No security audit trail

**Recommendations:**
- Implement automated vulnerability scanning (OWASP ZAP, Burp Suite)
- Annual penetration testing by third party
- Security audit logging
- Regular security training for developers

### Compliance requirements
**✅ Standards Compliance:**
1. **Data Protection:**
   - Personal data handling procedures
   - Data minimization principles
   - User consent management

2. **Academic Standards:**
   - JAMB integration compliance
   - University regulatory requirements
   - Academic record integrity

3. **Financial Compliance:**
   - Payment processing standards
   - Financial reporting requirements
   - Audit trail maintenance

**Applicable Regulations:**
- Nigeria Data Protection Regulation (NDPR)
- University regulatory framework
- Payment Card Industry standards (via gateway)

### Audit logging enabled
**✅ Audit Logging:**
1. **User Actions:**
   - Login/logout events
   - Password changes
   - Profile updates

2. **Administrative Actions:**
   - Admission decisions
   - Fee structure changes
   - User role modifications

3. **Financial Transactions:**
   - Payment processing
   - Fee waivers
   - Payment verification

4. **System Events:**
   - Application errors
   - Security events
   - Performance issues

**Log Retention:** 90 days minimum

**Gaps:**
- No centralized log management
- Limited log analysis tools
- No real-time security monitoring

---

## SECTION 5: DEVELOPMENT & RELEASE MANAGEMENT

### CI/CD pipeline in place
**Current State:** Manual deployment process

**Development Workflow:**
1. Code development in local environment
2. Git version control
3. Manual build with Maven
4. Manual testing
5. Manual deployment to production
6. Post-deployment verification

**Gaps:**
- No automated CI/CD pipeline
- No automated testing
- No automated deployment
- Manual quality gates

**Recommendations:**
- Implement Jenkins/GitLab CI
- Automated build and test
- Automated deployment to staging
- Manual approval for production

### Testing coverage
**Current Testing:**
1. **Manual Testing:**
   - Functional testing by developers
   - User acceptance testing
   - Regression testing (limited)

2. **Integration Testing:**
   - Payment gateway testing
   - Email service testing
   - Database integration testing

**Test Coverage:** Estimated 30-40% (manual)

**Gaps:**
- No unit tests
- No automated integration tests
- No performance tests
- No security tests

**Recommendations:**
- Implement JUnit for unit testing
- Target 70%+ code coverage
- Automated regression testing
- Performance testing suite

### Change management process
**Current Process:**
1. Change request (informal)
2. Development and testing
3. Code review (peer review)
4. Deployment planning
5. Production deployment
6. Verification

**Documentation:**
- Git commit messages
- Deployment notes
- Change logs (informal)

**Gaps:**
- No formal change request system
- No change advisory board
- Limited rollback procedures
- No change impact analysis

### Rollback strategy
**Current Approach:**
1. Keep previous WAR file backup
2. Database backup before changes
3. Manual rollback if issues occur
4. Restore from backup if needed

**Limitations:**
- Manual process
- Downtime during rollback
- Data loss risk
- No automated rollback

**Recommendations:**
- Blue-green deployment
- Automated rollback capability
- Database migration versioning
- Zero-downtime deployment

### Release frequency
**Current Schedule:**
- Major releases: Quarterly
- Minor updates: Monthly
- Hotfixes: As needed (within 24-48 hours)
- Security patches: Immediate

**Release Windows:**
- Planned: Weekends or off-peak hours
- Emergency: Any time with notification

---

## SECTION 6: SUPPORT & DOCUMENTATION

### Support model and SLAs
**Support Structure:**
1. **Tier 1 - Help Desk:**
   - User inquiries
   - Password resets
   - Basic troubleshooting
   - Response: 4 business hours

2. **Tier 2 - Technical Support:**
   - System issues
   - Data corrections
   - Configuration changes
   - Response: 8 business hours

3. **Tier 3 - Development Team:**
   - Bug fixes
   - System errors
   - Complex issues
   - Response: 24-48 hours

**Support Hours:**
- Business hours: 8 AM - 5 PM WAT (Mon-Fri)
- Limited weekend support
- On-call for critical issues

**SLA Targets:**
- Critical: 2 hours response, 4 hours resolution
- High: 4 hours response, 24 hours resolution
- Medium: 8 hours response, 3 days resolution
- Low: 24 hours response, 1 week resolution

### Runbooks available
**Current Documentation:**
1. **Deployment Runbooks:**
   - Application deployment steps
   - Database update procedures
   - Configuration changes

2. **Operational Runbooks:**
   - System startup/shutdown
   - Backup procedures
   - Common troubleshooting

**Gaps:**
- Not comprehensive
- Some procedures undocumented
- No disaster recovery runbook
- Limited troubleshooting guides

### User documentation provided
**Available Documentation:**
1. **User Guides:**
   - Student application guide
   - Payment processing guide
   - Registration guide

2. **Training Materials:**
   - Staff training presentations
   - Video tutorials (limited)
   - Quick reference guides

3. **System Documentation:**
   - Technical architecture overview
   - Database schema documentation
   - API documentation (limited)

**Delivery Methods:**
- PDF documents
- In-system help text
- Training sessions

**Gaps:**
- Not always up-to-date
- Limited searchability
- No interactive tutorials
- No knowledge base

### Knowledge base maintained
**Current State:**
- Informal knowledge sharing
- Email-based Q&A archive
- Staff training notes
- No centralized knowledge base

**Recommendations:**
- Implement knowledge base system
- FAQ section for common issues
- Searchable documentation
- Regular updates and maintenance

### Root cause analysis performed
**Current Practice:**
- Informal RCA for major incidents
- Issue tracking in notes
- Lessons learned (not documented)
- No formal RCA process

**Recommendations:**
- Formal RCA for all critical incidents
- Document findings and actions
- Track recurring issues
- Implement preventive measures

---

*[Document continues in next section...]*
