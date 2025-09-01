# MySQL Support

!!! warning
    MariaDB subchart is dropped in version 3, any deployment prior to that should remove it from this helm chart.

!!! warning
    MySQL support is not heavily tested by the Nautobot team and community.  Also there have been issues reported that are unique to MariaDB vs MySQL, while these have been addressed by the Nautobot team, please be aware MariaDB is not 100% MySQL.

MySQL support was added in Nautobot 1.1.0 and is optionally supported with this helm chart.  This support is provided by the [Bitnami MariaDB](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) chart.  To enable MariaDB use the following values:

```yaml
postgresql:
  enabled: false
mariadb:
  enabled: true
  auth:
    password: "change-me"
```

MariaDB supports an existing secret as well:

```yaml
mariadb:
  auth:
    existingSecret: "my-secret"
```

Use existing secret for password details (auth.rootPassword, auth.password, auth.replicationPassword will be ignored and picked up from this secret). The secret has to contain the keys mariadb-root-password, mariadb-replication-password and mariadb-password
