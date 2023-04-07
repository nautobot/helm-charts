# Upgrading

!!! warning
    These upgrade instructions cover the upgrades of the helm chart only, they do NOT cover any steps necessary to upgrade the Nautobot application.  Please see the [official core documentation](https://docs.nautobot.com/projects/core/en/stable/installation/upgrading) for further details.

## Major Version Upgrades

### To 2.x

!!! note
    These instructions assume you have followed the very basic installation instructions as described above.  If you have utilized existing secrets or advanced options, please see the release notes referenced below for possible additional steps.

* The `celeryWorker` and `celeryBeat` values change to `workers.default` and `workers.beat` respectively.

* The PostgreSQL subchart was upgraded from version 10 to version 12, this was a breaking change, see the [release notes](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/) for more information.  At a minimum the following values must change:

    * `postgresql.postgresqlPostgresPassword` changes to `postgresql.auth.postgresPassword`
    * `postgresql.postgresqlUsername` changes to `postgresql.auth.username`
    * `postgresql.postgresqlPassword` changes to `postgresql.auth.password`
    * `postgresql.postgresqlDatabase` changes to `postgresql.auth.database`
    * `postgresql.existingSecret` changes to `postgresql.auth.existingSecret`
    * `postgresql.securityContext` changes to `postgresql.primary.podSecurityContext`
    * `postgresql.containerSecurityContext` changes to `postgresql.primary.containerSecurityContext`

* The Redis subchart was upgraded from version 16 to version 17, this was a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1600) for more information.  No default values passed to this chart have changed.
* The PostgreSQL-HA subchart was upgraded from version 8 to version 11, this was a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha#to-900) for more information.  At a minimum the following values must change:

    * `postgresqlha.postgresql.securityContext` changes to `postgresqlha.postgresql.podSecurityContext`
    * `postgresqlha.metrics.securityContext` changes to `postgresqlha.metrics.podSecurityContext`

* The MariaDB subchart was upgraded from version 10 to version 11, this is a breaking change, see the [release notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-1100) for more information.  No default values passed to this chart have changed.

#### Example Upgrade Procedure

!!! warning
    This is only an example based on the most simple default deployment case.  Be sure to read the [Bitnami PostgreSQL Release Notes](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/) before upgrading.

1. Please verify if any values in your local `values.yaml` file match the above values you will need to migrate them.  If you do not have the original `values.yaml` the chart was deployed with you can use `helm get values -n $NAMESPACE -o yaml` to get the deployed values.
2. ALWAYS [BACKUP YOUR DATABASE](/operations/backup-restore/#backup-nautobot) BEFORE UPGRADING!
3. Run the following Commands:

!!! note
    These steps were derived from the [Bitnami Release notes](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/) from Upgrading PostgreSQL, be sure to check them for any deltas you may have.

```no-highlight
export NAMESPACE=nautobot  # Be sure to use the correct namespace here
export POSTGRES_SECRET_NAME=nautobot-postgresql  # If you have changed the default make sure you change it here
export STATEFULSET_NAME=nautobot-postgresql  # If you have changed the default make sure you change it here
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $POSTGRES_SECRET_NAME -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export POSTGRESQL_POSTGRES_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $POSTGRES_SECRET_NAME -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)
export POSTGRESQL_PVC=$(kubectl get pvc --namespace $NAMESPACE -l app.kubernetes.io/instance=nautobot,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
export CURRENT_VERSION=$(kubectl exec --namespace $NAMESPACE nautobot-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')

echo $POSTGRESQL_PASSWORD
echo $POSTGRESQL_POSTGRES_PASSWORD
echo $POSTGRESQL_PVC
echo $CURRENT_VERSION
```

4. Ensure the values output above are correct.
5. Update your `values.yaml` moving the values to the new names as described above and in the Bitnami PostgreSQL Release Notes](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/).  A basic example would take a simple values file such as:

```yaml
celeryBeat:
  resources:
    requests:
      cpu: "1000m"
      memory: "2G"
celeryWorker:
  replicaCount: 4
postgresql:
  postgresqlPassword: change-me
redis:
  auth:
    password: change-me
```

and it would change to:

!!! note
    Make sure to replace the `postgresPassword`, `tag`, and `existingClaim` with the values from above.

```yaml
workers:
  beat:
    resources:
      requests:
      cpu: "1000m"
      memory: "2G"
  default:
    replicaCount: 4
postgresql:
  auth:
    password: change-me
    postgresPassword: ${POSTGRESQL_POSTGRES_PASSWORD from above}
  image:
    tag: ${CURRENT_VERSION from above}
  primary:
    persistence:
      existingClaim: ${POSTGRESQL_PVC from above}
redis:
  auth:
    password: change-me
```

!!! warning
    The following steps are disruptive and should be executed during a maintenance window.

6. Scale the Nautobot services to 0

```no-highlight
kubectl scale --namespace $NAMESPACE --replicas 0 deployment/nautobot deployment/nautobot-celery-beat deployment/nautobot-celery-worker
```

7. This would be a good time to get a pristine [backup](/operations/backup-restore/#backup-nautobot) of your database

```no-highlight
kubectl delete statefulsets.apps $STATEFULSET_NAME --namespace $NAMESPACE --cascade=orphan
kubectl delete secret $POSTGRES_SECRET_NAME --namespace $NAMESPACE
kubectl delete pod --namespace default nautobot-postgresql-0
helm repo update nautobot
helm upgrade nautobot nautobot/nautobot -f ${New values.yaml file from above}
```

!!! note
    The instructions above reuse the same PostgreSQL version you were using in your chart release. Otherwise, you will find an error such as the one below when upgrading since the new chart major version also bumps the application version. To workaround this issue you need to upgrade database, please refer to the [official PostgreSQL documentation](https://www.postgresql.org/docs/current/upgrading.html) for more information about this.

## Minor Version Upgrades

## Nautobot Versions

This chart doesn't always get a new release with a new release of Nautobot, therefore the chart versions do NOT correspond to a Nautobot version.  It is possible to deploy newer Nautobot versions with this chart however, to do this simply run a command similar to:

```no-highlight
helm upgrade nautobot nautobot/nautobot --reuse-values --set nautobot.image.tag=1.5.X-py3.10
```

## 1.0.x to 1.1.x

Following the normal helm upgrade procedures is sufficient for upgrading during this release:

```no-highlight
helm repo update nautobot
helm upgrade nautobot nautobot/nautobot --reuse-values
```
