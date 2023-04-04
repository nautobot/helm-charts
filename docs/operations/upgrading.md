# Upgrading

## To 2.x

!!! note
    These instructions assume you have followed the very basic installation instructions as described above.  If you have utilized existing secrets or advanced options, please see the release notes referenced below for possible additional steps.

* The PostgreSQL subchart was upgraded from version 10 to version 11, this was a breaking change, see the [release notes](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/) for more information.  At a minimum the following values must change:

    * `postgresql.postgresqlPostgresPassword` changes to `postgresql.auth.postgresPassword`
    * `postgresql.postgresqlUsername` changes to `postgresql.auth.username`
    * `postgresql.postgresqlPassword` changes to `postgresql.auth.password`
    * `postgresql.postgresqlDatabase` changes to `postgresql.auth.database`
    * `postgresql.existingSecret` changes to `postgresql.auth.existingSecret`
    * `postgresql.securityContext` changes to `postgresql.primary.podSecurityContext`
    * `postgresql.containerSecurityContext` changes to `postgresql.primary.containerSecurityContext`

* The Redis subchart was upgraded from version 16 to version 17, this was a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1600) for more information.  No default values passed to this chart have changed.
* The PostgreSQL-HA subchart was upgraded from version 8 to version 9, this was a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha#to-900) for more information.  At a minimum the following values must change:

    * `postgresqlha.postgresql.securityContext` changes to `postgresqlha.postgresql.podSecurityContext`
    * `postgresqlha.metrics.securityContext` changes to `postgresqlha.metrics.podSecurityContext`

* The MariaDB subchart was upgraded from version 10 to version 11, this is a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-1100) for more information.  No default values passed to this chart have changed.

1. Please verify if any values in your local `values.yaml` file match the above values you will need to migrate them.
2. ALWAYS [BACKUP YOUR DATABASE](https://github.com/nautobot/helm-charts/tree/develop/charts/nautobot#backup-nautobot) BEFORE UPGRADING!
3. Run the following Commands:

```no-highlight
export NAMESPACE=nautobot  # Be sure to use the correct namespace here
export POSTGRES_SECRET_NAME=nautobot-postgresql  # If you have changed the default make sure you change it here
export STATEFULSET_NAME=nautobot-postgresql  # If you have changed the default make sure you change it here
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $POSTGRES_SECRET_NAME -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_POSTGRES_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $POSTGRES_SECRET_NAME -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)

kubectl delete statefulsets.apps $STATEFULSET_NAME --namespace $NAMESPACE --cascade=false
kubectl delete secret $POSTGRES_SECRET_NAME --namespace $NAMESPACE
```

## 1.0.x to 1.1.x

Following the normal helm upgrade procedures is sufficient for upgrading during this release:

```no-highlight
helm repo update nautobot
helm upgrade nautobot nautobot/nautobot -f nautobot.values.yaml
```
