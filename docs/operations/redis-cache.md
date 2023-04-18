# Invalidate Redis Cache

Running `nautobot-server invalidate all` will invalidate the Redis for Nautobot.  If Redis is deployed as part of this chart you will run into an error:

```no-highlight
redis.exceptions.ResponseError: unknown command `FLUSHDB`, with args beginning with:
```

This is because by default the `FLUSHDB` command is disabled in the Bitnami Redis chart.  To enable this use the following values:

```yaml
redis:
  master:
    disableCommands: []
  replica:
    disableCommands: []
```
