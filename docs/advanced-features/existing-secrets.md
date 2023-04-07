# Existing Secrets

If you don't want to pass values through helm for either Redis or PostgreSQL there are a few options.  If you want to deploy PostgreSQL and Redis with this chart:

1. Create a secret with both PostgreSQL and Redis passwords:

    ```no-highlight
    kubectl create secret generic my-secret --from-literal=postgresql-password=change-me --from-literal=NAUTOBOT_REDIS_PASSWORD=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    postgresql:
      existingSecret: "my-secret"
    redis:
      auth:
        existingSecret: "my-secret"
        existingSecretPasswordKey: "NAUTOBOT_REDIS_PASSWORD"
    ```

If you are using external PostgreSQL and Redis servers you can use the following values:

```yaml
nautobot:
  db:
    existingSecret: "my-secret"
    existingSecretPasswordKey: "postgresql-password"
  redis:
    existingSecret: "my-secret"
postgresql:
  enabled: false
redis:
  enabled: false
```

You can use various combinations of `existingSecret` and `existingSecretPasswordKey` options depending on the existing secrets you have deployed.  (NOTE: The Bitnami PostgreSQL chart does require the key name to be "postgresql-password")