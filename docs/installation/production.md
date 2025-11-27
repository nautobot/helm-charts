# Recommended Production Values

These are some pointers to running Nautobot in a production environment:

* Use Highly Available PostgreSQL, while this chart does [provide the ability to do this](../../advanced-features/postgresql-ha/) it is *strongly* recommended to take advantage of a cloud provider's offering where possible.
* Use Highly Available Redis, today the supported method is to use [Redis Sentinel](../../advanced-features/redis-sentinel/), however cloud providers don't currently provide a Sentinel offering.
* If you are deploying either PostgreSQL HA or Redis Sentinel, it is recommended to deploy those charts separately simply to avoid dependency confusion and management in the future.
* Use [existing secrets](../../advanced-features/existing-secrets/) rather than deploying them with helm.

When deploying this chart in production, it is recommended to set or at least be aware of the following values:

```yaml
nautobot:
  replicaCount: 2  # In production this should be >= 2
  metrics: true
  secretKey: ""  # In a production system this value should be recorded and used when restoring the DB if necessary
  superUser:
    enabled: false  # In production a superuser should be created manually
  extraVars:
    - name: "NAUTOBOT_BANNER_TOP"
      value: "Production"
  db:
    host: "database.example.com"
    existingSecret: "nautobot-database-credentials"  # must contain username and password
  redis:
    host: "redis.example.com"
    existingSecret: "redis-credentials"
workers:
  default:
    replicaCount: 2  # In production this should be >= 2
```

[PostgreSQL HA](../../advanced-features/postgresql-ha/) and [Redis Sentinel](../../advanced-features/redis-sentinel/) should be considered when deploying in production, however, support for these services within this helm chart are in early alpha/beta stages, use cautiously.
