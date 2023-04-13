# Nautobot Helm Chart Version 2.x

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0 - Unreleased

### Added

* Added the ability to create additional endpoints for scaling out, for example `/api` requests can now have their own deployments see `Values.nautobots` and the [Additional Nautobots](/advanced-features/additional-nautobots) page.
* Added the ability to deploy additional celery workers to listen on [additional queues](https://docs.nautobot.com/projects/core/en/stable/administration/celery-queues/) see `Values.workers` and the [Celery Queues](/advanced-features/celery-queues) page
* Added optional [RabbitMQ support](/advanced-features/rabbitmq) for Celery Task Queueing
* Added the ability to create an nginx deployment exclusively for `/static` files.  See the [documentation here](/advanced-features/static-only).
* Added the ability to run a single Job for Nautobot post_install tasks in certain scenarios.  See the [documentation here](/advanced-features/init-hook).
* Added support for Nginx (`nautobot.nginx.enabled`) as a proxy to Nautobot (deployed as a sidecar)
* Added support for Nginx exporters (`metrics.nginxExporter.enabled`)
* Added support for UWSGI exporters (`metrics.uwsgiExporter.enabled`)
* [191](https://github.com/nautobot/helm-charts/issues/191) Added Observability for Celery Workers
* Added the ability to specify `automountServiceAccountToken` on the `ServiceAccount`

### Changed

* [Docs on the official Nautobot Docs site](https://helm-charts.readthedocs.io/en/latest/)!
* Default database engine now accounts for `METRICS_ENABLED`
* Moved Nautobot post-upgrade task to a separate init container
* Nautobot Version 1.5.16
* Upgraded Bitnami common subchart from 1.14.1 to 2.2.4
* Upgraded Mariadb subchart from 10.5.1 to 11.5.6
* Upgraded PostgreSQL-HA subchart from 8.6.13 to 11.2.1
* Upgraded Redis subchart from 16.10.1 to 17.9.3
* Updated JSON Schema to utilize external schemas where appropriate

### Deprecated

* The `Values.celeryWorker` has been deprecated and moved to `Values.workers.default`
* The `Values.celeryBeat` has been deprecated and moved to `Values.workers.beat`
