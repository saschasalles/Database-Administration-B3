CREATE DATABASE clients;

USE clients;

CREATE TABLE clients(
  last_name VARCHAR(255),
  first_name VARCHAR(255),
  born_date DATE,
  postal_code VARCHAR(255)
);

INSERT INTO clients (last_name, first_name, born_date, postal_code) VALUES ("Doe", "John", "2001-01-01","33001");
INSERT INTO clients (last_name, first_name, born_date, postal_code) VALUES ("Doe", "John", "2002-02-02","33002");
INSERT INTO clients (last_name, first_name, born_date, postal_code) VALUES ("Doe", "John", "2003-03-03","33003");

SELECT first_name, postal_code FROM clients;