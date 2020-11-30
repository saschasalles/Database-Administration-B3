# HW4

## Consigne

Utilisez la configuration docker-compose précédente afin d'instancier un serveur MySQL et un serveur MariaDB qui partagent un dossier /backups commun.

Connectez vous en premier au serveur MySQL, créez une base de données avec au moins une table qui contient quelques données.

Exportez cette base de données dans le dossier /backups.

Connectez vous au serveur MariaDB et importez la base que vous venez d'exporter.

## Etapes

- Création d'un fichier docker-compose.yaml avec le même contenu que dans le slide.
- `docker-compose build` du docker-compose.yaml
- `docker-compose up -d` pour lancer les deux container
- `docker-compose exec mysql sh` pour me connecter au shell du conteneur mysql.
- Création d'une bdd nommée `HW5` avec la table `first_name` ainsi que quelques données.
- Dump de la table grace à `mysqldump -u root -p HW5 > /backups/backup.sql` dans le directory `backups` soit le volume partagé par les deux conteneurs.
- Puis `exit` pour sortir du container.
- `docker-compose exec maria sh` pour me connecter au shell du container maria.
- Création d'une bdd nommée `HW5`.
- `mariadb -u root -p HW5 < /backups/backup.sql`

### Docker-compose.yaml

```
version: '3.7'

services:
  mysql:
    image: mysql:5.7
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - ./mysql:/var/lib/mysql
      - ./backups:/backups

  maria:
    image: mariadb:10.4
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - ./maria:/var/lib/mysql
      - ./backups:/backups

```
