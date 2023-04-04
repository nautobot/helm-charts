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
