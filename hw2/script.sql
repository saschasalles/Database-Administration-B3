CREATE DATABASE events;

USE events;

CREATE TABLE public_events(
  event_name VARCHAR(255),
  event_age_requirement INTEGER,
  event_date DATE
);

CREATE TABLE private_events LIKE public_events;

CREATE USER 'event_manager'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON events.* TO 'event_manager'@'localhost';

CREATE USER 'event_supervisor'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON events.public_events TO 'event_supervisor'@'localhost';

FLUSH PRIVILEGES;

/* Déconnexion de l'utilisateur root puis reconnexion avec l'utilisateur event_manager :
# mysql -u event_manager -p
*/

INSERT INTO public_events (event_name, event_age_requirement, event_date) VALUES ("My first eve,t", 8, "2021-08-01");

/* Réponse de mysql : Query OK, 1 row affected (0.01 sec) 

Déconnexion de l'utilisateur event_manager puis reconnexion avec l'utilisateur event_supervisor :
# mysql -u event_supervisor -p
*/

SELECT * FROM public_events;

/* Réponse : 

+----------------+-----------------------+------------+
| event_name     | event_age_requirement | event_date |
+----------------+-----------------------+------------+
| My first eve,t |                     8 | 2021-08-01 |
+----------------+-----------------------+------------+
1 row in set (0.00 sec)

*/

SELECT * FROM private_events;

/* Réponse de mysql (erreur car l'utilisateur n'a pas les droits sur cette table) :

ERROR 1142 (42000): SELECT command denied to user 'event_supervisor'@'localhost' for table 'private_events'
ERROR:
No query specified


Reconnexion avec root pour supprimer l'utilisateur :
# mysql -u root -p
*/

DROP USER 'event_supervisor'@'localhost';










