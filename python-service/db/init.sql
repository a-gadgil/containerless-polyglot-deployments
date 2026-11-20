CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO items (name)
SELECT * FROM (VALUES
    ('Host-Native Python Venv'),
    ('Gunicorn + Uvicorn Workers'),
    ('PostgreSQL + Redis Loopback')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM items);
