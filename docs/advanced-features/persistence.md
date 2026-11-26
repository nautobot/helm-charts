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

## Custom Volumes

If Persistent Volumes are not an option, you can provide any [Kubernetes volume source](https://kubernetes.io/docs/concepts/storage/volumes/) (e.g. `csi`, `nfs`, `hostPath`, `ephemeral` or an existing `persistentVolumeClaim`) for static and media files:

* `nautobot.staticFilesVolume` - mounted at `/opt/nautobot/static`. Defaults to `emptyDir` when not set.
* `nautobot.mediaFilesVolume` - mounted at `/opt/nautobot/media`. No media volume is mounted when not set.

Below is an example that stores static files in a Google Cloud Storage bucket using the [Cloud Storage FUSE CSI driver](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver).

```yaml
nautobot:
  staticFilesVolume:
    csi:
      driver: gcsfuse.csi.storage.gke.io
      volumeAttributes:
        bucketName: "your-bucket-name"
        mountOptions: "implicit-dirs,o=noexec"
```

The static files volume is used by the Nautobot Pods and the init Job (`nautobot.singleInit`). The media files volume is used by the Nautobot Pods and the Kubernetes Jobs pods.

Nautobot deployments honour per-instance overrides in `nautobots.<name>`. The init Job and the Kubernetes Jobs pods always use the global `nautobot.*` values, the same as for `persistenceStaticFiles` and `persistenceMediaFiles`. Per-instance values are merged over `nautobot.*`, so to switch the volume type for one instance, set the global key to `null` (e.g. `csi: null`).

!!! note
    The Persistent Volume Claim takes precedence. If `nautobot.persistenceStaticFiles.enabled` or `nautobot.persistenceMediaFiles.enabled` is `true`, the matching `staticFilesVolume` or `mediaFilesVolume` value is ignored.
