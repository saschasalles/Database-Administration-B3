CREATE SCHEMA IF NOT EXISTS teams;
 
USE teams;

DROP TABLE IF EXISTS games;
CREATE TABLE games(
  victory INTEGER,
  observations TEXT,
  match_date DATE
);

DROP TABLE IF EXISTS players;
CREATE TABLE players(
  firstname INTEGER,
  lastname TEXT,
  start_date DATE
);

CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'manager_password';
GRANT ALL ON teams.games TO 'manager'@'localhost';

FLUSH PRIVILEGES;

CREATE USER IF NOT EXISTS 'recruiter'@'localhost' IDENTIFIED BY 'recruiter_password';
GRANT INSERT, SELECT ON teams.players TO 'recruiter'@'localhost';

FLUSH PRIVILEGES;

/* Lancer le script en root :
# mysql -u root -p < data.sql
*/

