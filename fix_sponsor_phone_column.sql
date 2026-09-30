-- Fix sponsor_phone column issue
-- This script adds the missing sponsor_phone column to the applicants table

-- First, check if the column already exists (optional check)
-- SELECT column_name FROM information_schema.columns 
-- WHERE table_name = 'applicants' AND column_name = 'sponsor_phone';

-- Add the sponsor_phone column
ALTER TABLE applicants ADD COLUMN sponsor_phone VARCHAR(20);

-- Add a comment to document the column
COMMENT ON COLUMN applicants.sponsor_phone IS 'Phone number of the applicant sponsor/guardian';

-- Optional: Set default value for existing records (if needed)
-- UPDATE applicants SET sponsor_phone = '' WHERE sponsor_phone IS NULL;

-- Verify the column was added
SELECT column_name, data_type, character_maximum_length 
FROM information_schema.columns 
WHERE table_name = 'applicants' AND column_name = 'sponsor_phone';

-- Show the updated table structure
\d applicants;