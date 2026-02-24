# RBAC Roles and RoleBindings

The Nautobot Helm Chart provides a convenient way to configure the required RBAC Role and RoleBinding for the Nautobot ServiceAccount that are needed to create Kubernetes Jobs.

## Configuration

The RBAC configuration is managed under `serviceAccount.roles` in your values file.

### Job Creator Role

The `jobCreator` role grants permissions to create and manage Kubernetes Jobs in the `batch` API group.

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
```

By default, this creates a Role and RoleBinding with the following default values:

- **Role Name**: `nautobot-job-creator-{{ .Release.Namespace }}`
- **Namespace**: `{{ .Release.Namespace }}`
- **API Group**: `batch`
- **Resources**: `jobs`
- **Verbs**: `create`, `get`, `list`, `watch`

You may customize the role name if needed.

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
      name: "custom-job-role"
```
