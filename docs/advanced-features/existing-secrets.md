# Existing Secrets

If you don't want to pass values through helm for...

- Redis
- PostgreSQL
- Nautobot Secret Key
- Superuser password and API token
- TLS certificates

...there's the option of creating these secrets manually and referencing them in the configuration.

## Managed PostgreSQL and Redis deployments

For example, if you want to deploy PostgreSQL and Redis with this chart:

1. Create a secret with both PostgreSQL and Redis passwords:

    ```no-highlight
    kubectl create secret generic my-secret \
      --from-literal=NAUTOBOT_DB_PASSWORD=change-me \
      --from-literal=password=change-me \
      --from-literal=NAUTOBOT_REDIS_PASSWORD=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    postgresql:
      auth:
        username: "nautobotuser"
        existingSecret: "my-secret"
        secretKeys:
          adminPasswordKey: "NAUTOBOT_DB_PASSWORD"
          userPasswordKey: "password"
    redis:
      auth:
        existingSecret: "my-secret"
        existingSecretPasswordKey: "NAUTOBOT_REDIS_PASSWORD"
    ```

## External PostgreSQL and Redis deployments

If you are using external PostgreSQL and Redis servers you can use the following values:

1. Create a secret with PostgreSQL and Redis credentials:

    ```no-highlight
    kubectl create secret generic credentials \
      --from-literal=dbusername=nautobotuser \
      --from-literal=dbpassword=change-me \
      --from-literal=redispassword=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    nautobot:
      db:
        existingSecret: "credentials"
        existingSecretUsernameKey: "dbusername"
        existingSecretPasswordKey: "dbpassword"
      redis:
        existingSecret: "credentials"
        existingSecretPasswordKey: "redispassword"
    postgresql:
      enabled: false
    redis:
      enabled: false
    ```

## Existing secret key

To reference an existing NAUTOBOT_SECRET_KEY you can use the following values:

1. Create a secret with the secret key:

    ```no-highlight
    kubectl create secret generic existing-secretkey \
      --from-literal=secretkey=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    nautobot:
      django:
        existingSecret: "existing-secretkey"
        existingSecretSecretKeyKey: "secretkey"
    ```

## Existing Superuser Credentials

And/or for the superuser credentials you can use this configuration:

1. Create a secret with the super user credentials:

    ```no-highlight
    kubectl create secret generic superuser \
      --from-literal=password=change-me \
      --from-literal=apitoken=change-me
    ```

2. Use the following values to install the helm chart:

    ```yaml
    nautobot:
      superUser:
        existingSecret: "superuser"
        existingSecretPasswordKey: "password"
        existingSecretApiTokenKey: "apitoken"
    ```

## Existing TLS certificates

And/or for serving Nautobot with custom TLS certificates you can use this configuration:

1. Create a secret of tls type with the TLS cert/key pair:

    ```no-highlight
    kubectl create secret tls internal-tls \
      --cert=my-custom-cert.crt \
      --key=my-custom-cert.key
    ```

2. Then use the name of the created secret in the below helm values to install the chart:

    ```yaml
    nautobot:
      secret_name_tls: "internal-tls"
    ```
