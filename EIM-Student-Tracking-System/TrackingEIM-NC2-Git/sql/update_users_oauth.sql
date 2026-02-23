-- Update users table to support OAuth (Google Sign-In)
-- Run this in phpMyAdmin

-- Add columns for OAuth support
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS oauth_provider VARCHAR(20) NULL AFTER role,
ADD COLUMN IF NOT EXISTS oauth_id VARCHAR(255) NULL AFTER oauth_provider,
ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(500) NULL AFTER oauth_id;

-- Make password nullable for OAuth users
ALTER TABLE users MODIFY password VARCHAR(255) NULL;

-- Add unique index for OAuth provider + ID combination
ALTER TABLE users ADD UNIQUE KEY uniq_oauth (oauth_provider, oauth_id);
