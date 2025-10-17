# External Database

To utilize an external database the following values are available for configuration:

```yaml
nautobot:
  db:
    engine: "django.db.backends.postgresql"
    host: "db.example.com"
    name: "nautobot_db_name"
    password: "nautobot_db_user_password"
    port: 5432
    timeout: 300
    user: "nautobot_db_username"
postgresql:
  enabled: false
```

If you do not want to set the password in values, you can rather use an existing secret. The following
is the example of the configuration. Please note that both, username and password are taken from the
existing secret, that is why both are required in the secret, otherwise the deployment will fail.

```yaml
nautobot:
  db:
    existingSecret: "credentials"
    existingSecretUsernameKey: "dbusername"
    existingSecretPasswordKey: "dbpassword"
postgresql:
  enabled: false
```
