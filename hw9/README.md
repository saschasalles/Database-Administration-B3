# HW9

## Première partie

1 - Créez un nouveau dashboard  
2 - Ajoutez un panel avec un graphique du taux d'opérations READ  
3 - Ajoutez un panel qui affiche simplement le nombre total de tentatives de connexion refusées  
4 - Ajoutez un panel sous forme de compteur (gauge) qui affiche le temps nécessaire à l'exporter pour scrapper les données liées aux connections depuis le serveur MariaDB, trouvez un format et des limites adaptées.

## Première partie (rendu)

### Création des fichiers de config.

Pour `grafana`, j'ai récupéré la configuration par défault officielle.

J'ai repris exactement la même que pour le tp précédent pour `prometheus`.
On aura évidemment un service `mysql-exporter` qui sera connecté à la base de données du service `mariadb` sur son port `3306` et qui sera également lié à `prometheus`.

Ces quatre services seront lancés à l'aide d'un fichier `docker-compose`.

### Indiquer à Grafana où récupérer les données.

`Prometheus` fonctionne et lit bien les données en provenance du conteneur `mysql-exporter`.
On peux donc ajouter à Grafana une source de donnée grâce à son interface.
Grafana nous permet d'ajouter une source en provenance de `Prometheus` ce que l'on va faire.


Une fois la source de données ajoutée on créé un dashboard.
On laisse le graphique par défault, il nous convient.
Pour avoir le taux d'opérations READ j'ai utilisé la metrics `mysql_global_status_commands_total{command="select"}`.


J'ai ensuite ajouté un autre panel qui représente le nombre de connexions qui ont été refusées sur la base de données en me connectant avec les mauvais id.
Pour ces données j'ai utilisé la metrics `mysql_global_status_access_denied_errors`.

Il reste un dernier panel à ajouter qui est celui du temps nécessaire à l'`exporter` pour récupérer les données liées aux connections depuis MariaDB. La metrics est la suivante : `mysql_exporter_collector_duration_seconds{collector="collect.global_variables"}`
