# Email Collection Feature - Deployment Checklist

## Pre-Deployment

### 1. Code Review
- [x] Backend code compiled successfully
- [x] No compilation errors
- [x] API endpoint follows existing patterns
- [x] Frontend modal integrated properly
- [x] JavaScript validation implemented

### 2. Testing (Development Environment)
- [ ] Test with user who has NULL email
- [ ] Test with user who has empty string email
- [ ] Test with user who has valid email
- [ ] Test email format validation
- [ ] Test duplicate email prevention
- [ ] Test successful email update
- [ ] Test redirect after update
- [ ] Test verification email is sent
- [ ] Test complete login flow after update

### 3. Database Verification
- [ ] Verify `users` table has `email` column
- [ ] Check column type (VARCHAR)
- [ ] Check column length (should be >= 100)
- [ ] Verify no constraints that would block update

### 4. Build Verification
- [x] Maven clean compile successful
- [ ] Maven package successful (create WAR file)
- [ ] No warnings or errors in build log

## Deployment Steps

### 1. Backup
- [ ] Backup current application WAR file
- [ ] Backup database (full backup)
- [ ] Document current version number
- [ ] Save rollback scripts

### 2. Build Application
```bash
mvn clean package -DskipTests
```
- [ ] Build completed successfully
- [ ] WAR file created in `target/` directory
- [ ] Note WAR file size and timestamp

### 3. Stop Application Server
- [ ] Stop Payara/GlassFish server
- [ ] Verify all processes stopped
- [ ] Check no locked files

### 4. Deploy New Version
- [ ] Copy new WAR to deployment directory
- [ ] Or use admin console to deploy
- [ ] Verify deployment directory permissions

### 5. Start Application Server
- [ ] Start Payara/GlassFish server
- [ ] Monitor server logs for errors
- [ ] Wait for application to fully deploy
- [ ] Check deployment status in admin console

### 6. Verify Deployment
- [ ] Application accessible at base URL
- [ ] Login page loads correctly
- [ ] No JavaScript errors in browser console
- [ ] REST API endpoint accessible: `/apis/user-email/update`

## Post-Deployment Testing

### 1. Smoke Tests
- [ ] Login with normal user (with email) - should work normally
- [ ] Login with JAMB user (no email) - should show modal
- [ ] Submit email in modal - should update successfully
- [ ] Login again after email update - should proceed normally

### 2. Integration Tests
- [ ] Email verification flow works
- [ ] Password reset works
- [ ] User can access dashboard after verification
- [ ] All existing features still work

### 3. Performance Tests
- [ ] Login response time acceptable
- [ ] Email update response time < 2 seconds
- [ ] No database connection issues
- [ ] No memory leaks

### 4. Security Tests
- [ ] Cannot bypass email requirement
- [ ] SQL injection attempts blocked
- [ ] XSS attempts blocked
- [ ] Email validation working

## Monitoring

### 1. Server Logs
Monitor for:
- [ ] "EMAIL CHECK: User has no email" messages
- [ ] "Email updated successfully for user" messages
- [ ] Any exceptions or errors
- [ ] Database connection issues

### 2. Application Logs
Check for:
- [ ] Successful email updates
- [ ] Failed email updates (and reasons)
- [ ] Verification emails sent
- [ ] Any unexpected errors

### 3. Database Monitoring
- [ ] Check `users` table for email updates
- [ ] Verify no NULL emails after users login
- [ ] Check for duplicate emails
- [ ] Monitor query performance

## Rollback Plan (If Issues Occur)

### 1. Immediate Rollback
If critical issues found:
```bash
# Stop server
# Deploy previous WAR backup
# Start server
# Verify old version working
```

### 2. Database Rollback
If database issues:
```sql
-- Restore from backup if needed
-- Or manually revert specific changes
```

### 3. Partial Rollback
If only frontend issues:
- Revert `index.jsp` only
- Keep backend changes
- Disable modal temporarily

## Communication

### 1. Before Deployment
- [ ] Notify users of maintenance window
- [ ] Inform support team of changes
- [ ] Prepare support documentation

### 2. During Deployment
- [ ] Update status page
- [ ] Monitor support channels
- [ ] Be ready for quick rollback

### 3. After Deployment
- [ ] Announce deployment complete
- [ ] Share new feature documentation
- [ ] Monitor for user feedback

## Success Criteria

Deployment is successful when:
- [x] Application builds without errors
- [ ] Application deploys without errors
- [ ] Login page loads correctly
- [ ] Email collection modal appears for users without email
- [ ] Email updates save correctly
- [ ] Verification emails are sent
- [ ] Users can complete full login flow
- [ ] No existing functionality broken
- [ ] No critical errors in logs
- [ ] Performance is acceptable

## Known Issues / Limitations

Document any known issues:
- None currently identified

## Support Information

### Key Files
- Backend: `UserEmailUpdateResource.java`
- Backend: `MainSession.java` (getUsersByUsername method)
- Frontend: `index.jsp`
- Documentation: `EMAIL_COLLECTION_IMPLEMENTATION.md`

### API Endpoint
- URL: `/apis/user-email/update`
- Method: POST
- Content-Type: application/json

### Troubleshooting
See `EMAIL_COLLECTION_IMPLEMENTATION.md` section 10 for troubleshooting guide.

### Contact
- Developer: [Your Name]
- Support: [Support Email]
- Emergency: [Emergency Contact]

## Sign-Off

- [ ] Developer tested and approved
- [ ] QA tested and approved
- [ ] Product owner approved
- [ ] Deployment completed
- [ ] Post-deployment verification passed

**Deployment Date:** _______________
**Deployed By:** _______________
**Version:** 1.0-SNAPSHOT
**Notes:** _______________
