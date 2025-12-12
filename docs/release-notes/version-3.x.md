# Nautobot Helm Chart Version 3.x

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.0

* The `postgresql` and `redis` subcharts are no longer deployed by default. They must be explicitly enabled if used.
* The `rabbitmq` subchart was removed.
* The `mariadb` subchart was removed.
* The `postgresqlha` subchart was removed.
* The username field is now required in the existing secret if `nautobot.db.existingSecret` is used.
* The default image was changed to 3.x.
* Changed the default Docker registry.
* The Nautobot Celery readiness and liveness probes were changed to use files instead of celery pings.
* Changed Nautobot Celery defaults.
* Ability to point to an existing `ConfigMap` for Nautobot config.
