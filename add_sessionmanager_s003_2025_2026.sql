-- Add SessionManager record for School S003 (College of Health Sciences)
-- Session: 2025/2026, Operation: APPLICATION, Status: OPEN

INSERT INTO sessionmanager (id, name, start_date, end_date, school_id, programme_id, semester, operation, status, status_comment)
VALUES ('20259994', '2025/2026', '2026-03-04 15:10:58.000', NULL, 'S003', NULL, 'Session', 'APPLICATION', 'OPEN', NULL);

-- Verify the record was created
SELECT * FROM sessionmanager WHERE school_id = 'S003' AND name = '2025/2026' AND operation = 'APPLICATION';
