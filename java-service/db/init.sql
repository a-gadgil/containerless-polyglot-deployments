CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO items (name)
SELECT * FROM (VALUES
    ('Host-Native Fat JAR Artifact'),
    ('JVM MemoryMax & Graceful SIGTERM'),
    ('PostgreSQL + Redis Loopback')
) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM items);
