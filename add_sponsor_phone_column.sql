-- Add sponsor_phone column to applicants table
ALTER TABLE applicants ADD COLUMN sponsor_phone VARCHAR(20);

-- Optional: Add a comment to document the column
COMMENT ON COLUMN applicants.sponsor_phone IS 'Phone number of the applicant sponsor/guardian';

-- Optional: Add an index if this field will be searched frequently
-- CREATE INDEX idx_applicants_sponsor_phone ON applicants(sponsor_phone);