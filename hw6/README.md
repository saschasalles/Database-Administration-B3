# HW6


## Consigne
* Créez une fichier Docker-compose.yml qui lance deux instances MariaDB
* Ajoutez les fichiers de configurations pour les serveurs Master et Slave
* Créez un script pour ajouter l'utilisateur avec les droits de replication sur master
* Assurez vous que les deux instances de base de données contiennent les mêmes données
* Démarrez le serveur master
* Ajoutez le master au slave
* Démarrez et vérifiez l'état du slave
* Créez une nouvelle base de données et une nouvelle table sur le serveur Master et vérifier que les données sont présentes sur le serveur slave



`docker-compose.yml` :

```
version: '3.7'

services:
  maria_master:
    image: mariadb:10.5

  maria_slave:
    image: mariadb:10.5

```

Pour les fichiers de configuration j'ai créé un dossier pour chaque conteneur (à leur nom) avec un fichier de configuration (`master.cnf` et `slave.cnf`).  
Chaque dossier contient un fichier data qui lui contiendra les différents fichiers/dossiers liés à mysql.
Pour pouvoir ensuite me connecter à mysql sur les instances mariadb j'ai complété la variable d'env `MYSQL_ROOT_PASSWORD` puis j'ai mis les bon ports (3306) aux conteneurs ainsi qu'un réseau `myNetwork`. 

`docker-compose.yml` :

```
version: '3.7'

services:
  master:
    image: mariadb:10.5
    environment:
      MYSQL_ROOT_PASSWORD: password
    ports:
      - 4406:3306
    volumes:
      - ./master/data:/var/lib/mysql
      - ./backups:/backups
      - ./master/master.cnf:/etc/mysql/mariadb.conf.d/master.cnf
      - ./scripts:/scripts
    networks:
      - overlay

  slave:
    image: mariadb:10.5
    environment:
      MYSQL_ROOT_PASSWORD: password
    ports:
      - 5506:3306
    volumes:
      - ./slave/data:/var/lib/mysql
      - ./backups:/backups
      - ./slave/slave.cnf:/etc/mysql/mariadb.conf.d/slave.cnf
      - ./scripts:/scripts
    networks:
      - overlay

networks:
  overlay:

```


`commandes.sql` dans le dossier `scripts` :

```
CREATE USER IF NOT EXISTS 'replicant'@'%' identified by 'myPassword';

grant replication slave on *.* to replicant;

flush privileges;
```

Puis `mysql -u root -p < /scripts/commandes.sql`/


Lancement de `docker-compose up` -> les deux conteneurs se lance automatiquement.
Pour rentrer dans le conteneur master on lance `docker exec -it hw6_master_1 sh`.
Pour ajouter le master au slave on se connecte à mysql sur le conteneur slave : `mysql -u root -p`.

Ensuite on va exécuter la commande suivante :

```
CHANGE MASTER TO
MASTER_HOST='master',
MASTER_USER='replicant',
MASTER_PASSWORD='myPassword',
MASTER_PORT=3306,
MASTER_LOG_FILE='master1-bin.000011',
MASTER_LOG_POS=1260,
MASTER_CONNECT_RETRY=10;
```


Pour démarrer l'état du slave on lance `START SLAVE` puis on regarde l'état du slave avec la commande `SHOW SLAVE STATUS`.
Résultat pour chaque ajout dans la base master, les données sont également présentes sur le slave.
