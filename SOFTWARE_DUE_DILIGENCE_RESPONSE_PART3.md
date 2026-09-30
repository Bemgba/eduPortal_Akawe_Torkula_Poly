# Software Due Diligence Response - Part 3
## CUSTOMER IMPACT, RISK, COMPLIANCE & USABILITY

---

## SECTION 10: CUSTOMER & SERVICE IMPACT

### Does the software directly affect customer experience?
**YES - Direct and Significant Impact**

**Customer Touchpoints:**
1. **Application Process:**
   - First interaction with university
   - Sets expectations
   - Influences enrollment decision

2. **Payment Experience:**
   - Critical transaction point
   - Trust and security concerns
   - Convenience factor

3. **Registration:**
   - Recurring interaction
   - Academic progression dependency
   - Service quality indicator

**Customer Perception:**
- Modern, professional image
- Convenient and accessible
- Transparent processes

### Does it improve response times or service quality?
**YES - Dramatic Improvements**

**Response Time Improvements:**
| Service | Before | After | Improvement |
|---------|--------|-------|-------------|
| Application Status | 3-5 days | Real-time | 99% |
| Payment Confirmation | 2-3 days | Instant | 99% |
| Registration Approval | 1 week | 1 hour | 99% |
| Query Response | 2 days | 4 hours | 92% |
| Document Verification | 1 week | 2 days | 71% |

**Service Quality Improvements:**
- Accuracy: 98% (vs. 85% manual)
- Availability: 24/7 (vs. 8-5 office hours)
- Consistency: Standardized processes
- Transparency: Real-time status tracking

### Customer satisfaction metrics impacted?
**Positive Impact on Satisfaction:**

**Measured Improvements:**
- Application satisfaction: 75% → 88%
- Payment experience: 65% → 85%
- Registration ease: 70% → 82%
- Overall satisfaction: 72% → 84%

**Key Satisfaction Drivers:**
- Convenience (24/7 access)
- Speed (real-time processing)
- Transparency (status tracking)
- Reliability (consistent experience)

**Areas for Improvement:**
- Mobile experience (70% satisfaction)
- Help/support access (75% satisfaction)
- Error messages clarity (72% satisfaction)

### History of customer complaints related to the system?
**Common Complaints:**

1. **Payment Issues (30% of complaints):**
   - Payment gateway timeouts
   - Delayed confirmation
   - Double charges (rare)

2. **Access Issues (25%):**
   - Password reset problems
   - Account lockouts
   - Email verification delays

3. **Usability Issues (20%):**
   - Confusing navigation
   - Unclear instructions
   - Mobile compatibility

4. **Performance Issues (15%):**
   - Slow loading during peak
   - Timeouts
   - System unavailability

5. **Data Issues (10%):**
   - Incorrect information display
   - Document upload failures
   - Profile update problems

**Complaint Trends:**
- Decreasing over time (improvements implemented)
- Peak during admission periods
- Most resolved within 24-48 hours

### Does downtime affect customers directly?
**YES - Immediate and Severe Impact**

**Customer Impact During Downtime:**

**Applicants:**
- Cannot submit applications (deadline risk)
- Cannot make payments (admission risk)
- Cannot check status (anxiety)
- May choose competitor universities

**Current Students:**
- Cannot register for courses (academic delay)
- Cannot make payments (late fees)
- Cannot access records (service disruption)

**Impact Severity:**
- **Critical Period (Admission):** Severe - may lose applicants
- **Registration Period:** High - academic delays
- **Regular Period:** Moderate - inconvenience

**Customer Communication:**
- Email notifications for planned downtime
- Status page for unplanned outages
- Alternative contact methods provided

### Does it provide self-service features?
**YES - Extensive Self-Service**

**Self-Service Capabilities:**

1. **Account Management:**
   - Registration
   - Password reset
   - Profile updates
   - Email verification

2. **Application:**
   - Form submission
   - Document upload
   - Status checking
   - Application updates

3. **Payments:**
   - Fee calculation
   - Online payment
   - Receipt download
   - Payment history

4. **Registration:**
   - Course selection
   - Registration submission
   - Schedule viewing
   - Registration history

5. **Information Access:**
   - Admission status
   - Payment records
   - Academic records
   - Fee schedules

**Self-Service Adoption:**
- 95% of transactions self-service
- 5% require staff assistance
- Reduced support burden by 80%

### Is performance scalable during peak demand?
**PARTIALLY SCALABLE - Needs Improvement**

**Current Capacity:**
- Normal load: 500-1,000 concurrent users (smooth)
- Peak load: 2,000-3,000 concurrent users (degraded)
- Maximum tested: 3,500 users (significant slowdown)

**Peak Period Performance:**
- Response time: 2-5 seconds (vs. <1 second normal)
- Occasional timeouts
- Database connection issues
- Payment gateway delays

**Scalability Limitations:**
- Single server architecture
- Database connection pool limits
- No load balancing
- Limited caching

**Scalability Improvements Needed:**
- Horizontal scaling (multiple servers)
- Load balancing
- Database optimization
- CDN for static assets
- Caching layer

---

## SECTION 11: RISK & BUSINESS CONTINUITY

### Business impact of downtime?
**Impact Analysis by Duration:**

**1 Hour Downtime:**
- Revenue loss: ₦200K-₦500K (period-dependent)
- Transactions affected: 50-200
- Customer frustration: Moderate
- Reputational impact: Minimal
- Recovery: Quick

**1 Day Downtime:**
- Revenue loss: ₦2M-₦10M
- Transactions affected: 1,000-5,000
- Customer frustration: High
- Reputational impact: Moderate
- Recovery: Challenging
- Potential deadline misses

**1 Week Downtime:**
- Revenue loss: ₦15M-₦70M
- Transactions affected: 7,000-35,000
- Customer frustration: Severe
- Reputational impact: Severe
- Recovery: Very difficult
- Enrollment targets at risk
- Regulatory issues likely
- Competitive disadvantage
- Potential legal issues

**Critical Period Multiplier:**
- During admission: 3-5x impact
- During registration: 2-3x impact
- Regular period: 1x impact

### Is there a Business Continuity Plan (BCP)?
**LIMITED BCP - Needs Enhancement**

**Current BCP Elements:**
- Daily database backups
- WAR file versioning
- Basic recovery procedures
- Contact list for emergencies

**BCP Gaps:**
- No formal BCP document
- No tested recovery procedures
- No alternative processing site
- No communication plan
- No staff training on BCP

**Recommendations:**
- Develop comprehensive BCP
- Regular BCP testing (quarterly)
- Alternative processing arrangements
- Communication protocols
- Staff training and drills

### Is there a Disaster Recovery Plan (DRP)?
**BASIC DRP - Requires Improvement**

**Current DRP:**
- Database backup and restore procedures
- Application redeployment process
- Basic recovery steps documented

**DRP Limitations:**
- No hot standby site
- Manual recovery process
- 4-8 hour RTO (too long)
- 24-hour RPO (data loss risk)
- Not tested regularly

**DRP Improvements Needed:**
- Automated failover
- Hot standby server
- Reduce RTO to 2 hours
- Reduce RPO to 1 hour
- Quarterly DR testing
- Offsite backup location

### Are backup systems in place?
**YES - Basic Backup System**

**Backup Infrastructure:**
1. **Database Backups:**
   - Daily full backups
   - Stored locally and external drives
   - 30-day retention
   - Manual verification

2. **Application Backups:**
   - WAR file versioning
   - Configuration backups
   - Git repository

3. **Document Backups:**
   - Uploaded files backed up
   - Weekly backup schedule

**Backup Limitations:**
- No cloud backup
- No automated testing
- Single backup location risk
- Manual processes

**Recommendations:**
- Cloud backup implementation
- Automated backup testing
- Geographic redundancy
- Continuous backup (transaction logs)

### Does the system introduce regulatory or legal risk?
**MODERATE RISK - Manageable**

**Regulatory Risks:**

1. **Data Protection:**
   - NDPR compliance required
   - Personal data handling
   - Consent management
   - Risk: Moderate (compliance efforts ongoing)

2. **Financial Regulations:**
   - Payment processing standards
   - Financial reporting requirements
   - Audit trail maintenance
   - Risk: Low (via payment gateway)

3. **Academic Regulations:**
   - JAMB integration requirements
   - University regulatory framework
   - Academic record integrity
   - Risk: Low (compliant)

**Legal Risks:**

1. **Data Breach:**
   - Personal data exposure
   - Financial information leak
   - Risk: Moderate (security measures in place)

2. **Service Failure:**
   - Missed admission deadlines
   - Payment processing errors
   - Academic record errors
   - Risk: Moderate (backup procedures exist)

3. **Contractual:**
   - Payment gateway SLA
   - Vendor dependencies
   - Risk: Low (contracts in place)

**Risk Mitigation:**
- Regular security audits
- Compliance monitoring
- Legal review of processes
- Insurance coverage
- Incident response plan

### Data breach impact assessment?
**HIGH IMPACT - Critical Concern**

**Data at Risk:**
- Personal information: 15,000+ records
- Financial data: Payment records
- Academic records: Grades, transcripts
- Identity documents: Uploaded files

**Breach Impact:**

**Financial:**
- NDPR fines: Up to ₦10M or 2% of revenue
- Remediation costs: ₦20M-₦50M
- Legal costs: ₦10M-₦30M
- Compensation: Variable

**Reputational:**
- Loss of trust
- Enrollment decline (10-30%)
- Media coverage (negative)
- Competitive disadvantage

**Operational:**
- System shutdown required
- Investigation and remediation
- Process changes
- Enhanced security measures

**Legal:**
- Regulatory investigation
- Potential lawsuits
- Compliance orders
- Criminal liability (severe cases)

**Mitigation Measures:**
- Encryption (in transit and at rest)
- Access controls
- Audit logging
- Security monitoring
- Incident response plan
- Cyber insurance

### Vendor dependency risk?
**MODERATE RISK**

**Critical Vendor Dependencies:**

1. **Payment Gateway (Credo):**
   - Dependency: High
   - Risk: Moderate
   - Mitigation: Alternative gateway identified
   - Impact: Revenue processing stops

2. **Email Service:**
   - Dependency: High
   - Risk: Low
   - Mitigation: Multiple providers possible
   - Impact: Communication disruption

3. **Hosting Infrastructure:**
   - Dependency: High (self-hosted)
   - Risk: Low (internal control)
   - Mitigation: Backup hardware
   - Impact: System unavailability

4. **Database (MySQL):**
   - Dependency: High
   - Risk: Low (open source)
   - Mitigation: Alternative databases possible
   - Impact: Major migration required

**Vendor Risk Assessment:**
- Payment gateway: Single point of failure
- Other vendors: Replaceable
- Overall risk: Moderate
- Mitigation: Diversification needed

### Insurance coverage for failures?
**LIMITED COVERAGE**

**Current Insurance:**
- General liability insurance
- Property insurance (hardware)
- No specific cyber insurance
- No business interruption insurance

**Coverage Gaps:**
- Cyber liability
- Data breach response
- Business interruption
- Professional liability

**Recommendations:**
- Cyber insurance policy
- Business interruption coverage
- Professional liability insurance
- Coverage review annually

---

## SECTION 12: COMPLIANCE & REGULATORY IMPACT

### Does the system handle regulated data?
**YES - Multiple Data Types**

**Regulated Data Handled:**

1. **Personal Data (NDPR):**
   - Names, addresses, phone numbers
   - Email addresses
   - Date of birth
   - State of origin, LGA
   - Next of kin information

2. **Financial Data:**
   - Payment information
   - Bank details (via gateway)
   - Transaction records
   - Fee payment history

3. **Academic Data:**
   - O'Level results
   - JAMB scores
   - Admission status
   - Course registration
   - Academic records

4. **Identity Documents:**
   - Birth certificates
   - ID cards
   - Passport photographs
   - Academic certificates

### Industry compliance requirements?
**Applicable Compliance Standards:**

1. **Nigeria Data Protection Regulation (NDPR):**
   - Data protection principles
   - Consent management
   - Data subject rights
   - Breach notification
   - Status: Partially compliant (improvements ongoing)

2. **JAMB Regulations:**
   - Integration requirements
   - Data accuracy standards
   - Admission process compliance
   - Status: Compliant

3. **University Regulations:**
   - Academic standards
   - Financial procedures
   - Record keeping requirements
   - Status: Compliant

4. **Payment Card Industry (PCI DSS):**
   - Via payment gateway (Credo)
   - No direct card handling
   - Status: Compliant (gateway responsibility)

### Are audit trails available?
**YES - Comprehensive Audit Logging**

**Audit Trail Coverage:**

1. **User Actions:**
   - Login/logout events
   - Password changes
   - Profile updates
   - Application submissions

2. **Administrative Actions:**
   - Admission decisions
   - Fee structure changes
   - User role modifications
   - System configuration changes

3. **Financial Transactions:**
   - Payment processing
   - Fee waivers
   - Payment verification
   - Refunds

4. **System Events:**
   - Application errors
   - Security events
   - Performance issues
   - Access violations

**Audit Trail Features:**
- Timestamp for all events
- User identification
- Action performed
- Before/after values
- IP address logging

**Retention:** 90 days minimum (extendable)

**Limitations:**
- No centralized log management
- Limited search capabilities
- Manual log review required

### Does non-compliance lead to fines?
**YES - Potential Penalties**

**NDPR Penalties:**
- Fines up to ₦10,000,000
- Or 2% of annual gross revenue
- Whichever is greater

**Other Penalties:**
- Regulatory sanctions
- License suspension
- Reputational damage
- Legal liability

**Compliance Status:**
- Ongoing compliance efforts
- Regular reviews
- Gap remediation
- Risk: Moderate

### Is data residency compliant?
**YES - Data Stored Locally**

**Data Residency:**
- All data stored in Nigeria
- University-owned servers
- No cross-border transfers
- Compliant with NDPR requirements

**Data Location:**
- Primary: University data center (Nigeria)
- Backup: Local external storage (Nigeria)
- No cloud storage (currently)

**Compliance Status:** Fully compliant

### Are certifications maintained?
**LIMITED CERTIFICATIONS**

**Current Status:**
- No ISO certifications
- No PCI DSS certification (via gateway)
- No SOC 2 compliance
- No security certifications

**Recommendations:**
- ISO 27001 (Information Security)
- ISO 9001 (Quality Management)
- Security audits and certifications
- Regular compliance assessments

---

*[Document continues in Part 4...]*
