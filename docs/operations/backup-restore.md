## Backup and Restore Procedures

## Backup Nautobot

The recommended method of backing up Nautobot is simply to get a database dump from PostgreSQL:

```no-highlight
export NAMESPACE=nautobot  # Be sure to use the correct namespace here
export POSTGRES_SECRET_NAME=nautobot-postgresql  # If you have changed the default make sure you change it here
export POSTGRES_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $POSTGRES_SECRET_NAME -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo $POSTGRES_PASSWORD | kubectl exec -itn $NAMESPACE statefulset.apps/nautobot-postgresql -- pg_dump --username nautobot --clean --if-exists nautobot > backup.sql
```

NOTE: The name of the secret is dependent on the helm release name and may be different in your environment.

Make sure to save your `NAUTOBOT_SECRET_KEY` in a safe place as well:

```no-highlight
kubectl get secret nautobot-env -o jsonpath="{.data.NAUTOBOT_SECRET_KEY}" | base64 --decode
```

These commands specific to your deployment can be found by inspecting the notes provided after the install:

```no-highlight
helm status nautobot
```

In addition please make sure to note ALL values used to deploy this helm chart:

```no-highlight
helm get values -o yaml nautobot > nautobot.values.yaml
```

As with any backup procedure, these steps should be validated in your environment before relying on them in production.

## Restore Nautobot from Backup

This procedure assumes the [Backup Nautobot](#backup-nautobot) procedure was followed from above.

Install Nautobot using the previous helm values:

```no-highlight
helm install nautobot nautobot/nautobot -f nautobot.values.yaml
```

Upload the backup and restore:

```no-highlight
kubectl cp backup.sql nautobot-postgresql-0:/tmp
export POSTGRES_PASSWORD=$(kubectl get secret --namespace nautobot nautobot-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo $POSTGRES_PASSWORD | kubectl exec -itn default statefulset.apps/nautobot-postgresql -- psql -U nautobot -f /tmp/backup.sql
```
