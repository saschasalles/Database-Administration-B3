# HW4 - Docker

## Première partie

Créez une image Docker qui contient tous les outils nécessaires pour mettre en place un système de backup automatique. Vous trouverez des ressources dans le TP 2 et 3 du cours de devops.
Vous pouvez créer votre image en local dans ce cas vous devez me faire parvenir le contenu de votre Dockerfile sinon vous pouvez vous créer un compte sur Docker Hub et uploader votre image dessus, dans ce cas veuillez me donner le lien publique vers votre image.

## Etapes

* Création d'un fichier `Dockerfile` que l'on pourra ensuite `build`, je me suis basé sur l'image trouvé sur dockerhub.
* Ajouter des sources pour télécharger de nouvelles applications (`apt-get`), install de `vim` puis `cron`.  
* Création d'une variable d'environnement dans le Dockerfile pour stocker le password de l'user root.
  (On aurait pu la passer via `docker run`).

### DockerFile

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y \
```

## Deuxième partie

Mettez en place une stratégie de backups grâce à cron qui génère un dump de la base de données tous les lundis à 17h et génère un fichier compressé en format gzip contenant la date de création.

## Etapes

* On reprend le `Dockerfile` de la première partie.
* J'ajoute une ligne qui va écrire dans le fichier de config de cron pour l'user root qui fera un dump de toutes les bases de données chaque semaine et chaque mois le lundi à 17h.
* Ce fichier sera compréssé avec `gzip` et portera le nom `all_databases`.

### DockerFile

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y

RUN echo '0 17 * * 1 mysqldump -u root --password=password --all-databases | gzip -9 > /backup/all_databases_`date +"\%Y-\%m-\%d_"`.sql.gz' >> /var/spool/cron/crontabs/root

```

## Troisième partie

Mettez en place une stratégie de backups avec logrotate qui réalise un dump journalier compressé en format bz2 et qui garde les 5 derniers dumps.

## Etapes

* install de Logrotate.
* Config de logrotate pour qu'il fasse une backup de notre base de données chaque jour et qu'il garde les 5 derniers dumps.
Pour cela je modifie le fichier de conf de logrotate ici `/etc/logrotate.d/`.

### Dockerfile et lien de l'image complete

[Lien de l'image avec le tag `complete`](https://hub.docker.com/layers/sascha40/dbadmin-hw4/complete/images/sha256-80f7c3930c093d1b79a7d164ee560ab43a1ecd1429865644257a57e2488832a0?context=repo)

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y


# Edit cron config
RUN echo '0 17 * * 1 mysqldump -u root --password=password --all-databases | gzip -9 > /backup/all_databases_`date +"\%Y-\%m-\%d_"`.sql.gz' >> /var/spool/cron/crontabs/root

RUN apt-get install logrotate -y

RUN echo "/backups/all_databases.sql.b2z {" >> /etc/logrotate.d/confFile
RUN echo "rotate 5" >> /etc/logrotate.d/confFile
RUN echo "daily" >> /etc/logrotate.d/confFile
RUN echo "postrotate" >> /etc/logrotate.d/confFile
RUN echo "echo mysqldump -u root --password=password --all-databases | bzip2 > /backups/all_databases.sql.b2z" >> /etc/logrotate.d/confFile
RUN echo "endscript" >> /etc/logrotate.d/confFile
RUN echo "}" >> /etc/logrotate.d/confFile


RUN mkdir /backups && cd /backups && echo mysqldump -u root --password=password --all-databases | bzip2 > /backups/all_databases.sql.b2z

```
