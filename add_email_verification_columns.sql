-- SQL script to add email verification and security enhancement columns to users table
-- This script adds email verification functionality while preserving existing password reset functionality

-- Add email verification columns
ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_token VARCHAR(255) UNIQUE NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_token_expiration TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_verification_sent_at TIMESTAMP NULL;

-- Add security and audit columns
ALTER TABLE users ADD COLUMN IF NOT EXISTS failed_login_attempts INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS locked_until TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS remember_token VARCHAR(255) NULL;

-- Add audit fields
ALTER TABLE users ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS created_by VARCHAR(50) NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_by VARCHAR(50) NULL;

-- Add soft delete fields
ALTER TABLE users ADD COLUMN IF NOT EXISTS deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email_verified_at ON users(email_verified_at);
CREATE INDEX IF NOT EXISTS idx_users_verification_token ON users(verification_token);
CREATE INDEX IF NOT EXISTS idx_users_verification_token_expiration ON users(verification_token_expiration);
CREATE INDEX IF NOT EXISTS idx_users_failed_login_attempts ON users(failed_login_attempts);
CREATE INDEX IF NOT EXISTS idx_users_locked_until ON users(locked_until);
CREATE INDEX IF NOT EXISTS idx_users_deleted ON users(deleted);
CREATE INDEX IF NOT EXISTS idx_users_status_email_verified ON users(status, email_verified_at);

-- Update existing users to have default values
UPDATE users SET 
    failed_login_attempts = 0,
    deleted = FALSE,
    created_at = COALESCE(created_at, CURRENT_TIMESTAMP),
    updated_at = CURRENT_TIMESTAMP
WHERE failed_login_attempts IS NULL OR deleted IS NULL;

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at on user changes
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Verification queries to check the new structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'users' 
    AND column_name IN (
        'email_verified_at', 'verification_token', 'verification_token_expiration',
        'last_verification_sent_at', 'failed_login_attempts', 'last_login_at',
        'locked_until', 'remember_token', 'created_at', 'updated_at',
        'created_by', 'updated_by', 'deleted', 'deleted_at'
    )
ORDER BY ordinal_position;

-- Sample queries to verify functionality
-- Check unverified users
-- SELECT id, username, email, email_verified_at, verification_token FROM users WHERE email_verified_at IS NULL LIMIT 5;

-- Check users with failed login attempts
-- SELECT id, username, email, failed_login_attempts, locked_until FROM users WHERE failed_login_attempts > 0 LIMIT 5;

-- Check deleted users (soft delete)
-- SELECT id, username, email, deleted, deleted_at FROM users WHERE deleted = TRUE LIMIT 5;

COMMIT;