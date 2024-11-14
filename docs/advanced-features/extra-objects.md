# Applying Extra Kubernetes Objects

Certain deployments require additional Kubernetes objects that are not deployed
as a part of this Helm Chart.

The following are some of the use cases:

- Admin credentials are generated and stored in a secret manager such as
  HashiCorp Vault or AWS Secrets Manager. These credentials must be injected
  to Pods as a Kubernetes secret.
- Additional Ingresses must be deployed to expose Nautobot on a different hostname.
- Additional Kubernetes Jobs must be executed to perform additional checks or
  to provision certain aspects of Nautobot deployment.

Let's focus on the use case for admin credentials. Once the credentials are
stored in HashiCorp Vault, for example, you can use the ExternalSecrets
operator to fetch those credentials and create the Kubernetes Secret object.
The following snippet shows an example:

```
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-secret
  namespace: nautobot
spec:
  data:
    - remoteRef:
        conversionStrategy: Default
        decodingStrategy: None
        key: secrets/nautobot/superuser
        metadataPolicy: None
        property: SUPERUSER_PASSWORD
      secretKey: SUPERUSER_PASSWORD
    - remoteRef:
        conversionStrategy: Default
        decodingStrategy: None
        key: secrets/nautobot/superuser
        metadataPolicy: None
        property: API_TOKEN
      secretKey: API_TOKEN
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: vault
  target:
    creationPolicy: Owner
    deletionPolicy: Retain
    name: my-secret
    template:
      data:
        NAUTOBOT_SUPERUSER_PASSWORD: "{{ `{{ .SUPERUSER_PASSWORD | toString }}` }}"
        NAUTOBOT_SUPERUSER_API_TOKEN: "{{ `{{ .API_TOKEN | toString }}` }}"
      engineVersion: v2
      mergePolicy: Replace
```

The operator will fetch credentials from Vault and it will create a Kubernetes
Secret, after this object is deployed. The Helm Chart values will then specify
the existing secret name such as this:

```
nautobot:
  superUser:
    existingSecret: "my-secret"
```

To apply additional Kubernetes objects, such as the one above, you
must use an external tool, such as FluxCD, ArgoCD, Ansible, or something else.

To simplify this process, the Nautobot Helm Chart supports an additional
property called `extraObjects`. This property is a list of Kubernetes manifests
that must be deployed along to Nautobot objects generated from this Helm Chart.
This allows you to omit using external tools to deploy any extra Kubernetes
objects.

The following snippet shows how the Helm Chart values would look in this
case:

```
---
nautobot:
  superUser:
    existingSecret: "my-secret"

extraObjects:
  - |
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: my-secret
      namespace: nautobot
    spec:
      data:
        - remoteRef:
            conversionStrategy: Default
            decodingStrategy: None
            key: secrets/nautobot/superuser
            metadataPolicy: None
            property: SUPERUSER_PASSWORD
          secretKey: SUPERUSER_PASSWORD
        - remoteRef:
            conversionStrategy: Default
            decodingStrategy: None
            key: secrets/nautobot/superuser
            metadataPolicy: None
            property: API_TOKEN
          secretKey: API_TOKEN
      refreshInterval: 1h
      secretStoreRef:
        kind: ClusterSecretStore
        name: vault
      target:
        creationPolicy: Owner
        deletionPolicy: Retain
        name: my-secret
        template:
          data:
            NAUTOBOT_SUPERUSER_PASSWORD: "{{ `{{ .SUPERUSER_PASSWORD | toString }}` }}"
            NAUTOBOT_SUPERUSER_API_TOKEN: "{{ `{{ .API_TOKEN | toString }}` }}"
          engineVersion: v2
          mergePolicy: Replace
```

Helm will also deploy the `ExternalSecret` object when the release with these
values is deployed. The Nautobot Pods require the `my-secret` Secret,
so they will not start until the ExternalSecrets operator creates the Secret.

You must be aware that these manifests are deployed in order defined by Helm.
So, there is no guarantee, that certain manifests will be deployed before others.
In cases where you need certain manifests (such as a Job for example), you
will still need a third-party tool.

The manifests can be defined as a string or as a dictionary, as shown in the
following example:

```
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: database-host
      namespace: nautobot
    data:
      DATABASE_HOST: database.example.com
  - |
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: database-user
      namespace: nautobot
    data:
      DATABASE_USER: db-admin
```

You can also use Go templating language to define certain parts of a manifest.
All variables from the Helm Chart values file are available. You can also
use functions that are available in Go templating language.

The following example shows how you can specify namespace dynamically, and
how to define the secret name on a single place.

```
---
nautobot:
  superUser:
    existingSecret: "my-secret"

extraObjects:
  - |
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: {{ .Values.nautobot.superUser.existingSecret }}
      namespace: {{ .Release.Namespace }}
    spec:
      data:
        - remoteRef:
            conversionStrategy: Default
            decodingStrategy: None
            key: secrets/nautobot/superuser
            metadataPolicy: None
            property: SUPERUSER_PASSWORD
          secretKey: SUPERUSER_PASSWORD
        - remoteRef:
            conversionStrategy: Default
            decodingStrategy: None
            key: secrets/nautobot/superuser
            metadataPolicy: None
            property: API_TOKEN
          secretKey: API_TOKEN
      refreshInterval: 1h
      secretStoreRef:
        kind: ClusterSecretStore
        name: vault
      target:
        creationPolicy: Owner
        deletionPolicy: Retain
        name: {{ .Values.nautobot.superUser.existingSecret }}
        template:
          data:
            NAUTOBOT_SUPERUSER_PASSWORD: "{{ `{{ .SUPERUSER_PASSWORD | toString }}` }}"
            NAUTOBOT_SUPERUSER_API_TOKEN: "{{ `{{ .API_TOKEN | toString }}` }}"
          engineVersion: v2
          mergePolicy: Replace
```

Please note that these objects are processed in a template. So make sure that
you don't use the same syntax as used for Go templating. You can use back quotes
to "escape" strings in those cases. The following is an example:

```
NAUTOBOT_SUPERUSER_PASSWORD: "{{ `{{ .SUPERUSER_PASSWORD | toString }}` }}"
```

The resulting manifest will be: `NAUTOBOT_SUPERUSER_PASSWORD: {{ .SUPERUSER_PASSWORD | toString }}`
