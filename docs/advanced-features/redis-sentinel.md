# Redis Sentinel

Redis Sentinel provides a highly available Redis implementation.  To enable Sentinel with the [Bitnami Redis subchart](https://github.com/bitnami/charts/tree/master/bitnami/redis) set the following helm values:

```yaml
redis:
  architecture: "replication"
  sentinel:
    enabled: true
    masterSet: nautobot
```

Nautobot requires some additional configuration via a [custom `nautobot_config.py`](#custom-nautobot_configpy) with the following values set in `nautobot_config.py`:

```python
DJANGO_REDIS_CONNECTION_FACTORY = "django_redis.pool.SentinelConnectionFactory"
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://nautobot/0",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.SentinelClient",
            "SENTINELS": [(os.getenv("NAUTOBOT_REDIS_HOST"), 26379)],
            "PASSWORD": os.getenv("NAUTOBOT_REDIS_PASSWORD"),
            "SENTINEL_KWARGS": {"password": os.getenv("NAUTOBOT_REDIS_PASSWORD")},
            "CONNECTION_POOL_CLASS": "redis.sentinel.SentinelConnectionPool",
        },
    },
}

CACHEOPS_REDIS = False
CACHEOPS_SENTINEL = {
    "locations": [(os.getenv("NAUTOBOT_REDIS_HOST"), 26379)],
    "service_name": "nautobot",
    "socket_timeout": 10,
    "db": 1,
    "sentinel_kwargs": {"password": os.getenv("NAUTOBOT_REDIS_PASSWORD")},
    "password": os.getenv("NAUTOBOT_REDIS_PASSWORD"),
}
CELERY_BROKER_URL = (
    f"sentinel://:{os.getenv('NAUTOBOT_REDIS_PASSWORD')}@{os.getenv('NAUTOBOT_REDIS_HOST')}:26379"
)
CELERY_BROKER_TRANSPORT_OPTIONS = {
    "master_name": "nautobot",
    "sentinel_kwargs": {"password": os.getenv("NAUTOBOT_REDIS_PASSWORD")},
}
CELERY_RESULT_BACKEND = CELERY_BROKER_URL
CELERY_RESULT_BACKEND_TRANSPORT_OPTIONS = CELERY_BROKER_TRANSPORT_OPTIONS
```

See the [Nautobot caching documentation](https://nautobot.readthedocs.io/en/stable/additional-features/caching/#using-redis-sentinel) for more information on configuring Nautobot with Sentinel.

This helm chart's support for Redis Sentinel is still in an early alpha/beta phase you should use this feature cautiously.
