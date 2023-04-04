# External Redis

To utilize an external redis deployment the following values are available for configuration:

```yaml
nautobot:
  redis:
    host: "redis.example.com"
    password: "nautobot_redis_user_password"
    port: 6379
    ssl: true
    username: "nautobot_redis_username"
redis:
  enabled: false
```
