# RBAC Roles and RoleBindings

The Nautobot Helm Chart provides a convenient way to configure the required RBAC Roles and RoleBindings for the Nautobot ServiceAccount that are needed to run Kubernetes Jobs.

## Configuration

The RBAC configuration is managed under `serviceAccount.roles` in your values file. Two pre-configured roles are available.

### Simple Example

To enable both roles with the default values:

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
    podReader:
      create: true
```

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

You may customize the role name, namespace, and verbs if needed.

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
      name: "custom-job-role"
      namespace: "different-namespace"
      verbs: ["create", "get", "list", "watch"]
```

### Pod Reader Role

The `podReader` role grants permissions to read Pod information. This is useful for automatically determining the current Nautobot image to use for Kubernetes job pods.

```yaml
serviceAccount:
  roles:
    podReader:
      create: true
```

By default, this creates a Role and RoleBinding with the following default values:

- **Role Name**: `nautobot-pod-reader-{{ .Release.Namespace }}`
- **Namespace**: `{{ .Release.Namespace }}`
- **API Group**: `""` (core API group)
- **Resources**: `pods`
- **Verbs**: `get`, `list`, `watch`

You may customize the role name, namespace, and verbs if needed.

```yaml
serviceAccount:
  roles:
    podReader:
      create: true
      name: "custom-pod-reader-role"
      namespace: "different-namespace"
      verbs: ["get", "list", "watch"]
```
