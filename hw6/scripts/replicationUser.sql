CREATE USER IF NOT EXISTS 'replicant'@'%' identified by 'myPassword';

grant replication slave on *.* to replicant;

flush privileges;