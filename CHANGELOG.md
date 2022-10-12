# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

* <!--- Renovate --->

## 1.3.13 - 2022-05-31

### Changed

* Nautobot Version 1.4.5
* Updated pre-commit hooks

### Fixed

* Fixed #181 with nested root values in json schema

## 1.3.12 - 2022-05-31

### Changed

* Nautobot Version 1.3.5
* Upgraded Nautobot from 1.3.4 to 1.3.5
* Upgraded Bitnami common subchart from 1.14.0 to 1.14.1
* Upgraded Redis subchart from 16.9.5 to 16.10.1

## 1.3.11 - 2022-05-17

### Changed

* Nautobot Version 1.3.4
* Upgraded Bitnami common subchart from 1.13.1 to 1.14.0
* Upgraded Redis subchart from 16.8.9 to 16.9.5

## 1.3.10 - 2022-05-04

### Changed

* Nautobot Version 1.3.3
* Upgraded Bitnami common subchart from 1.13.0 to 1.13.1
* Upgraded Redis subchart from 16.8.7 to 16.8.9

## 1.3.9 - 2022-04-25

### Changed

* Nautobot Version 1.3.2

## 1.3.8 - 2022-04-21

### Changed

* Nautobot Version 1.3.1
* Update Python version to 3.10
* Upgraded Mariadb subchart from 10.4.5 to 10.5.1
* Upgraded PostgreSQL-HA subchart from 8.6.9 to 8.6.13
* Upgraded Redis subchart from 16.8.2 to 16.8.7

## 1.3.7 - 2022-04-05

### Changed

* Nautobot Version 1.2.11
* Upgraded Bitnami common subchart from 1.12.0 to 1.13.0
* Upgraded Mariadb subchart from 10.4.1 to 10.4.5
* Upgraded PostgreSQL-HA subchart from 8.6.3 to 8.6.9
* Upgraded Redis subchart from 16.5.4 to 16.8.9

## 1.3.6 - 2022-03-22

### Changed

* Nautobot Version 1.2.10

## 1.3.5 - 2022-03-17

### Fixed

* Fixed Redis sentinel read-only root volumes are no longer supported.

### Changed

* Upgraded Bitnami common subchart from 1.11.3 to 1.12.0
* Upgraded Mariadb subchart from 10.3.7 to 10.4.1
* Upgraded PostgreSQL-HA subchart from 8.5.3 to 8.6.3
* Upgraded Redis subchart from 16.5.0 to 16.5.4

## 1.3.4 - 2022-03-14

### Changed

* Nautobot Version 1.2.9

## 1.3.3 - 2022-03-08

### Changed

* Nautobot Version 1.2.8
* Upgraded Bitnami common subchart from 1.11.1 to 1.11.3
* Upgraded Mariadb subchart from 10.3.6 to 10.3.7
* Upgraded PostgreSQL-HA subchart from 8.4.4 to 8.5.3
* Upgraded Redis subchart from 16.4.0 to 16.5.0

## 1.3.2 - 2022-02-25

### Fixed

* [148](https://github.com/nautobot/helm-charts/issues/148) - extraVolumeMounts being added as Volumes as well as VolumeMounts

## 1.3.1 - 2022-02-22

### Changed

* Update Nautobot version to 1.2.7
* Upgraded Mariadb subchart from 10.3.2 to 10.3.6
* Upgraded PostgreSQL-HA subchart from 8.3.1 to 8.4.4

## 1.3.0 - 2022-02-17

### Added

* [141](https://github.com/nautobot/helm-charts/issues/141) - Added extraPorts for the Nautobot service, useful for sidecars

## 1.2.4 - 2022-02-17

### Fixed

* [138](https://github.com/nautobot/helm-charts/issues/138) - Fixed the schema datatype for pod sidecars

## 1.2.3 - 2022-02-10

### Added

* [134](https://github.com/nautobot/helm-charts/issues/134) - Added support for the ingressClassName in the ingress component

### Changed

* Upgraded PostgreSQL-HA subchart from 8.2.8 to 8.3.1
* Upgraded Redis subchart from 16.3.0 to 16.4.0

## 1.2.2 - 2022-02-03

### Changed

* Update Nautobot version to 1.2.5

## 1.2.1 - 2022-02-02

### Changed

* ~~Update Nautobot version to 1.2.5~~
* Update pre-commit hook Lucas-C/pre-commit-hooks to v1.1.11
* Updated Kubescape scanning, fixing kubescape findings from Sentinel
* Added Markdownlint to pre-commit
* Upgraded Bitnami common subchart from 1.10.4 to 1.11.1
* Upgraded PostgreSQL-HA subchart from 8.2.6 to 8.2.8
* Upgraded Redis subchart from 16.2.0 to 16.3.0

### Fixed

* [123](https://github.com/nautobot/helm-charts/issues/123) - Redis headless service name fails in non-sentinel environments with RO replicas

## 1.2.0 - 2022-01-26

### Added

* PodDisruptionBudget capability for Nautobot and Nautobot Worker

### Changed

* Celery Beat container name now nautobot-celery-beat
* Upgraded Mariadb subchart from 10.3.1 to 10.3.2
* Upgraded PostgreSQL subchart from 10.16.1 to 10.16.2
* Upgraded Redis subchart from 16.0.1 to 16.2.0

## 1.1.5 - 2022-01-20

### Changed

* Upgraded Mariadb subchart from 10.3.0 to 10.3.1
* Upgraded PostgreSQL subchart from 10.15.1 to 10.16.1
* Upgraded PostgreSQL-HA subchart from 8.2.1 to 8.2.6
* Upgraded Redis subchart from 15.7.1 to 16.0.1
* Upgraded Bitnami common subchart from 1.10.3 to 1.10.4

## 1.1.4 - 2022-01-13

### Security

* [CVE-2022-22815](https://github.com/advisories/GHSA-xrcv-f9gm-v42c)
* [CVE-2022-22816](https://github.com/advisories/GHSA-xrcv-f9gm-v42c)
* [CVE-2022-22817](https://github.com/advisories/GHSA-8vj2-vxx3-667w)
    * Update Nautobot version to 1.2.4
    * Update Python version to 3.9

## 1.1.3 - 2022-01-07

### Security

* [CVE-2021-23727](https://github.com/advisories/GHSA-q4xr-rc97-m4xx) see [Nautobot #1238](https://github.com/nautobot/nautobot/issues/1238) for additional details
    * Update Nautobot version to 1.2.3
    * Update Python version to 3.7

### Changed

* Upgraded Mariadb subchart from 10.2.0 to 10.3.0
* Upgraded PostgreSQL subchart from 10.14.0 to 10.15.1
* Upgraded PostgreSQL-HA subchart from 8.1.3 to 8.2.1
* Upgraded Redis subchart from 15.6.10 to 15.7.1

## 1.1.2 - 2021-12-30

### Fixed

* [105](https://github.com/nautobot/helm-charts/issues/105) - Tests fail with `runAsNonRoot: true`

## 1.1.1 - 2021-12-29

* Update pre-commit hook pre-commit/pre-commit-hooks to v4.1.0
* Update Nautobot version to 1.2.2
* Upgraded Mariadb subchart from 10.1.1 to 10.2.0
* Upgraded PostgreSQL subchart from 10.13.14 to 10.14.0
* Upgraded PostgreSQL-HA subchart from 8.1.2 to 8.1.3
* Upgraded Redis subchart from 15.6.7 to 15.6.10

## 1.1.0 - 2021-12-20

### Added

* Security scanning provided by Snyk and Kubescan to CI process
* Security remediations for most findings from security scanners, notably:

```yaml
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - "ALL"
```

was added to nearly all containers.

* PostgreSQL High Availability support
* Redis Sentinel Support
* MySQL Support
* Support for scheduled jobs with Nautobot 1.2

### Changed

* Updated to Nautobot 1.2.1
* Improved Redis TLS documentation
* Upgraded sub-chart dependencies

## 1.0.4 - 2021-12-10

### Changed

* Update ghcr.io/nautobot/nautobot Docker tag to v1.1.6

## 1.0.3 - 2021-11-24

### Changed

* Update ghcr.io/nautobot/nautobot Docker tag to v1.1.5

### Added

* [#16](https://github.com/nautobot/helm-charts/issues/16) - Added backup and restore procedures.
* [#46](https://github.com/nautobot/helm-charts/issues/46) - Added documentation to enable PostgreSQL and Redis TLS.
* [#56](https://github.com/nautobot/helm-charts/issues/56) - Added Artifact Hub images annotation for image scanning on Artifact Hub.
* [#58](https://github.com/nautobot/helm-charts/issues/58) - Added annotations to the ServiceAccount.

## 1.0.2 - 2021-11-03

### Fixed

* [#50](https://github.com/nautobot/helm-charts/issues/50) - Integrated Redis chart sets `NAUTOBOT_REDIS_SSL=false` ignoring the `nautobot.redis.ssl` value.

## 1.0.1 - 2021-10-28

### Fixed

* [#43](https://github.com/nautobot/helm-charts/issues/43) - Nautobot resources/limits reversed in default values.yaml.

## 1.0.0 - 2021-10-27

### Added

* Initial Release
