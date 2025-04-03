# Redis Sentinel

Redis Sentinel provides a highly available Redis implementation.  To enable Sentinel with the [Bitnami Redis subchart](https://github.com/bitnami/charts/tree/master/bitnami/redis) set the following helm values:

```yaml
redis:
  architecture: "replication"
  sentinel:
    enabled: true
    masterSet: nautobot
```

The default Nautobot config is no longer sufficient when you enable Redis Sentinel.
That is why, Nautobot requires some additional configuration via
a [custom `nautobot_config.py`](../custom-nautobot-config/) with the following
values set in `nautobot_config.py`:

```python
DJANGO_REDIS_CONNECTION_FACTORY = "django_redis.pool.SentinelConnectionFactory"
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://nautobot/0",  # in this context 'nautobot' is the redis master/service name
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.SentinelClient",
            "CONNECTION_POOL_CLASS": "redis.sentinel.SentinelConnectionPool",
            "PASSWORD": os.getenv("NAUTOBOT_REDIS_PASSWORD"),
            "SENTINEL_KWARGS": {
                "password": os.getenv("NAUTOBOT_REDIS_PASSWORD")
            },
            "SENTINELS": [
                (os.getenv("NAUTOBOT_REDIS_SENTINEL_1"), 26379),
                (os.getenv("NAUTOBOT_REDIS_SENTINEL_2"), 26379),
                (os.getenv("NAUTOBOT_REDIS_SENTINEL_3"), 26379),
            ],
        },
    },
}

CELERY_BROKER_URL = (
    f"sentinel://:{os.getenv('NAUTOBOT_REDIS_PASSWORD')}@{os.getenv('NAUTOBOT_REDIS_SENTINEL_1')}:26379;"
    f"sentinel://:{os.getenv('NAUTOBOT_REDIS_PASSWORD')}@{os.getenv('NAUTOBOT_REDIS_SENTINEL_2')}:26379;"
    f"sentinel://:{os.getenv('NAUTOBOT_REDIS_PASSWORD')}@{os.getenv('NAUTOBOT_REDIS_SENTINEL_3')}:26379"
    f"/{os.getenv('NAUTOBOT_REDIS_CELERY_BROKER_DB_INDEX')}"
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
