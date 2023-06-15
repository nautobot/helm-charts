# Nautobot Helm Chart Version 2.x

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.3 - 2023-06-16

### Fixed

* [#288](https://github.com/nautobot/helm-charts/issues/288) README Typo
* [#286](https://github.com/nautobot/helm-charts/issues/286) Bug: variable celery.concurrency not used

### Changed

* [#293](https://github.com/nautobot/helm-charts/issues/293) Allow Increasing uwsgi buffer size
* Upgraded Nautobot from 1.5.20 to 1.5.21

## 2.0.2 - 2023-06-05

### Fixed

* Fixed [#279](https://github.com/nautobot/helm-charts/issues/279) Using nautobot.db.password no longer supported in 2.0.1

## 2.0.1 - 2023-06-04

### Added

* Added support for `terminationGracePeriodSeconds` to Nautobot and Celery Workers

### Changed

* Upgraded Nautobot from 1.5.17 to 1.5.20
* Upgraded Bitnami common subchart from 2.2.4 to 2.4.0
* Upgraded Mariadb subchart from 11.5.7 to 12.2.4
* Upgraded PostgreSQL subchart from 12.2.8 to 12.5.6
* Upgraded PostgreSQL-HA subchart from 11.2.1 to 11.7.4
* Upgraded RabbitMQ subchart from 11.13.0 to 11.16.1
* Upgraded Redis subchart from 17.9.5 to 17.11.3
* Upgraded Nginx Unprivileged optional container from 1.24 to 1.25

### Fixed

* Fixed [#249](https://github.com/nautobot/helm-charts/issues/249) helm template command failing (@BlackDark)
* Fixed [#261](https://github.com/nautobot/helm-charts/issues/261) Init Job is missing init containers
* Fixed [#213](https://github.com/nautobot/helm-charts/issues/213) Docs Update: Add How to Update Passwords
* Fixed [#260](https://github.com/nautobot/helm-charts/issues/260) ServiceAccount not used in default config
* Fixed [#256](https://github.com/nautobot/helm-charts/issues/256) v2.0.0 does not allow KV nodeSelector

## 2.0.0 - 2023-04-18

### Added

* Added the ability to create additional endpoints for scaling out, for example `/api` requests can now have their own deployments see `Values.nautobots` and the [Additional Nautobots](../../advanced-features/additional-nautobots/) page.
* Added the ability to deploy additional celery workers to listen on [additional queues](https://docs.nautobot.com/projects/core/en/stable/administration/celery-queues/) see `Values.workers` and the [Celery Queues](../../advanced-features/celery-queues/) page
* Added optional [RabbitMQ support](../../advanced-features/rabbitmq/) for Celery Task Queueing
* Added the ability to create an nginx deployment exclusively for `/static` files.  See the [documentation here](../../advanced-features/static-only/).
* Added the ability to run a single Job for Nautobot post_install tasks in certain scenarios.  See the [documentation here](../../advanced-features/init-hook/).
* Added support for Nginx (`nautobot.nginx.enabled`) as a proxy to Nautobot (deployed as a sidecar)
* Added support for Nginx exporters (`metrics.nginxExporter.enabled`)
* Added support for UWSGI exporters (`metrics.uwsgiExporter.enabled`)
* [191](https://github.com/nautobot/helm-charts/issues/191) Added Observability for Celery Workers
* Added the ability to specify `automountServiceAccountToken` on the `ServiceAccount`

### Changed

* [Docs on the official Nautobot Docs site](https://docs.nautobot.com/projects/helm-charts/en/stable/)!
* Default database engine now accounts for `METRICS_ENABLED`
* Moved Nautobot post-upgrade task to a separate init container
* Nautobot Version 1.5.17
* Upgraded Bitnami common subchart from 1.14.1 to 2.2.4
* Upgraded Mariadb subchart from 10.5.1 to 11.5.6
* Upgraded PostgreSQL subchart from 10.16.2 to 12.2.8
* Upgraded PostgreSQL-HA subchart from 8.6.13 to 11.2.1
* Upgraded Redis subchart from 16.10.1 to 17.9.3
* Updated JSON Schema to utilize external schemas where appropriate

### Deprecated

* The `Values.celeryWorker` has been deprecated and moved to `Values.workers.default`
* The `Values.celeryBeat` has been deprecated and moved to `Values.workers.beat`
