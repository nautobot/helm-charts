# nautobot

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![AppVersion: 1.1.2](https://img.shields.io/badge/AppVersion-1.1.2-informational?style=flat-square)

Nautobot is a Network Source of Truth and Network Automation Platform.

**Homepage:** <https://github.com/nautobot/nautobot>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Network to Code | opensource@networktocode.com | https://www.networktocode.com/ |

## Source Code

* <https://github.com/nautobot/nautobot>
* <https://github.com/networktocode-llc/helm-charts>

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
| commonAnnotations | object | `{}` |  |
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
| nautobot.image.pullSecrets | list | `[]` |  |
| nautobot.image.registry | string | `"ghcr.io"` |  |
| nautobot.image.repository | string | `"nautobot/nautobot"` |  |
| nautobot.image.tag | string | `"1.1.2"` |  |
| nautobot.initContainers | object | `{}` |  |
| nautobot.lifecycleHooks | object | `{}` |  |
| nautobot.livenessProbe.enabled | bool | `true` |  |
| nautobot.livenessProbe.failureThreshold | int | `3` |  |
| nautobot.livenessProbe.httpGet.path | string | `"/health/"` |  |
| nautobot.livenessProbe.httpGet.port | string | `"http"` |  |
| nautobot.livenessProbe.initialDelaySeconds | int | `30` |  |
| nautobot.livenessProbe.periodSeconds | int | `10` |  |
| nautobot.livenessProbe.successThreshold | int | `1` |  |
| nautobot.livenessProbe.timeoutSeconds | int | `5` |  |
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
| nautobot.readinessProbe.enabled | bool | `true` |  |
| nautobot.readinessProbe.failureThreshold | int | `3` |  |
| nautobot.readinessProbe.httpGet.path | string | `"/health/"` |  |
| nautobot.readinessProbe.httpGet.port | string | `"http"` |  |
| nautobot.readinessProbe.initialDelaySeconds | int | `30` |  |
| nautobot.readinessProbe.periodSeconds | int | `10` |  |
| nautobot.readinessProbe.successThreshold | int | `1` |  |
| nautobot.readinessProbe.timeoutSeconds | int | `5` |  |
| nautobot.replicaCount | int | `2` |  |
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
| service | object | `{"annotations":{},"clusterIP":null,"externalTrafficPolicy":"Cluster","httpsPort":443,"loadBalancerIP":null,"loadBalancerSourceRanges":[],"nodePorts":{"http":null,"https":null},"port":80,"type":"ClusterIP"}` | The Nautobot UI front end service |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
