# nautobot

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![AppVersion: 1.1.3](https://img.shields.io/badge/AppVersion-1.1.3-informational?style=flat-square)

Nautobot is a Network Source of Truth and Network Automation Platform.

## Source Code

* <https://github.com/nautobot/nautobot>
* <https://github.com/nautobot/helm-charts>

## Prerequisites

* Kubernetes 1.12+
* Helm 3.1.x
* PV provisioning support (Required if deploying the [postgresql chart](https://artifacthub.io/packages/helm/bitnami/postgresql))

## Installing the Chart

### Add the Nautobot Helm Repo

```no-highlight
$ helm repo add nautobot https://nautobot.github.io/helm-charts/
```

### Install the Nautobot Chart from the Nautobot repo

To install the chart with the release name `my-release` DB and Redis passwords are required:

```no-highlight
$ helm install my-release nautobot/nautobot --set postgresql.postgresqlPassword="change-me" --set redis.auth.password="change-me"
```

The command deploys Nautobot; on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configure Nautobot

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```no-highlight
$ helm delete my-release
```

## Common Examples

1. Deploy Nautobot
2. Use External DB
3. Enable RQ Workers
4. Configure Ingress

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |
| https://charts.bitnami.com/bitnami | postgresql | 10.x.x |
| https://charts.bitnami.com/bitnami | redis | 14.X.X |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.apiVersion | string | `"autoscaling/v2beta2"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `5` |  |
| autoscaling.metrics[0].resource.name | string | `"cpu"` |  |
| autoscaling.metrics[0].resource.targetAverageUtilization | int | `80` |  |
| autoscaling.metrics[0].type | string | `"Resource"` |  |
| autoscaling.minReplicas | int | `2` |  |
| celeryWorker.affinity | object | `{}` |  |
| celeryWorker.args | list | `[]` |  |
| celeryWorker.command[0] | string | `"nautobot-server"` |  |
| celeryWorker.command[1] | string | `"celery"` |  |
| celeryWorker.command[2] | string | `"worker"` |  |
| celeryWorker.command[3] | string | `"--loglevel"` |  |
| celeryWorker.command[4] | string | `"$(NAUTOBOT_LOG_LEVEL)"` |  |
| celeryWorker.containerSecurityContext.enabled | bool | `true` |  |
| celeryWorker.containerSecurityContext.runAsUser | int | `999` |  |
| celeryWorker.enabled | bool | `true` |  |
| celeryWorker.extraEnvVars | list | `[]` |  |
| celeryWorker.extraEnvVarsCM | string | `nil` |  |
| celeryWorker.extraEnvVarsSecret | string | `nil` |  |
| celeryWorker.extraVolumeMounts | list | `[]` |  |
| celeryWorker.extraVolumes | list | `[]` |  |
| celeryWorker.hostAliases | list | `[]` |  |
| celeryWorker.initContainers | object | `{}` |  |
| celeryWorker.lifecycleHooks | object | `{}` |  |
| celeryWorker.livenessProbe.enabled | bool | `true` |  |
| celeryWorker.livenessProbe.exec.command[0] | string | `"bash"` |  |
| celeryWorker.livenessProbe.exec.command[1] | string | `"-c"` |  |
| celeryWorker.livenessProbe.exec.command[2] | string | `"nautobot-server celery inspect ping --destination celery@$HOSTNAME"` |  |
| celeryWorker.livenessProbe.failureThreshold | int | `3` |  |
| celeryWorker.livenessProbe.initialDelaySeconds | int | `30` |  |
| celeryWorker.livenessProbe.periodSeconds | int | `60` |  |
| celeryWorker.livenessProbe.successThreshold | int | `1` |  |
| celeryWorker.livenessProbe.timeoutSeconds | int | `10` |  |
| celeryWorker.nodeAffinityPreset.key | string | `""` |  |
| celeryWorker.nodeAffinityPreset.type | string | `""` |  |
| celeryWorker.nodeAffinityPreset.values | list | `[]` |  |
| celeryWorker.nodeSelector | object | `{}` |  |
| celeryWorker.podAffinityPreset | string | `""` |  |
| celeryWorker.podAnnotations | object | `{}` |  |
| celeryWorker.podAntiAffinityPreset | string | `"soft"` |  |
| celeryWorker.podLabels | object | `{}` |  |
| celeryWorker.podSecurityContext.enabled | bool | `true` |  |
| celeryWorker.podSecurityContext.fsGroup | int | `999` |  |
| celeryWorker.priorityClassName | string | `""` |  |
| celeryWorker.readinessProbe.enabled | bool | `true` |  |
| celeryWorker.readinessProbe.exec.command[0] | string | `"bash"` |  |
| celeryWorker.readinessProbe.exec.command[1] | string | `"-c"` |  |
| celeryWorker.readinessProbe.exec.command[2] | string | `"nautobot-server celery inspect ping --destination celery@$HOSTNAME"` |  |
| celeryWorker.readinessProbe.failureThreshold | int | `3` |  |
| celeryWorker.readinessProbe.initialDelaySeconds | int | `30` |  |
| celeryWorker.readinessProbe.periodSeconds | int | `60` |  |
| celeryWorker.readinessProbe.successThreshold | int | `1` |  |
| celeryWorker.readinessProbe.timeoutSeconds | int | `10` |  |
| celeryWorker.replicaCount | int | `2` |  |
| celeryWorker.resources.limits.cpu | string | `"1"` |  |
| celeryWorker.resources.limits.memory | string | `"1Gi"` |  |
| celeryWorker.resources.requests.cpu | string | `".1"` |  |
| celeryWorker.resources.requests.memory | string | `"512Mi"` |  |
| celeryWorker.sidecars | object | `{}` |  |
| celeryWorker.tolerations | list | `[]` |  |
| celeryWorker.updateStrategy.type | string | `"RollingUpdate"` |  |
| commonAnnotations | object | `{}` | Annotations to be applied to ALL resources created by this chart |
| ingress.annotations | object | `{}` |  |
| ingress.apiVersion | string | `nil` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `"nautobot.local"` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| ingress.secrets | list | `[]` |  |
| ingress.tls | bool | `false` |  |
| nautobot.affinity | object | `{}` | [ref](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) Affinity for Nautobot pods assignment |
| nautobot.allowedHosts | string | `"*"` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#allowed_hosts) Space seperated list of Nautobot allowed hosts (NAUTOBOT_ALLOWED_HOSTS) |
| nautobot.args | list | `[]` | Override default Nautobot container args (useful when using custom images) |
| nautobot.command | list | `[]` | Override default Nautobot container command (useful when using custom images) |
| nautobot.containerSecurityContext | object | `{"enabled":true,"runAsGroup":999,"runAsUser":999}` | [ref](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) Nautobot Container Security Context |
| nautobot.db.engine | string | `"django.db.backends.postgresql"` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot database engine, valid values: `django.db.backends.postgresql` and `django.db.backends.mysql` (NAUTOBOT_DB_ENGINE) |
| nautobot.db.host | string | `"postgres"` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot external database hostname, ignored if `postgresql.enabled` is `true` (NAUTOBOT_DB_HOST) |
| nautobot.db.name | string | `"nautobot"` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot external database name, ignored if `postgresql.enabled` is `true` (NAUTOBOT_DB_NAME) |
| nautobot.db.password | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot external database password, ignored if `postgresql.enabled` is `true` (NAUTOBOT_DB_PASSWORD) |
| nautobot.db.port | int | `5432` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot external database port, ignored if `postgresql.enabled` is `true` (NAUTOBOT_DB_PORT) |
| nautobot.db.timeout | int | `300` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot database timeout (NAUTOBOT_DB_TIMEOUT) |
| nautobot.db.user | string | `"nautobot"` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#databases) Nautobot external database username, ignored if `postgresql.enabled` is `true` (NAUTOBOT_DB_USER) |
| nautobot.debug | bool | `false` |  |
| nautobot.extraEnvVars | list | `[]` | Extra Env Vars to set only on the Nautobot server pods |
| nautobot.extraEnvVarsCM | string | `nil` | Name of existing ConfigMap containing extra env vars for Nautobot server pods |
| nautobot.extraEnvVarsSecret | string | `nil` | Name of existing Secret containing extra env vars for Nautobot server pods |
| nautobot.extraVars | list | `[]` | An array of envirnoment variable objects (`name` and `value` are required) to add to ALL Nautobot related deployments (i.e. `celeryWorker` and `rqWorker`) |
| nautobot.extraVolumeMounts | list | `[]` | List of additional volumeMounts for the Nautobot containers |
| nautobot.extraVolumes | list | `[]` | List of additional volumes for the Nautobot server pod |
| nautobot.hostAliases | list | `[]` | [ref](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/) Nautobot pods host aliases |
| nautobot.image.pullPolicy | string | `"IfNotPresent"` |  |
| nautobot.image.pullSecrets | list | `[]` | List of secret names to be used as image [pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/), common to all deployments |
| nautobot.image.registry | string | `"ghcr.io"` | Nautobot image registry, common to all deployments |
| nautobot.image.repository | string | `"nautobot/nautobot"` | Nautobot image name, common to all deployments |
| nautobot.image.tag | string | `"1.1.3"` | Nautobot image tag, common to all deployments |
| nautobot.initContainers | object | `{}` | [ref](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Add additional init containers to the Nautobot server pods |
| nautobot.lifecycleHooks | object | `{}` | lifecycleHooks for the Nautobot container(s) to automate configuration before or after startup |
| nautobot.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/health/","port":"http"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | [ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes) Nautobot liveness probe |
| nautobot.logLevel | string | `"INFO"` | Log Level used for Celery logging, valid values: `CRITICAL`, `ERROR`, `WARNING`, `INFO`, `DEBUG` |
| nautobot.metrics | bool | `true` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/optional-settings/#metrics_enabled) Enable Prometheus metrics endpoint (NAUTOBOT_METRICS_ENABLED) |
| nautobot.nodeAffinityPreset | object | `{"key":"","type":"","values":[]}` | [ref](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) Nautobot Node Affinity preset |
| nautobot.nodeAffinityPreset.key | string | `""` | Node label key to match. Ignored if `nautobot.affinity` is set |
| nautobot.nodeAffinityPreset.type | string | `""` | Nautobot Node affinity preset type. Ignored if `nautobot.affinity` is set. Valid values: `soft` or `hard` |
| nautobot.nodeAffinityPreset.values | list | `[]` | Node label values to match. Ignored if `nautobot.affinity` is set |
| nautobot.nodeSelector | object | `{}` | [ref](https://kubernetes.io/docs/user-guide/node-selection/) Node labels for Nautobot pods assignment |
| nautobot.podAffinityPreset | string | `""` | [ref](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity) Nautobot Pod affinity preset. Ignored if `nautobot.affinity` is set. Valid values: `soft` or `hard` |
| nautobot.podAnnotations | object | `{}` | [ref](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) Annotations for nautobot pods |
| nautobot.podAntiAffinityPreset | string | `"soft"` | [ref](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity) Nautobot Pod anti-affinity preset. Ignored if `nautobot.affinity` is set. Valid values: `soft` or `hard` |
| nautobot.podLabels | object | `{}` | [ref](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) Extra labels for nautobot pods |
| nautobot.podSecurityContext | object | `{"enabled":true,"fsGroup":999}` | [ref](ttps://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) Nautobot Pods Security Context |
| nautobot.priorityClassName | string | `""` | Nautobot pods' priorityClassName |
| nautobot.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/health/","port":"http"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | [ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes) Nautobot readiness probe |
| nautobot.redis.host | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#rq_queues) Nautobot external redis hostname, ignored if `redis.enabled` is `true` (NAUTOBOT_REDIS_HOST) |
| nautobot.redis.password | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#rq_queues) Nautobot external redis password, ignored if `redis.enabled` is `true` (NAUTOBOT_REDIS_PASSWORD) |
| nautobot.redis.port | int | `6379` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#rq_queues) Nautobot external redis port, ignored if `redis.enabled` is `true` (NAUTOBOT_REDIS_PORT) |
| nautobot.redis.ssl | bool | `false` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#rq_queues) Nautobot external redis ssl enabled, ignored if `redis.enabled` is `true` (NAUTOBOT_REDIS_SSL) |
| nautobot.redis.username | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/configuration/required-settings/#rq_queues) Nautobot external redis username, ignored if `redis.enabled` is `true` (NAUTOBOT_REDIS_USERNAME) |
| nautobot.replicaCount | int | `2` | Number of Nautobot server replicas to deploy |
| nautobot.resources | object | `{"limits":{"cpu":"2","memory":"2Gi"},"requests":{"cpu":"0.7","memory":"784Mi"}}` | [ref](http://kubernetes.io/docs/user-guide/compute-resources/) Nautobot resource requests and limits |
| nautobot.secretKey | string | `""` |  |
| nautobot.sidecars | object | `{}` | Add additional sidecar containers to the Nautobot server pods |
| nautobot.superUser.apitoken | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/docker/#nautobot_superuser_api_token) Configure an API key for the super user if `nautobot.superUser.enabled` is `true` (NAUTOBOT_SUPERUSER_API_TOKEN) |
| nautobot.superUser.email | string | `"admin@example.com"` | [ref](https://nautobot.readthedocs.io/en/stable/docker/#nautobot_superuser_email) Configure an email address for the super user if `nautobot.superUser.enabled` is `true` (NAUTOBOT_SUPERUSER_EMAIL) |
| nautobot.superUser.enabled | bool | `true` | [ref](https://nautobot.readthedocs.io/en/stable/docker/#nautobot_create_superuser) Create a new super user account in Nautobot once deployed (NAUTOBOT_CREATE_SUPERUSER) |
| nautobot.superUser.password | string | `""` | [ref](https://nautobot.readthedocs.io/en/stable/docker/#nautobot_superuser_password) Password to use for the super user to be created if `nautobot.superUser.enabled` is `true` (NAUTOBOT_SUPERUSER_NAME), if unset a random password will be generated |
| nautobot.superUser.username | string | `"admin"` | [ref](https://nautobot.readthedocs.io/en/stable/docker/#nautobot_superuser_name) User name to use for the super user to be created if `nautobot.superUser.enabled` is `true` (NAUTOBOT_SUPERUSER_NAME) |
| nautobot.tolerations | list | `[]` | [ref](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) Tolerations for Nautobot pods assignment |
| nautobot.updateStrategy.type | string | `"RollingUpdate"` | [ref](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies) Nautobot Deployment strategy type |
| postgresql.enabled | bool | `true` |  |
| postgresql.postgresqlDatabase | string | `"nautobot"` |  |
| postgresql.postgresqlPassword | string | `""` |  |
| postgresql.postgresqlUsername | string | `"nautobot"` |  |
| redis.auth.enabled | bool | `true` |  |
| redis.auth.password | string | `""` |  |
| redis.enabled | bool | `true` |  |
| rqWorker.affinity | object | `{}` |  |
| rqWorker.args | list | `[]` |  |
| rqWorker.command[0] | string | `"nautobot-server"` |  |
| rqWorker.command[1] | string | `"rqworker"` |  |
| rqWorker.containerSecurityContext.enabled | bool | `true` |  |
| rqWorker.containerSecurityContext.runAsUser | int | `999` |  |
| rqWorker.enabled | bool | `true` |  |
| rqWorker.extraEnvVars | list | `[]` |  |
| rqWorker.extraEnvVarsCM | string | `nil` |  |
| rqWorker.extraEnvVarsSecret | string | `nil` |  |
| rqWorker.extraVolumeMounts | list | `[]` |  |
| rqWorker.extraVolumes | list | `[]` |  |
| rqWorker.hostAliases | list | `[]` |  |
| rqWorker.initContainers | object | `{}` |  |
| rqWorker.lifecycleHooks | object | `{}` |  |
| rqWorker.livenessProbe.enabled | bool | `true` |  |
| rqWorker.livenessProbe.exec.command[0] | string | `"nautobot-server"` |  |
| rqWorker.livenessProbe.exec.command[1] | string | `"health_check"` |  |
| rqWorker.livenessProbe.failureThreshold | int | `3` |  |
| rqWorker.livenessProbe.initialDelaySeconds | int | `5` |  |
| rqWorker.livenessProbe.periodSeconds | int | `15` |  |
| rqWorker.livenessProbe.successThreshold | int | `1` |  |
| rqWorker.livenessProbe.timeoutSeconds | int | `8` |  |
| rqWorker.nodeAffinityPreset.key | string | `""` |  |
| rqWorker.nodeAffinityPreset.type | string | `""` |  |
| rqWorker.nodeAffinityPreset.values | list | `[]` |  |
| rqWorker.nodeSelector | object | `{}` |  |
| rqWorker.podAffinityPreset | string | `""` |  |
| rqWorker.podAnnotations | object | `{}` |  |
| rqWorker.podAntiAffinityPreset | string | `"soft"` |  |
| rqWorker.podLabels | object | `{}` |  |
| rqWorker.podSecurityContext.enabled | bool | `true` |  |
| rqWorker.podSecurityContext.fsGroup | int | `999` |  |
| rqWorker.priorityClassName | string | `""` |  |
| rqWorker.readinessProbe.enabled | bool | `true` |  |
| rqWorker.readinessProbe.exec.command[0] | string | `"nautobot-server"` |  |
| rqWorker.readinessProbe.exec.command[1] | string | `"health_check"` |  |
| rqWorker.readinessProbe.failureThreshold | int | `3` |  |
| rqWorker.readinessProbe.initialDelaySeconds | int | `5` |  |
| rqWorker.readinessProbe.periodSeconds | int | `15` |  |
| rqWorker.readinessProbe.successThreshold | int | `1` |  |
| rqWorker.readinessProbe.timeoutSeconds | int | `8` |  |
| rqWorker.replicaCount | int | `2` |  |
| rqWorker.resources.limits.cpu | string | `"1"` |  |
| rqWorker.resources.limits.memory | string | `"1Gi"` |  |
| rqWorker.resources.requests.cpu | string | `".1"` |  |
| rqWorker.resources.requests.memory | string | `"256Mi"` |  |
| rqWorker.sidecars | object | `{}` |  |
| rqWorker.tolerations | list | `[]` |  |
| rqWorker.updateStrategy.type | string | `"RollingUpdate"` |  |
| service.annotations | object | `{}` | Annotations to be applied to the service resource |
| service.clusterIP | string | `nil` | IP address to use as the clusterIP |
| service.externalTrafficPolicy | string | `"Cluster"` | Kubernetes externalTrafficPolicy valid values: `Cluster` or `Local` |
| service.httpsPort | int | `443` | Port to expose for Nautobot https access |
| service.loadBalancerIP | string | `nil` | IP address to use as the loadBalancerIP |
| service.loadBalancerSourceRanges | list | `[]` | List of allowed CIDRs to access the load balancer default 0.0.0.0/0, cloud provider dependent |
| service.nodePorts.http | string | `nil` | Node port for Nautobot http choose port in Kubernetes `--service-node-port-range` typically 30000-32767 |
| service.nodePorts.https | string | `nil` | Node port for Nautobot https choose port in Kubernetes `--service-node-port-range` typically 30000-32767 |
| service.port | int | `80` | Port to expose for Nautobot http access |
| service.type | string | `"ClusterIP"` | [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) type, valid values: `ExternalName`, `ClusterIP`, `NodePort`, or `LoadBalancer` |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
