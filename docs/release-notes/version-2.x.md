# Nautobot Helm Chart Version 2.x

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.5.6 - 2025-09-08

### Fixed

* [#597](https://github.com/nautobot/helm-charts/pull/597) Fix ingress by removing bitnami unsupported helpers

### Changed

* Upgraded Nautobot from 2.4.14 to 2.4.17
* Upgraded minor version of bitnamilegacy docker images

## 2.5.5 - 2025-08-06

### Fixed

* [#584](https://github.com/nautobot/helm-charts/pull/584) Fix nginx config to support https2 using proper syntax

### Changed

* Upgraded Nautobot from 2.4.11 to 2.4.14
* Upgraded Bitnami common subchart from 2.30.2 to 2.31.3
* [#588](https://github.com/nautobot/helm-charts/pull/588) Change to use bitnamilegacy docker images

## 2.5.4 - 2025-07-11

### Fixed

* [#569](https://github.com/nautobot/helm-charts/pull/569) Fix nginx liveness probes' wrong port configuration
* [#574](https://github.com/nautobot/helm-charts/pull/574) Fix creation of redis secret when password is provided and chart redis is not used

### Changed

* Upgraded Nautobot from 2.4.8 to 2.4.11
* Upgraded Nginx Unprivileged optional container from 1.28 to 1.29
* Upgraded Bitnami common subchart from 2.30.0 to 2.30.2

## 2.5.3 - 2025-05-16

### Changed

* Upgraded Nautobot from 2.4.6 to 2.4.8
* Upgraded Upgraded nginx-prometheus-exporter image from 1.4.1 to 1.4.2
* Upgraded Nginx Unprivileged optional container from 1.27 to 1.28

## 2.5.2 - 2025-04-17

### Added

* [#524](https://github.com/nautobot/helm-charts/pull/524) Add container security context to the nautobot-cert container
* [#550](https://github.com/nautobot/helm-charts/pull/550) Add Horizontal Pod Autoscaler (HPA) support for celery workers

### Changed

* [#551](https://github.com/nautobot/helm-charts/pull/551) Increased default timeout seconds for probes by 5 seconds

## 2.5.1 - 2025-04-04

### Changed

* Upgraded Nautobot from 2.4.5 to 2.4.6

### Fixed

* [#536](https://github.com/nautobot/helm-charts/pull/536) Fix Helm chart dependency checks in CI
* [#546](https://github.com/nautobot/helm-charts/pull/546) Fix documentation for Redis sentinel usage

## 2.5.0 - 2025-03-21

### Added

* [#516](https://github.com/nautobot/helm-charts/pull/516) Add functionality for Network Policies
* [#520](https://github.com/nautobot/helm-charts/pull/520) Add support to use uWSGi without https

### Changed

* Upgraded Nautobot from 2.4.4 to 2.4.5

### Fixed

* [#528](https://github.com/nautobot/helm-charts/pull/528) Fix usage of uwsgi enabling http and socket when Nginx enabled

## 2.4.6 - 2025-03-07

### Changed

* Upgraded Nautobot from 2.4.3 to 2.4.4

## 2.4.5 - 2025-02-21

### Added

* [#508](https://github.com/nautobot/helm-charts/pull/508) Add documentation for Nginx sidecar advanced feature

### Changed

* Upgraded Nautobot from 2.4.2 to 2.4.3
* Upgraded Bitnami common subchart from 2.29.1 to 2.30.0

## 2.4.4 - 2025-02-07

### Changed

* Upgraded Nautobot from 2.3.16 to 2.4.2
* Upgraded Upgraded nginx-prometheus-exporter image from 1.4.0 to 1.4.1
* Upgraded Bitnami common subchart from 2.29.0 to 2.29.1

## 2.4.3 - 2025-01-10

### Changed

* Upgraded Nautobot from 2.3.13 to 2.3.16
* Upgraded Bitnami common subchart from 2.28.0 to 2.29.0

## 2.4.2 - 2024-12-13

### Added

* [#480](https://github.com/nautobot/helm-charts/pull/480) Add functionality for auto-deployments in configuration changes

### Changed

* Upgraded Nautobot from 2.3.12 to 2.3.13
* Upgraded nginx-prometheus-exporter image from 1.3.0 to 1.4.0
* Upgraded Bitnami common subchart from 2.27.2 to 2.28.0

## 2.4.1 - 2024-11-29

### Changed

* Upgraded Nautobot from 2.3.11 to 2.3.12
* Upgraded Bitnami common subchart from 2.27.0 to 2.27.2

## 2.4.0 - 2024-11-15

### Added

* [#471](https://github.com/nautobot/helm-charts/pull/471) Add property to deploy extra k8s objects(manifests).

### Fixed

* [#463](https://github.com/nautobot/helm-charts/pull/463) Fix allow multiple probe types and not only the pre-configured.

### Changed

* Upgraded Nautobot from 2.3.7 to 2.3.11
* Upgraded Bitnami common subchart from 2.26.0 to 2.27.0

## 2.3.4 - 2024-10-18

### Changed

* Upgraded Nautobot from 2.3.6 to 2.3.7
* Upgraded Bitnami common subchart from 2.24.0 to 2.26.0

## 2.3.3 - 2024-10-04

### Added

* [#450](https://github.com/nautobot/helm-charts/pull/450) Added startupProbes for Nautobot deployment.

### Changed

* Upgraded Nautobot from 2.3.4 to 2.3.6
* Upgraded Bitnami common subchart from 2.23.0 to 2.24.0

## 2.3.2 - 2024-09-24

### Fixed

* [#445](https://github.com/nautobot/helm-charts/issues/445) Fix Media files directory being overwritten by volumeMount.

## 2.3.1 - 2024-09-20

### Added

* [#444](https://github.com/nautobot/helm-charts/pull/444) Added additional properties in the root of values json schema

### Changed

* Upgraded Nautobot from 2.3.2 to 2.3.4
* Upgraded Bitnami common subchart from 2.22.0 to 2.23.0

### Fixed

* [#439](https://github.com/nautobot/helm-charts/pull/439) Fix documentation for persistent static and media files.

## 2.3.0 - 2024-09-06

### Added

* [#423](https://github.com/nautobot/helm-charts/pull/432) Added annotations to the Nautobot deployment.

### Changed

* [#434](https://github.com/nautobot/helm-charts/pull/434) Enabled celery readiness and liveliness probes by default.
* Upgraded Nautobot from 2.3.1 to 2.3.2
* Upgraded dependency mkdocs from 1.6.0 to 1.6.1

## 2.2.0 - 2024-08-23

### Fixed

* [#421](https://github.com/nautobot/helm-charts/pull/421) Fix unnecessary prometheus metrics endpoint.

### Changed

* Upgraded Nautobot from 2.2.7 to 2.3.1
* Upgraded Bitnami Common subchart from 2.20.3 to 2.22.0
* Upgraded nginx-prometheus-exporter image from 1.2.0 to 1.3.0

## 2.1.3 - 2024-07-12

### Fixed

* [#412](https://github.com/nautobot/helm-charts/pull/412) Fix unnecessary lifecycleHooks for Init Containers.
* [#345](https://github.com/nautobot/helm-charts/pull/345) Fix Service's target port when Nginx in enabled.

### Changed

* Upgraded Nautobot from 2.2.5 to 2.2.7
* Upgraded Bitnami Common subchart from 2.19.2 to 2.20.3
* Upgraded nginx-prometheus-exporter image from 1.1.0 to 1.2.0
* Upgraded dependency mkdocs-material from 9.5.22 to 9.5.28
* Upgraded Nginx Unprivileged optional container from 1.26 to 1.27

## 2.1.2 - 2024-05-31

### Added

* [#391](https://github.com/nautobot/helm-charts/pull/391) Add persistent volume option for media files

### Fixed

* [#398](https://github.com/nautobot/helm-charts/pull/398) Docs Update: Persistent volumes for static & media files

### Changed

* Upgraded Nautobot from 2.2.2 to 2.2.5
* Upgraded nginx-prometheus-exporter image from 0.11.0 to 1.1.0
* Upgraded Bitnami Common subchart from 2.19.1 to 2.19.2
* Upgraded dependency mkdocs-material from 9.5.18 to 9.5.22

## 2.1.1 - 2024-04-25

### Added

* [#379](https://github.com/nautobot/helm-charts/pull/379) Add option to define harakiri uwsgi timeout

### Fixed

* [#381](https://github.com/nautobot/helm-charts/pull/381) Fix DB and Redis secrets
* [#374](https://github.com/nautobot/helm-charts/pull/374) Fix correct secret keys for Django passwords

### Changed

* Upgraded Nautobot from 2.1.9 to 2.2.2
* Upgraded Bitnami Common subchart from 2.13.3 to 2.19.1
* Upgraded RabbitMQ subchart from 12.5.4 to 12.15.0
* Upgraded Redis subchart from 18.4.0 to 18.19.4

## 2.1.0 - 2024-03-27

### Added

* [#354](https://github.com/nautobot/helm-charts/pull/354) Add persistent volume option for static files
* [#356](https://github.com/nautobot/helm-charts/pull/356) Allow providing passwords via K8s secret references
* [#369](https://github.com/nautobot/helm-charts/pull/369) Additional updates for referencing existing K8s secrets

### Fixed

* [#372](https://github.com/nautobot/helm-charts/pull/372) Fix invalid liveness probes in the Nautobot patch released (v1.6.16+ and v2.1.9+)

## 2.0.5 - 2023-11-29

+/- 2.0.5
    This release of the helm-chart includes an upgrade to Nautobot 2.x.  While this is a non-breaking change for the helm chart this is a significant change to Nautobot and care should be taken during the upgrade, please see the [Nautobot 2.0 Release Notes](https://docs.nautobot.com/projects/core/en/stable/release-notes/version-2.0/) and [upgrading from 1.x instructions](https://docs.nautobot.com/projects/core/en/stable/user-guide/administration/upgrading/from-v1/upgrading-from-nautobot-v1/).

### Fixed

* [#338](https://github.com/nautobot/helm-charts/issues/338) Allow Nautobot to Scale to 0
* [#335](https://github.com/nautobot/helm-charts/issues/335) Use Nautobot 2.0 by default

### Changed

* Upgraded Bitnami Common subchart from 2.11.1 to 2.13.3
* Upgraded PostgreSQL subchart from 12.12.4 to 12.12.10
* Upgraded PostgreSQL-HA subchart from 11.9.4 to 11.9.8
* Upgraded RabbitMQ subchart from 12.1.5 to 12.5.4
* Upgraded Redis subchart from 18.0.4 to 18.4.0

## 2.0.4 - 2023-09-21

### Fixed

* [#306](https://github.com/nautobot/helm-charts/issues/306) Bug: configured prometheus backend not possible
* [#316](https://github.com/nautobot/helm-charts/issues/316) Concurrency int breaks deployment
* [#255](https://github.com/nautobot/helm-charts/issues/255) Switch dependencies to OCI

### Changed

* Upgraded Nautobot from 1.5.23 to 1.6.2
* Upgraded Mariadb subchart from 12.2.5 to 13.1.3
* Upgraded PostgreSQL subchart from 12.5.7 to 12.12.4
* Upgraded PostgreSQL-HA subchart from 11.7.5 to 11.9.4
* Upgraded RabbitMQ subchart from 12.0.1 to 12.1.5
* Upgraded Redis subchart from 17.11.5 to 18.0.4

## 2.0.3 - 2023-06-16

### Fixed

* [#288](https://github.com/nautobot/helm-charts/issues/288) README Typo
* [#286](https://github.com/nautobot/helm-charts/issues/286) Bug: variable celery.concurrency not used

### Changed

* [#293](https://github.com/nautobot/helm-charts/issues/293) Allow Increasing uwsgi buffer size
* Upgraded Nautobot from 1.5.20 to 1.5.21
* Upgraded Mariadb subchart from 12.2.4 to 12.2.5
* Upgraded PostgreSQL subchart from 12.5.6 to 12.5.7
* Upgraded PostgreSQL-HA subchart from 11.7.4 to 11.7.5
* Upgraded RabbitMQ subchart from 11.16.1 to 12.0.1
* Upgraded Redis subchart from 17.11.3 to 17.11.5

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
