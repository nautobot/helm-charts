# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Changed
<!--- Renovate --->
- Upgraded Mariadb subchart from 10.3.0 to 10.3.1
- Upgraded PostgreSQL subchart from 10.15.1 to 10.16.1
- Upgraded PostgreSQL-HA subchart from 8.2.1 to 8.2.4
- Upgraded Redis subchart from 15.7.1 to 16.0.0

## 1.1.4 - 2022-01-13
### Security
- [CVE-2022-22815](https://github.com/advisories/GHSA-xrcv-f9gm-v42c)
- [CVE-2022-22816](https://github.com/advisories/GHSA-xrcv-f9gm-v42c)
- [CVE-2022-22817](https://github.com/advisories/GHSA-8vj2-vxx3-667w)
  - Update Nautobot version to 1.2.4
  - Update Python version to 3.9

## 1.1.3 - 2022-01-07
### Security
- [CVE-2021-23727](https://github.com/advisories/GHSA-q4xr-rc97-m4xx) see [Nautobot #1238](https://github.com/nautobot/nautobot/issues/1238) for additional details
  - Update Nautobot version to 1.2.3
  - Update Python version to 3.7

### Changed
- Upgraded Mariadb subchart from 10.2.0 to 10.3.0
- Upgraded PostgreSQL subchart from 10.14.0 to 10.15.1
- Upgraded PostgreSQL-HA subchart from 8.1.3 to 8.2.1
- Upgraded Redis subchart from 15.6.10 to 15.7.1

## 1.1.2 - 2021-12-30
### Fixed
- [105](https://github.com/nautobot/helm-charts/issues/105) - Tests fail with `runAsNonRoot: true`

## 1.1.1 - 2021-12-29
- Update pre-commit hook pre-commit/pre-commit-hooks to v4.1.0
- Update Nautobot version to 1.2.2
- Upgraded Mariadb subchart from 10.1.1 to 10.2.0
- Upgraded PostgreSQL subchart from 10.13.14 to 10.14.0
- Upgraded PostgreSQL-HA subchart from 8.1.2 to 8.1.3
- Upgraded Redis subchart from 15.6.7 to 15.6.10

## 1.1.0 - 2021-12-20
### Added
- Security scanning provided by Snyk and Kubescan to CI process
- Security remediations for most findings from security scanners, notably:

```yaml
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - "ALL"
```

was added to nearly all containers.
- PostgreSQL High Availability support
- Redis Sentinel Support
- MySQL Support
- Support for scheduled jobs with Nautobot 1.2

### Changed
- Updated to Nautobot 1.2.1
- Improved Redis TLS documentation
- Upgraded sub-chart dependencies

## 1.0.4 - 2021-12-10
### Changed
- Update ghcr.io/nautobot/nautobot Docker tag to v1.1.6

## 1.0.3 - 2021-11-24
### Changed
- Update ghcr.io/nautobot/nautobot Docker tag to v1.1.5
### Added
- [#16](https://github.com/nautobot/helm-charts/issues/16) - Added backup and restore procedures.
- [#46](https://github.com/nautobot/helm-charts/issues/46) - Added documentation to enable PostgreSQL and Redis TLS.
- [#56](https://github.com/nautobot/helm-charts/issues/56) - Added Artifact Hub images annotation for image scanning on Artifact Hub.
- [#58](https://github.com/nautobot/helm-charts/issues/58) - Added annotations to the ServiceAccount.

## 1.0.2 - 2021-11-03
### Fixed
- [#50](https://github.com/nautobot/helm-charts/issues/50) - Integrated Redis chart sets `NAUTOBOT_REDIS_SSL=false` ignoring the `nautobot.redis.ssl` value.

## 1.0.1 - 2021-10-28
### Fixed
- [#43](https://github.com/nautobot/helm-charts/issues/43) - Nautobot resources/limits reversed in default values.yaml.

## 1.0.0 - 2021-10-27
### Added
- Initial Release
