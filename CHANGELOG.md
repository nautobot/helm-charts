# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Changed
<!--- Renovate --->
- {{{prTitle}}}

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
