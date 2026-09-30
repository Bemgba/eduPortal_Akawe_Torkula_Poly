-- SQL script to add Fee Group Management page to the system
-- This allows the page to appear in staff dashboards for appropriate roles

-- Insert the new page into the pages table
-- Following the exact pattern from existing data:
-- - ID format: p0xxx (using p0053 as next available)
-- - Roles end with semicolon
-- - Menu ID M001 for Payments menu
-- - Comment field can be empty (using empty string)

INSERT INTO public.pages (id, name, description, status, comment, roles, manu_id, alias) 
VALUES ('p0053', 'adminCreateFeesGroup.jsp', 'Manage Fee Groups', 'ACTIVE', '', '1008;1043;1040;', 'M001', 'create_fees_group');

-- Role explanations based on existing patterns:
-- 1008 - Financial/Payment roles (appears in most M001 menu items)
-- 1043 - Admin roles (appears in most administrative functions)  
-- 1040 - Registrar roles (appears in academic/student related functions)

-- Menu M001 = "Payments" (financial management menu)

-- To execute this script:
-- 1. Connect to your PostgreSQL database
-- 2. Run: \i add_fee_group_management_page.sql
-- Or copy and paste the INSERT statement into your database management tool

-- Note: If p0053 is already taken, increment to next available ID (p0054, p0055, etc.)

-- Alternative: Query to find the next available page ID
-- Run this first to check what ID to use:
-- SELECT 'p' || LPAD((MAX(CAST(SUBSTRING(id, 2) AS INTEGER)) + 1)::TEXT, 4, '0') as next_id 
-- FROM pages WHERE id ~ '^p[0-9]+$';

-- If you prefer to be extra safe, you can also check if the ID exists:
-- SELECT COUNT(*) FROM pages WHERE id = 'p0053';
-- (Should return 0 if ID is available)