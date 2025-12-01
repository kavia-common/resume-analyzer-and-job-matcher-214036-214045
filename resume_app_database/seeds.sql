-- Optional seed data for development/demo

-- Upsert helper function for skills by name
DO $$
DECLARE
  v_skill RECORD;
  v_names TEXT[] := ARRAY[
    'Python', 'JavaScript', 'TypeScript', 'React', 'Node.js',
    'PostgreSQL', 'MongoDB', 'Docker', 'Kubernetes', 'AWS',
    'CI/CD', 'FastAPI', 'Django', 'REST APIs', 'GraphQL',
    'Data Analysis', 'Machine Learning', 'NLP', 'Linux', 'Git'
  ];
BEGIN
  FOREACH v_skill IN ARRAY v_names LOOP
    INSERT INTO skills (name, category)
    VALUES (v_skill::TEXT, 'general')
    ON CONFLICT (name) DO NOTHING;
  END LOOP;
END $$;

-- Sample jobs
WITH upsert_jobs AS (
  INSERT INTO jobs (title, company, location, description, url, job_source, posted_at)
  VALUES
    ('Backend Engineer (Python/FastAPI)', 'TechNova', 'Remote',
     'Build APIs, services, and data pipelines using FastAPI and PostgreSQL.',
     'https://example.com/jobs/1', 'manual', NOW() - INTERVAL '3 days'),
    ('Full Stack Developer (React/Node)', 'BrightApps', 'Bengaluru, IN',
     'Develop frontend in React and backend in Node with PostgreSQL.',
     'https://example.com/jobs/2', 'manual', NOW() - INTERVAL '5 days'),
    ('Data Engineer (AWS, Python)', 'CloudWorks', 'Hyderabad, IN',
     'Design ETL pipelines, manage data infra on AWS, Python-based tooling.',
     'https://example.com/jobs/3', 'manual', NOW() - INTERVAL '7 days')
  ON CONFLICT DO NOTHING
  RETURNING id, title
)
SELECT 1;

-- Map job skills if jobs exist
DO $$
DECLARE
  v_job RECORD;
  v_skill_id UUID;
BEGIN
  -- Backend Engineer skills
  FOR v_job IN SELECT id FROM jobs WHERE title = 'Backend Engineer (Python/FastAPI)'
  LOOP
    SELECT id INTO v_skill_id FROM skills WHERE name = 'Python';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'FastAPI';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'PostgreSQL';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 4) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'Docker';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 3) ON CONFLICT DO NOTHING;
    END IF;
  END LOOP;

  -- Full Stack Developer skills
  FOR v_job IN SELECT id FROM jobs WHERE title = 'Full Stack Developer (React/Node)'
  LOOP
    SELECT id INTO v_skill_id FROM skills WHERE name = 'React';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'Node.js';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'PostgreSQL';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 4) ON CONFLICT DO NOTHING;
    END IF;
  END LOOP;

  -- Data Engineer skills
  FOR v_job IN SELECT id FROM jobs WHERE title = 'Data Engineer (AWS, Python)'
  LOOP
    SELECT id INTO v_skill_id FROM skills WHERE name = 'AWS';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'Python';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 5) ON CONFLICT DO NOTHING;
    END IF;

    SELECT id INTO v_skill_id FROM skills WHERE name = 'Data Analysis';
    IF v_skill_id IS NOT NULL THEN
      INSERT INTO job_skills (job_id, skill_id, importance)
      VALUES (v_job.id, v_skill_id, 3) ON CONFLICT DO NOTHING;
    END IF;
  END LOOP;
END $$;

-- Demo user and resume placeholders (safe upserts)
INSERT INTO users (email, full_name)
VALUES ('demo@example.com', 'Demo User')
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name;

-- One minimal resume row linked to demo user
INSERT INTO resumes (user_id, title, original_file_name, status)
SELECT id, 'Demo Resume', 'demo.pdf', 'uploaded'
FROM users WHERE email = 'demo@example.com'
ON CONFLICT DO NOTHING;
