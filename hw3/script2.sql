CREATE SCHEMA IF NOT EXISTS teams;
 
USE teams;

CREATE TABLE IF NOT EXISTS games(
  victory INTEGER,
  observations TEXT,
  match_date DATE
);

INSERT INTO games (victory, observations, match_date) VALUES (8, "This game was so hard !", "2019-08-01");

/*
Le script ne fonctionne que si manager existe. Je créer la base de données si elle n'existe pas. 


Pour exécuter le script :
mysql -u manager -p < insert.sql
*/
