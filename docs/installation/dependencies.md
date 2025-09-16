# Chart Dependencies

The Nautobot Helm Chart is intended to be an all-in-one solution for a basic deployment.  While we don't recommend using all of the out of the box functionality in production (see [Production Installation](../production/)) this chart does deploy some pre-requisites for Nautobot including [Redis](https://redis.io/) and [PostgreSQL](https://www.postgresql.org/).  Because we are not Redis or PostgreSQL experts, we simply leverage some other community helm charts to deploy these tools.  We have chosen to utilize the [Bitnami Helm Charts](https://bitnami.com/stacks/helm) as the basis for our deployments.  The dependencies we leverage are:

* [MariaDB](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)
* [PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) or [PostgreSQL-HA](https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha)
* [Redis](https://github.com/bitnami/charts/tree/main/bitnami/redis)
* [RabbitMQ](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq) (optional)

Each of these charts can be configured using the following values:

<!-- spell-checker: disable -->

```yaml
mariadb:
  enabled: false
postgresql:
  enabled: true
rabbitmq:
  enabled: false
redis:
  enabled: true
```

<!-- spell-checker: enable -->

Any other value embedded under the top level keys will get passed thru to the underlying dependency chart, please see the above linked sites for documentation on all of the available features.
