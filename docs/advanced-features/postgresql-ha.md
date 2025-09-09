# PostgreSQL High Availability

!!! warning
    PostgreSQL HA support is deprecated in version 3.0.0 of the charts. Please use another method of deployment prior to upgrading.

!!! warning
    This chart provides this as an example only.  For true production environments please consider your cloud provider's offerings or deploying the [PostgreSQL-HA](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha) separately.

This chart supports the deployment of PostgreSQL in a Highly Available (HA) fashion as provided by the Bitnami [PostgreSQL-HA](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha) chart.  To enable HA PostgreSQL use the following values:

```yaml
postgresql:
  enabled: false
postgresqlha:
  enabled: true
  postgresql:
    password: "change-me"
    repmgrPassword: "change-me"
    postgresPassword: "change-me"
  pgpool:
    adminPassword: "change-me"
```

It is important to note all 4 passwords as they will be required during an upgrade.  PostgreSQL supports existing secrets as well when configured with the following values:

```yaml
postgresqlha:
  postgresql:
    existingSecret: "my-secret"
  pgpool:
    existingSecret: "my-secret"
```

This secret can be created with:

```no-highlight
kubectl create secret generic my-secret --from-literal=admin-password=change-me --from-literal=postgresql-password=change-me --from-literal=postgresql-postgres-password=change-me --from-literal=repmgr-password=change-me
```

This helm chart's support for PostgreSQL HA is still in an early alpha/beta phase you should use this feature cautiously.
