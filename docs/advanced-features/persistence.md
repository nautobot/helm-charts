# Persistence for Static files

Besides using an external shared storage (e.g. S3) for storing static files, it is also possible to leverage Kubernetes peristence. The following configuration creates a Persistent Volume Claim called `nautobot-static` and mounts it at the `/opt/nautobot/static` path of the Pods.

```yaml
nautobot:
  persistence:
    enabled: true
    storageClass: "your-storage-class"
    accessMode: "ReadWriteMany"
    size: "2Gi"
```

Unfortunately, if the underlying storage solution does not support the `ReadWriteMany` option, you have to use node affinity in order for the Pods of the deployment to be scheduled on the same node as the Persistent Volume. Below there is an example using Node labels as selector to create the PVC and schedule the Pods in the same node.

```yaml
nautobot:
  persistence:
    enabled: true
    storageClass: "your-storage-class"
    size: "2Gi"
    selector:
      matchLabel:
        nautobot-storage: static

  # Selector for the Pods of the deployment.
  nodeSelector:
    nautobot-storage: static
```
