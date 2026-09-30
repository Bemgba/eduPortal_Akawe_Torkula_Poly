-- Populate coursesjambmapping table with common JAMB course mappings
-- This maps JAMB course names (as they appear in Excel uploads) to internal course IDs

-- First, let's check what school programmes exist for undergraduate programs
-- SELECT * FROM schoolprogrammes WHERE programme_id = '1001'; -- Undergraduate

-- Insert course mappings for common JAMB courses
-- Format: (course_id, jamb_name, school_programme_id)

-- Computer Science mappings
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00023', 'computer science', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Medicine mappings  
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00061', 'medicine', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00061', 'medicine and surgery', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00061', 'mbbs', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Other Science courses
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00029', 'physics', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C64548', 'biochemistry', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C18115', 'human physiology', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C35147', 'nursing', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C35147', 'nursing science', '10013')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Business/Management courses
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00019', 'accounting', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00024', 'economics', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00021', 'business administration', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00021', 'business management', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Social Sciences
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00032', 'sociology', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00031', 'psychology', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00025', 'geography', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Law
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C00033', 'law', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Mass Communication
INSERT INTO coursesjambmapping (id, jamd_name, school_programmes_id) 
VALUES ('C94958', 'mass communication', '10001')
ON CONFLICT (jamd_name, school_programmes_id) DO NOTHING;

-- Verify the insertions
SELECT cm.id, cm.jamd_name, c.name as course_name, sp.name as school_programme
FROM coursesjambmapping cm
JOIN courses c ON cm.id = c.id
JOIN schoolprogrammes sp ON cm.school_programmes_id = sp.id
ORDER BY cm.jamd_name;