# Advanced Features

With [Kubernetes](https://kubernetes.io/), public clouds, and the [dependency subcharts](/installation/dependencies) we use the sky is the limit as far as installation and deployment possibilities.  There is no way we can capture everything here.  We have run into several common deployment use cases which may come in handy which we try to document here.  Each feature is documented as a stand alone option however they can be combined where it makes sense to do so.  We also have no control over many of the variables involved in these deployments so these examples are provided as-is and should be considered as a reference example only.

* [Additional Nautobots](/advanced-features/additional-nautobots)
* [Celery Queues](/advanced-features/celery-queues)
* [Custom Nautobot Image](/advanced-features/custom-image)
* [Custom `nautobot_config.py`](/advanced-features/custom-nautobot-config)
* [Custom `uwsgi.ini`](/advanced-features/custom-uwsgi)
* [Existing Secrets](/advanced-features/existing-secrets)
* [External Database](/advanced-features/external-database)
* [External Redis](/advanced-features/external-redis)
* [Ingress](/advanced-features/ingress)
* [MySQL Support](/advanced-features/mysql)
* [PostgreSQL High Availability](/advanced-features/postgresql-ha)
* [PostgreSQL TLS](/advanced-features/postgresql-tls)
* [Prometheus Operator Metrics](/advanced-features/prometheus-metrics)
* [Redis Sentinel](/advanced-features/redis-sentinel)
* [Redis TLS](/advanced-features/redis-tls)

For additional configuration for one of the subcharts please see their documentation:

* [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) which can be configured under the `postgresql.*` values.
* [Bitnami PostgreSQL-HA chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha) which can be configured under the `postgresqlha.*` values.
* [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which can be configured under the `mariadb.*` values.
* [Bitnami Redis chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) which can be configured under the `redis.*` values.
