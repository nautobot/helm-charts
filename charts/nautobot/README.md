# nautobot

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 1.1.3](https://img.shields.io/badge/AppVersion-1.1.3-informational?style=flat-square)

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
| nautobot.affinity | object | `{}` |  |
| nautobot.args | list | `[]` |  |
| nautobot.command | list | `[]` |  |
| nautobot.containerSecurityContext.enabled | bool | `true` |  |
| nautobot.containerSecurityContext.runAsGroup | int | `999` |  |
| nautobot.containerSecurityContext.runAsUser | int | `999` |  |
| nautobot.createSuperUser | bool | `true` |  |
| nautobot.debug | bool | `false` |  |
| nautobot.envVars.allowedHosts | string | `"*"` |  |
| nautobot.envVars.dbEngine | string | `"django.db.backends.postgresql"` |  |
| nautobot.envVars.dbHost | string | `"postgres"` |  |
| nautobot.envVars.dbName | string | `"nautobot"` |  |
| nautobot.envVars.dbPassword | string | `""` |  |
| nautobot.envVars.dbPort | int | `5432` |  |
| nautobot.envVars.dbTimeout | int | `300` |  |
| nautobot.envVars.dbUser | string | `"nautobot"` |  |
| nautobot.envVars.extraVars | list | `[]` |  |
| nautobot.envVars.logLevel | string | `"INFO"` |  |
| nautobot.envVars.metrics | bool | `true` |  |
| nautobot.envVars.redisHost | string | `""` |  |
| nautobot.envVars.redisPassword | string | `""` |  |
| nautobot.envVars.redisPort | int | `6379` |  |
| nautobot.envVars.redisSSL | bool | `false` |  |
| nautobot.envVars.redisUsername | string | `""` |  |
| nautobot.envVars.secretKey | string | `""` |  |
| nautobot.envVars.superUserAPIToken | string | `""` |  |
| nautobot.envVars.superUserEmail | string | `"admin@example.com"` |  |
| nautobot.envVars.superUserName | string | `"admin"` |  |
| nautobot.envVars.superUserPassword | string | `""` |  |
| nautobot.extraEnvVars | list | `[]` |  |
| nautobot.extraEnvVarsCM | string | `nil` |  |
| nautobot.extraEnvVarsSecret | string | `nil` |  |
| nautobot.extraVolumeMounts | list | `[]` |  |
| nautobot.extraVolumes | list | `[]` |  |
| nautobot.hostAliases | list | `[]` |  |
| nautobot.image.pullPolicy | string | `"IfNotPresent"` |  |
| nautobot.image.pullSecrets | list | `[]` | List of secret names to be used as image [pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) |
| nautobot.image.registry | string | `"ghcr.io"` | Nautobot image registry |
| nautobot.image.repository | string | `"nautobot/nautobot"` | Nautobot image name |
| nautobot.image.tag | string | `"1.1.3"` | Nautobot image tag |
| nautobot.initContainers | object | `{}` |  |
| nautobot.lifecycleHooks | object | `{}` |  |
| nautobot.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/health/","port":"http"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | [ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes) Nautobot liveness probe |
| nautobot.nodeAffinityPreset.key | string | `""` |  |
| nautobot.nodeAffinityPreset.type | string | `""` |  |
| nautobot.nodeAffinityPreset.values | list | `[]` |  |
| nautobot.nodeSelector | object | `{}` |  |
| nautobot.podAffinityPreset | string | `""` |  |
| nautobot.podAnnotations | object | `{}` |  |
| nautobot.podAntiAffinityPreset | string | `"soft"` |  |
| nautobot.podLabels | object | `{}` |  |
| nautobot.podSecurityContext.enabled | bool | `true` |  |
| nautobot.podSecurityContext.fsGroup | int | `999` |  |
| nautobot.priorityClassName | string | `""` |  |
| nautobot.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/health/","port":"http"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | [ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes) Nautobot readiness probe |
| nautobot.replicaCount | int | `2` | Number of Nautobot server replicas to deploy |
| nautobot.resources.limits.cpu | string | `"2"` |  |
| nautobot.resources.limits.memory | string | `"2Gi"` |  |
| nautobot.resources.requests.cpu | string | `"0.7"` |  |
| nautobot.resources.requests.memory | string | `"784Mi"` |  |
| nautobot.sidecars | object | `{}` |  |
| nautobot.tolerations | list | `[]` |  |
| nautobot.updateStrategy.type | string | `"RollingUpdate"` |  |
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
| service.externalTrafficPolicy | string | `"Cluster"` | Kubernetes externalTrafficPolicy valid values: Cluster or Local |
| service.httpsPort | int | `443` | Port to expose for Nautobot https access |
| service.loadBalancerIP | string | `nil` | IP address to use as the loadBalancerIP |
| service.loadBalancerSourceRanges | list | `[]` | List of allowed CIDRs to access the load balancer default 0.0.0.0/0, cloud provider dependent |
| service.nodePorts.http | string | `nil` | Node port for Nautobot http choose port in Kubernetes `--service-node-port-range` typically 30000-32767 |
| service.nodePorts.https | string | `nil` | Node port for Nautobot https choose port in Kubernetes `--service-node-port-range` typically 30000-32767 |
| service.port | int | `80` | Port to expose for Nautobot http access |
| service.type | string | `"ClusterIP"` | [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) type, valid values: ExternalName, ClusterIP, NodePort, or LoadBalancer |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
