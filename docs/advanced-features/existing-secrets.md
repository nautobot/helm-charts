# Existing Secrets

If you don't want to pass values through helm for...

- Redis
- PostgreSQL
- MariaDB
- Nautobot Secret Key
- Superuser password and API token

...there's the option of creating these secrets manually and referencing them in the configuration.

For example, if you want to deploy PostgreSQL and Redis with this chart:

1. Create a secret with both PostgreSQL and Redis passwords:

    ```no-highlight
    kubectl create secret generic my-secret --from-literal=NAUTOBOT_DB_PASSWORD=change-me --from-literal=password=change-me --from-literal=NAUTOBOT_REDIS_PASSWORD=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    postgresql:
      auth:
        existingSecret: "my-secret"
        secretKeys:
          adminPasswordKey: "NAUTOBOT_DB_PASSWORD"
          userPasswordKey: "password"
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
    existingSecretPasswordKey: "NAUTOBOT_DB_PASSWORD"
  redis:
    existingSecret: "my-secret"
    existingSecretPasswordKey: "NAUTOBOT_REDIS_PASSWORD"
postgresql:
  enabled: false
redis:
  enabled: false
```

To reference an existing NAUTOBOT_SECRET_KEY you can use the following values:

```yaml
nautobot:
  django:
    existingSecret: "my-secret"
    existingSecretSecretKeyKey: "NAUTOBOT_SECRET_KEY"
```

And/or for the superuser credentials you can use this configuration:

```yaml
nautobot:
  superUser:
    existingSecret: "my-secret"
    existingSecretPasswordKey: "NAUTOBOT_SUPERUSER_PASSWORD"
    existingSecretApiTokenKey: "NAUTOBOT_SUPERUSER_API_TOKEN"
```

You can use various combinations of `existingSecret` and `*Key` options depending on the existing secrets you have deployed.
