# HW8

## Première partie

Créez un fichier docker-compose qui réunit

- Un serveur mariaDB
- Un serveur prometheus
- Un serveur mysql-exporter

Et relier les entre eux.

## Etapes

Pour cette première partie j'ai tout simplement créé un docker-compose avec trois services :

- mariadb : notre serveur de base de données
- prometheus : notre serveur d'agrégation de données
- mysql-exporter : exporter mysql connecté à notre base données, source de données du serveur prometheus.

Le service `mariaDb` est instancié sur le port `3306`.
 `L'exporter mysql` sur le port `9104` avec une connexion au serveur mariadb.  
Puis , le service `prometheus` est instancié sur le port `9090` mais est aussi connecté au port `9090` de mon `localhost`.

Pour les relier j'utilise le comportement par defaut avec `docker-compose`.
En effet les containers seront dans le même réseau.
On pourra donc utiliser leur nom comme nom d'hôte, docker fera le reste.

## Deuxième partie

1 - Créez un graphique qui affiche toutes les opérations de lectures et d'écritures.  
2 - Créez un graphique qui affiche la variation du taux d'opérations de lectures et d'écritures en prenant en compte la moyenne sur les 5 dernières minutes

## Etapes

Pour l'instant Prometheus n'a pas de source de données
On va donc ajouter un volume à ce service dans le fichier `docker-compose`.
Ce volume permettra au container d'accéder à un nouveau fichier : `prometheus.yml`.
On indique à l'intérieur l'intervalle de temps d'analyse des données, la destination d'envoi des données (ici  `localhost:9090`) puis la source des données soit `exporter-mysql`, accessible au `mysql-exporter:9104`.

### Graphique avec les opérations de lecture & écriture

#### Lectures & Ecritures

En rouge les requêtes insert
![Lectures & Ecritures](./images/rw.png?raw=true)

#### Variation du taux d'opérations de lectures et d'écritures en prenant en compte la moyenne sur les 5 dernières minutes

![variation du taux d'opérations de lectures et d'écritures (moyenne de 5min)](./images/mean.png?raw=true)
