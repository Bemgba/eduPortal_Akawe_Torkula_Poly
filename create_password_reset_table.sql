-- SQL script to create password_reset_tokens table for forgot password functionality
-- This table stores temporary tokens for password reset requests

-- Create the password_reset_tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expiry_time TIMESTAMP NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used BOOLEAN DEFAULT FALSE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_token ON password_reset_tokens(token);
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_expiry ON password_reset_tokens(expiry_time);

-- Add foreign key constraint to users table (optional - uncomment if needed)
-- ALTER TABLE password_reset_tokens 
-- ADD CONSTRAINT fk_password_reset_user 
-- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Create a function to automatically clean up expired tokens (optional)
CREATE OR REPLACE FUNCTION cleanup_expired_password_tokens()
RETURNS void AS $$
BEGIN
    DELETE FROM password_reset_tokens 
    WHERE expiry_time < NOW() OR used = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Verification queries to check the table structure
-- SELECT * FROM password_reset_tokens LIMIT 5;
-- SELECT COUNT(*) FROM password_reset_tokens;

-- Example cleanup command (run periodically)
-- SELECT cleanup_expired_password_tokens();

COMMIT;