-- Ensure password_reset_tokens table exists and is properly configured
-- Run this script to fix any database issues

-- Check if table exists and create if needed
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'password_reset_tokens') THEN
        -- Create the password_reset_tokens table
        CREATE TABLE password_reset_tokens (
            id BIGSERIAL PRIMARY KEY,
            user_id VARCHAR(50) NOT NULL,
            token VARCHAR(255) NOT NULL UNIQUE,
            expiry_time TIMESTAMP NOT NULL,
            created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            used BOOLEAN DEFAULT FALSE
        );
        
        -- Create indexes for better performance
        CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);
        CREATE INDEX idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
        CREATE INDEX idx_password_reset_tokens_expiry ON password_reset_tokens(expiry_time);
        
        RAISE NOTICE 'Created password_reset_tokens table with indexes';
    ELSE
        RAISE NOTICE 'password_reset_tokens table already exists';
    END IF;
END $$;

-- Verify table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'password_reset_tokens'
ORDER BY ordinal_position;

-- Check current tokens (for debugging)
SELECT 
    id,
    user_id,
    LEFT(token, 10) || '...' as token_preview,
    expiry_time,
    created_time,
    used,
    CASE 
        WHEN expiry_time < NOW() THEN 'EXPIRED'
        WHEN used = true THEN 'USED'
        ELSE 'VALID'
    END as status
FROM password_reset_tokens 
ORDER BY created_time DESC
LIMIT 10;

-- Clean up expired tokens
DELETE FROM password_reset_tokens 
WHERE expiry_time < NOW() OR used = TRUE;

COMMIT;