# Using Kubernetes Jobs in Nautobot

If you want to run your Nautobot jobs via Kubernetes Jobs instead of using the Nautobot Celery workers, here are the steps to configure your Nautobot deployment.

## (Optional) Disable the Default Celery Worker

If you want to disable the default Celery worker, you can set the `workers.default.enabled` value to `false`.

```yaml
workers:
  default:
    enabled: false
```

!!! note
    Scheduled jobs will still require the Celery Beat worker (`workers.beat`) at this time.

## Add the ServiceAccount Configuration

Here is the recommended configuration for the ServiceAccount that is needed to run Kubernetes Jobs:

```yaml
serviceAccount:
  automountServiceAccountToken: true
  roles:
    jobCreator:
      create: true
```

For more information and customization options for the ServiceAccount roles, see [RBAC Roles and RoleBindings](rbac-roles.md).
