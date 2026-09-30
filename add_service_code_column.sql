-- Simple SQL script to add service code support for CREDO school-specific routing
-- This implements the hardcoded business logic: School S001 gets special service code

-- 1. Add service_code column to banks table (if not already added)
ALTER TABLE banks ADD COLUMN IF NOT EXISTS service_code VARCHAR(50) COMMENT 'CREDO service code for school-specific bank routing';

-- 2. Create two bank records for the hardcoded service codes

-- Bank for special school (S001)
INSERT INTO banks (id, name, service_code) VALUES 
('BANK_SPECIAL', 'Special School Account (S001)', '008219RFI2DJ')
ON DUPLICATE KEY UPDATE 
name = 'Special School Account (S001)', 
service_code = '008219RFI2DJ';

-- Bank for default schools (all others)
INSERT INTO banks (id, name, service_code) VALUES 
('BANK_DEFAULT', 'General Schools Account', '0082192DLY7O')
ON DUPLICATE KEY UPDATE 
name = 'General Schools Account', 
service_code = '0082192DLY7O';

-- 3. Create index for better performance
CREATE INDEX IF NOT EXISTS idx_banks_service_code ON banks(service_code);

-- 4. Verification query to check the setup
SELECT id, name, service_code FROM banks WHERE service_code IS NOT NULL;

-- Expected result:
-- BANK_SPECIAL | Special School Account (S001) | 008219RFI2DJ
-- BANK_DEFAULT | General Schools Account       | 0082192DLY7O

-- 5. Business Logic Summary:
-- School S001 → Service Code 008219RFI2DJ → BANK_SPECIAL
-- All other schools → Service Code 0082192DLY7O → BANK_DEFAULT