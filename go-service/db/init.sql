CREATE DATABASE IF NOT EXISTS appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'appuser'@'127.0.0.1' IDENTIFIED BY 'apppass';
CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'apppass';
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'appuser'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'appuser'@'localhost';
FLUSH PRIVILEGES;

USE appdb;

CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO items (name) VALUES
    ('Host-Native Artifact'),
    ('Systemd Unit Supervision'),
    ('Nginx Reverse Proxy');
