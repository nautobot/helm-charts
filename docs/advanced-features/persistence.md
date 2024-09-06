# Persistence for Static and Media files

The recommended way to store static and media files is to use an external shared storage such as [using S3 for Django storage](https://docs.nautobot.com/projects/core/en/stable/user-guide/administration/guides/s3-django-storage/).

That said, it is also possible to leverage Kubernetes Persistent Volumes, following the below setting a Persistent Volume Claim is created and mounted it at the `/opt/nautobot/static` path of the Pods.

```yaml
nautobot:
  persistenceStaticFiles:
    enabled: true
    storageClassName: "your-storage-class"
    accessMode: "ReadWriteMany"
    size: "1Gi"
```

There is also a setting for Media files mounted at `/opt/nautobot/media` of Nautobot's Pods, similar to the static one, as shown below.

```yaml
nautobot:
  persistenceMediaFiles:
    enabled: true
    storageClassName: "your-storage-class"
    accessMode: "ReadWriteMany"
    size: "1Gi"
```

Unfortunately, if the underlying storage solution does not support the `ReadWriteMany` option, you have to use node affinity in order for the Pods of the deployment to be scheduled on the same node as the Persistent Volumes. Below there is an example using Node labels as selector to create the PVC for static files and schedule the Pods in the same node.

```yaml
nautobot:
  persistenceStaticFiles:
    enabled: true
    storageClassName: "your-storage-class"
    size: "1Gi"
    selector:
      matchLabel:
        nautobot-storage: static

  # Selector for the Pods of the deployment.
  nodeSelector:
    nautobot-storage: static
```
