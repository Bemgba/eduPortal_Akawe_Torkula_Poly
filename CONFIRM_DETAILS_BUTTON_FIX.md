# Confirm Details Button Fix

## Issue

The "Confirm Details" button on `website_epayment_applicants.jsp` was not responding when clicked. Users would enter their applicant ID and click the button, but the page would not verify their details or show payment options.

## Root Cause

The button validation regex was rejecting the button value because it contained a space:

```jsp
// OLD CODE - BROKEN
if (button != null && !button.matches("^[a-zA-Z\\-_]{1,20}$")) {
    button = null; // Invalid button value - REJECTS "Confirm Details"
}
```

The regex pattern `^[a-zA-Z\\-_]{1,20}$` only allows:
- Letters (a-z, A-Z)
- Hyphens (-)
- Underscores (_)
- Length: 1-20 characters

But the actual button value is **"Confirm Details"** which contains a **space**, causing the validation to fail and set `button = null`.

When `button` is null, this condition is never met:
```jsp
if (button != null && appid != null && appid.trim().length() > 0) {
    // Verify applicant and show payment options
}
```

## Solution

Updated the regex to allow spaces and increased the length limit:

```jsp
// NEW CODE - FIXED
if (button != null && !button.matches("^[a-zA-Z\\-_ ]{1,30}$")) {
    button = null; // Invalid button value
}
```

Changes:
- Added space character to the allowed pattern: `[a-zA-Z\\-_ ]`
- Increased max length from 20 to 30 characters (to accommodate longer button text)

## Testing

After this fix, the manual entry flow should work:

1. User enters applicant ID (e.g., "APP123" or "UTME/2024/001")
2. User clicks "Confirm Details" button
3. Page validates the applicant ID
4. If valid: Shows applicant details and payment options
5. If invalid: Shows error message "Error: Invalid applicant ID format..."

## Files Modified

- `src/main/webapp/website_epayment_applicants.jsp` (Line 48)
