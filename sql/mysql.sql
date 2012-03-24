CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);
CREATE TABLE IF NOT EXISTS memo (
    path  VARCHAR(255) PRIMARY KEY,
    timestamp  TIMESTAMP default '0000-00-00 00:00:00',
    title TEXT,
    body  LONGTEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;;

