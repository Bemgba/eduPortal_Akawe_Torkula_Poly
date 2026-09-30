# CREDO Payment Integration - Test Guide

## Overview
This document provides a comprehensive guide for testing the CREDO payment integration that has replaced the Interswitch payment system.

## Integration Summary

### Files Updated for CREDO Integration:

1. **Settings.java** ✅
   - Added CREDO test credentials
   - Mapped CREDO variables to existing Interswitch variable names
   - Updated URLs to point to CREDO endpoints

2. **InterswitchUtil.java** ✅
   - Updated to use CREDO credentials from Settings
   - Implemented full CREDO API verification with proper HTTP calls
   - Added Bearer token authentication for CREDO

3. **PaymentNotification.java** ✅
   - Added CREDO-specific fields (status, message, reference, gateway_response)
   - Added multiple constructors for backward compatibility
   - Implemented isSuccessful() method for CREDO success checking

4. **paymentresponse.jsp** ✅
   - Updated to use CREDO success condition (resp.isSuccessful())
   - Added CREDO integration comments
   - Maintained all existing payment record creation logic

5. **makePayment.jsp** ✅
   - Replaced Interswitch webpayCheckout with CREDO initialization
   - Added CREDO API call using fetch()
   - Commented out Interswitch JavaScript libraries

6. **website_epayment_invoice.jsp** ✅
   - Updated payment method from Quickteller to CREDO
   - Replaced Interswitch checkout with CREDO initialization
   - Updated platform descriptions and payment buttons

## CREDO Test Credentials (Configured)

```
Base URL: https://api.credodemo.com
Public Key: 0PUB1534ACOkwe34GHx6P7yX6zsKJO14
Secret Key: 0PRI1534ni2g6VHcArCzvUOXwNnNAM36
Webhook Token: wehok-token
Business Code: business-code
```

## Test Flow

### 1. Invoice Generation Test
**URL:** `/app_payment` (website_epayment_applicants.jsp)

**Steps:**
1. Enter applicant ID
2. Select fee group
3. Click "Generate invoice"
4. Verify payment reference is created with email and phone

**Expected Result:** 
- Payment reference created in database
- Redirected to invoice page with CREDO payment options

### 2. Payment Initialization Test
**URL:** `/invoice` (website_epayment_invoice.jsp)

**Steps:**
1. Click "Pay Now with CREDO" button
2. Verify CREDO API call is made to `/transaction/initialize`
3. Check browser console for API response

**Expected Result:**
- CREDO API called with correct parameters
- User redirected to CREDO payment page (if successful)
- Error message displayed (if failed)

### 3. Payment Verification Test
**URL:** `/confirmation` (paymentresponse.jsp)

**Steps:**
1. Simulate successful payment callback from CREDO
2. Verify payment verification API call to CREDO
3. Check payment record creation in database

**Expected Result:**
- CREDO verification API called
- Payment record created in Payments table
- Success message displayed

## API Endpoints Used

### CREDO Initialize Payment
```
POST https://api.credodemo.com/transaction/initialize
Headers: 
  - Authorization: Bearer 0PRI1534ni2g6VHcArCzvUOXwNnNAM36
  - Content-Type: application/json
Body: {
  "amount": 50000, // in kobo
  "email": "user@example.com",
  "phone": "08012345678",
  "reference": "PR20241217123456",
  "callback_url": "https://yoursite.com/confirmation",
  "currency": "NGN"
}
```

### CREDO Verify Payment
```
GET https://api.credodemo.com/transaction/verify/{reference}
Headers:
  - Authorization: Bearer 0PRI1534ni2g6VHcArCzvUOXwNnNAM36
  - Content-Type: application/json
```

## Testing Checklist

### ✅ Pre-Integration Tests
- [x] Settings.java has CREDO credentials
- [x] InterswitchUtil.java updated with CREDO API calls
- [x] PaymentNotification.java has CREDO fields
- [x] JSP files updated with CREDO integration

### 🧪 Functional Tests
- [ ] Invoice generation creates payment reference
- [ ] CREDO payment initialization works
- [ ] Payment verification API calls succeed
- [ ] Payment records are created correctly
- [ ] Error handling works properly

### 🔍 Integration Tests
- [ ] End-to-end payment flow completes
- [ ] Database records are accurate
- [ ] Email and phone parameters are passed correctly
- [ ] Callback URLs work properly

## Troubleshooting

### Common Issues:

1. **CREDO API Authentication Errors**
   - Check secret key in Settings.java
   - Verify Authorization header format

2. **JavaScript Errors**
   - Check browser console for fetch API errors
   - Verify CREDO endpoint URLs

3. **Payment Verification Failures**
   - Check InterswitchUtil.java implementation
   - Verify payment reference format

4. **Database Issues**
   - Check payment record creation in paymentresponse.jsp
   - Verify PaymentNotification parsing

## Success Criteria

✅ **Integration Complete When:**
1. Invoice generation works without errors
2. CREDO payment initialization succeeds
3. Payment verification API calls work
4. Payment records are created in database
5. Success/failure messages display correctly

## Next Steps After Testing

1. Switch to CREDO production credentials
2. Update base URL to production endpoint
3. Configure webhook endpoints for automatic verification
4. Monitor payment success rates
5. Set up error logging and monitoring

---

**Note:** This integration maintains backward compatibility while fully replacing Interswitch with CREDO payment platform.