# resume_app_database

PostgreSQL setup for Resume Analyzer & Job Matcher.

- Port: 5000
- DB: myapp
- User: appuser / dbuser123

Files:
- schema.sql: Core schema (users, resumes, analyses, skills, jobs, mappings, recommendations).
- seeds.sql: Optional seed data (common skills and sample jobs).
- startup.sh: Initializes and starts PostgreSQL, creates DB/user, applies schema and seeds if present, and writes db_visualizer/postgres.env for quick viewer use.

Usage:
1) Run startup.sh inside this container environment.
2) The script will:
   - Ensure PostgreSQL is initialized and running on port 5000
   - Create database and user with proper permissions
   - Apply schema.sql automatically (if present)
   - Apply seeds.sql automatically (if present)
3) Connect:
   - psql -h localhost -U appuser -d myapp -p 5000
   - Or: psql postgresql://appuser:dbuser123@localhost:5000/myapp

Environment for simple viewer:
- After startup: source resume_app_database/db_visualizer/postgres.env
- Then run the viewer with: npm start (inside db_visualizer)

Notes:
- Do not hardcode credentials in code; this setup is strictly for local development/demo.
- For production, wire credentials via environment variables or secrets manager.
