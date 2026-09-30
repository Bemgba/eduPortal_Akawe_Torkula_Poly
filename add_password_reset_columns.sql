-- SQL script to add password reset columns to users table
-- These columns are needed for the "Forgot Password" functionality

-- Add reset_token column if it doesn't exist
ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_token VARCHAR(255);

-- Add reset_token_expiry column if it doesn't exist  
ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_token_expiry TIMESTAMP;

-- Add index on reset_token for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_reset_token ON users(reset_token);

-- Add index on email for faster lookups during password reset
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Update any existing users to have a default status if null
UPDATE users SET status = 'ACTIVE' WHERE status IS NULL;

-- Add comment to document the purpose of these columns
COMMENT ON COLUMN users.reset_token IS 'UUID token for password reset functionality';
COMMENT ON COLUMN users.reset_token_expiry IS 'Expiration timestamp for reset token (30 minutes from generation)';