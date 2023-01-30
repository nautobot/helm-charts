# mariadb

![Version: 10.5.1](https://img.shields.io/badge/Version-10.5.1-informational?style=flat-square) ![AppVersion: 10.5.15](https://img.shields.io/badge/AppVersion-10.5.15-informational?style=flat-square)

MariaDB is an open source, community-developed SQL database server that is widely in use around the world due to its enterprise features, flexibility, and collaboration with leading tech firms.

**Homepage:** <https://github.com/bitnami/charts/tree/master/bitnami/mariadb>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Bitnami | <containers@bitnami.com> |  |

## Source Code

* <https://github.com/bitnami/bitnami-docker-mariadb>
* <https://github.com/prometheus/mysqld_exporter>
* <https://mariadb.org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| architecture | string | `"standalone"` |  |
| auth.customPasswordFiles | object | `{}` |  |
| auth.database | string | `"my_database"` |  |
| auth.existingSecret | string | `""` |  |
| auth.forcePassword | bool | `false` |  |
| auth.password | string | `""` |  |
| auth.replicationPassword | string | `""` |  |
| auth.replicationUser | string | `"replicator"` |  |
| auth.rootPassword | string | `""` |  |
| auth.usePasswordFiles | bool | `false` |  |
| auth.username | string | `""` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| diagnosticMode.args[0] | string | `"infinity"` |  |
| diagnosticMode.command[0] | string | `"sleep"` |  |
| diagnosticMode.enabled | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.debug | bool | `false` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"bitnami/mariadb"` |  |
| image.tag | string | `"10.5.15-debian-10-r62"` |  |
| initdbScripts | object | `{}` |  |
| initdbScriptsConfigMap | string | `""` |  |
| kubeVersion | string | `""` |  |
| metrics.annotations."prometheus.io/port" | string | `"9104"` |  |
| metrics.annotations."prometheus.io/scrape" | string | `"true"` |  |
| metrics.containerSecurityContext.enabled | bool | `false` |  |
| metrics.enabled | bool | `false` |  |
| metrics.extraArgs.primary | list | `[]` |  |
| metrics.extraArgs.secondary | list | `[]` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.pullSecrets | list | `[]` |  |
| metrics.image.registry | string | `"docker.io"` |  |
| metrics.image.repository | string | `"bitnami/mysqld-exporter"` |  |
| metrics.image.tag | string | `"0.14.0-debian-10-r44"` |  |
| metrics.livenessProbe.enabled | bool | `true` |  |
| metrics.livenessProbe.failureThreshold | int | `3` |  |
| metrics.livenessProbe.initialDelaySeconds | int | `120` |  |
| metrics.livenessProbe.periodSeconds | int | `10` |  |
| metrics.livenessProbe.successThreshold | int | `1` |  |
| metrics.livenessProbe.timeoutSeconds | int | `1` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| metrics.readinessProbe.enabled | bool | `true` |  |
| metrics.readinessProbe.failureThreshold | int | `3` |  |
| metrics.readinessProbe.initialDelaySeconds | int | `30` |  |
| metrics.readinessProbe.periodSeconds | int | `10` |  |
| metrics.readinessProbe.successThreshold | int | `1` |  |
| metrics.readinessProbe.timeoutSeconds | int | `1` |  |
| metrics.resources.limits | object | `{}` |  |
| metrics.resources.requests | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"30s"` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceMonitor.selector | object | `{}` |  |
| nameOverride | string | `""` |  |
| networkPolicy.egressRules.customRules | object | `{}` |  |
| networkPolicy.egressRules.denyConnectionsToExternal | bool | `false` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.ingressRules.primaryAccessOnlyFrom.customRules | object | `{}` |  |
| networkPolicy.ingressRules.primaryAccessOnlyFrom.enabled | bool | `false` |  |
| networkPolicy.ingressRules.primaryAccessOnlyFrom.namespaceSelector | object | `{}` |  |
| networkPolicy.ingressRules.primaryAccessOnlyFrom.podSelector | object | `{}` |  |
| networkPolicy.ingressRules.secondaryAccessOnlyFrom.customRules | object | `{}` |  |
| networkPolicy.ingressRules.secondaryAccessOnlyFrom.enabled | bool | `false` |  |
| networkPolicy.ingressRules.secondaryAccessOnlyFrom.namespaceSelector | object | `{}` |  |
| networkPolicy.ingressRules.secondaryAccessOnlyFrom.podSelector | object | `{}` |  |
| networkPolicy.metrics.enabled | bool | `false` |  |
| networkPolicy.metrics.namespaceSelector | object | `{}` |  |
| networkPolicy.metrics.podSelector | object | `{}` |  |
| primary.affinity | object | `{}` |  |
| primary.args | list | `[]` |  |
| primary.command | list | `[]` |  |
| primary.configuration | string | `"[mysqld]\nskip-name-resolve\nexplicit_defaults_for_timestamp\nbasedir=/opt/bitnami/mariadb\nplugin_dir=/opt/bitnami/mariadb/plugin\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\ntmpdir=/opt/bitnami/mariadb/tmp\nmax_allowed_packet=16M\nbind-address=::\npid-file=/opt/bitnami/mariadb/tmp/mysqld.pid\nlog-error=/opt/bitnami/mariadb/logs/mysqld.log\ncharacter-set-server=UTF8\ncollation-server=utf8_general_ci\nslow_query_log=0\nslow_query_log_file=/opt/bitnami/mariadb/logs/mysqld.log\nlong_query_time=10.0\n\n[client]\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\ndefault-character-set=UTF8\nplugin_dir=/opt/bitnami/mariadb/plugin\n\n[manager]\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\npid-file=/opt/bitnami/mariadb/tmp/mysqld.pid"` |  |
| primary.containerSecurityContext.enabled | bool | `true` |  |
| primary.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| primary.containerSecurityContext.runAsUser | int | `1001` |  |
| primary.customLivenessProbe | object | `{}` |  |
| primary.customReadinessProbe | object | `{}` |  |
| primary.customStartupProbe | object | `{}` |  |
| primary.existingConfigmap | string | `""` |  |
| primary.extraEnvVars | list | `[]` |  |
| primary.extraEnvVarsCM | string | `""` |  |
| primary.extraEnvVarsSecret | string | `""` |  |
| primary.extraFlags | string | `""` |  |
| primary.extraVolumeMounts | list | `[]` |  |
| primary.extraVolumes | list | `[]` |  |
| primary.hostAliases | list | `[]` |  |
| primary.initContainers | list | `[]` |  |
| primary.lifecycleHooks | object | `{}` |  |
| primary.livenessProbe.enabled | bool | `true` |  |
| primary.livenessProbe.failureThreshold | int | `3` |  |
| primary.livenessProbe.initialDelaySeconds | int | `120` |  |
| primary.livenessProbe.periodSeconds | int | `10` |  |
| primary.livenessProbe.successThreshold | int | `1` |  |
| primary.livenessProbe.timeoutSeconds | int | `1` |  |
| primary.nodeAffinityPreset.key | string | `""` |  |
| primary.nodeAffinityPreset.type | string | `""` |  |
| primary.nodeAffinityPreset.values | list | `[]` |  |
| primary.nodeSelector | object | `{}` |  |
| primary.pdb.create | bool | `false` |  |
| primary.pdb.maxUnavailable | string | `""` |  |
| primary.pdb.minAvailable | int | `1` |  |
| primary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| primary.persistence.annotations | object | `{}` |  |
| primary.persistence.enabled | bool | `true` |  |
| primary.persistence.existingClaim | string | `""` |  |
| primary.persistence.selector | object | `{}` |  |
| primary.persistence.size | string | `"8Gi"` |  |
| primary.persistence.storageClass | string | `""` |  |
| primary.persistence.subPath | string | `""` |  |
| primary.podAffinityPreset | string | `""` |  |
| primary.podAnnotations | object | `{}` |  |
| primary.podAntiAffinityPreset | string | `"soft"` |  |
| primary.podLabels | object | `{}` |  |
| primary.podManagementPolicy | string | `""` |  |
| primary.podSecurityContext.enabled | bool | `true` |  |
| primary.podSecurityContext.fsGroup | int | `1001` |  |
| primary.priorityClassName | string | `""` |  |
| primary.readinessProbe.enabled | bool | `true` |  |
| primary.readinessProbe.failureThreshold | int | `3` |  |
| primary.readinessProbe.initialDelaySeconds | int | `30` |  |
| primary.readinessProbe.periodSeconds | int | `10` |  |
| primary.readinessProbe.successThreshold | int | `1` |  |
| primary.readinessProbe.timeoutSeconds | int | `1` |  |
| primary.resources.limits | object | `{}` |  |
| primary.resources.requests | object | `{}` |  |
| primary.revisionHistoryLimit | int | `10` |  |
| primary.rollingUpdatePartition | string | `""` |  |
| primary.schedulerName | string | `""` |  |
| primary.service.annotations | object | `{}` |  |
| primary.service.clusterIP | string | `""` |  |
| primary.service.externalTrafficPolicy | string | `"Cluster"` |  |
| primary.service.extraPorts | list | `[]` |  |
| primary.service.loadBalancerIP | string | `""` |  |
| primary.service.loadBalancerSourceRanges | list | `[]` |  |
| primary.service.nodePorts.mysql | string | `""` |  |
| primary.service.ports.mysql | int | `3306` |  |
| primary.service.sessionAffinity | string | `"None"` |  |
| primary.service.sessionAffinityConfig | object | `{}` |  |
| primary.service.type | string | `"ClusterIP"` |  |
| primary.sidecars | list | `[]` |  |
| primary.startupProbe.enabled | bool | `false` |  |
| primary.startupProbe.failureThreshold | int | `10` |  |
| primary.startupProbe.initialDelaySeconds | int | `120` |  |
| primary.startupProbe.periodSeconds | int | `15` |  |
| primary.startupProbe.successThreshold | int | `1` |  |
| primary.startupProbe.timeoutSeconds | int | `5` |  |
| primary.startupWaitOptions | object | `{}` |  |
| primary.tolerations | list | `[]` |  |
| primary.topologySpreadConstraints | object | `{}` |  |
| primary.updateStrategy.type | string | `"RollingUpdate"` |  |
| rbac.create | bool | `false` |  |
| schedulerName | string | `""` |  |
| secondary.affinity | object | `{}` |  |
| secondary.args | list | `[]` |  |
| secondary.command | list | `[]` |  |
| secondary.configuration | string | `"[mysqld]\nskip-name-resolve\nexplicit_defaults_for_timestamp\nbasedir=/opt/bitnami/mariadb\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\ntmpdir=/opt/bitnami/mariadb/tmp\nmax_allowed_packet=16M\nbind-address=0.0.0.0\npid-file=/opt/bitnami/mariadb/tmp/mysqld.pid\nlog-error=/opt/bitnami/mariadb/logs/mysqld.log\ncharacter-set-server=UTF8\ncollation-server=utf8_general_ci\n\n[client]\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\ndefault-character-set=UTF8\n\n[manager]\nport=3306\nsocket=/opt/bitnami/mariadb/tmp/mysql.sock\npid-file=/opt/bitnami/mariadb/tmp/mysqld.pid"` |  |
| secondary.containerSecurityContext.enabled | bool | `true` |  |
| secondary.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| secondary.containerSecurityContext.runAsUser | int | `1001` |  |
| secondary.customLivenessProbe | object | `{}` |  |
| secondary.customReadinessProbe | object | `{}` |  |
| secondary.customStartupProbe | object | `{}` |  |
| secondary.existingConfigmap | string | `""` |  |
| secondary.extraEnvVars | list | `[]` |  |
| secondary.extraEnvVarsCM | string | `""` |  |
| secondary.extraEnvVarsSecret | string | `""` |  |
| secondary.extraFlags | string | `""` |  |
| secondary.extraVolumeMounts | list | `[]` |  |
| secondary.extraVolumes | list | `[]` |  |
| secondary.hostAliases | list | `[]` |  |
| secondary.initContainers | list | `[]` |  |
| secondary.lifecycleHooks | object | `{}` |  |
| secondary.livenessProbe.enabled | bool | `true` |  |
| secondary.livenessProbe.failureThreshold | int | `3` |  |
| secondary.livenessProbe.initialDelaySeconds | int | `120` |  |
| secondary.livenessProbe.periodSeconds | int | `10` |  |
| secondary.livenessProbe.successThreshold | int | `1` |  |
| secondary.livenessProbe.timeoutSeconds | int | `1` |  |
| secondary.nodeAffinityPreset.key | string | `""` |  |
| secondary.nodeAffinityPreset.type | string | `""` |  |
| secondary.nodeAffinityPreset.values | list | `[]` |  |
| secondary.nodeSelector | object | `{}` |  |
| secondary.pdb.create | bool | `false` |  |
| secondary.pdb.maxUnavailable | string | `""` |  |
| secondary.pdb.minAvailable | int | `1` |  |
| secondary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| secondary.persistence.annotations | object | `{}` |  |
| secondary.persistence.enabled | bool | `true` |  |
| secondary.persistence.selector | object | `{}` |  |
| secondary.persistence.size | string | `"8Gi"` |  |
| secondary.persistence.storageClass | string | `""` |  |
| secondary.persistence.subPath | string | `""` |  |
| secondary.podAffinityPreset | string | `""` |  |
| secondary.podAnnotations | object | `{}` |  |
| secondary.podAntiAffinityPreset | string | `"soft"` |  |
| secondary.podLabels | object | `{}` |  |
| secondary.podManagementPolicy | string | `""` |  |
| secondary.podSecurityContext.enabled | bool | `true` |  |
| secondary.podSecurityContext.fsGroup | int | `1001` |  |
| secondary.priorityClassName | string | `""` |  |
| secondary.readinessProbe.enabled | bool | `true` |  |
| secondary.readinessProbe.failureThreshold | int | `3` |  |
| secondary.readinessProbe.initialDelaySeconds | int | `30` |  |
| secondary.readinessProbe.periodSeconds | int | `10` |  |
| secondary.readinessProbe.successThreshold | int | `1` |  |
| secondary.readinessProbe.timeoutSeconds | int | `1` |  |
| secondary.replicaCount | int | `1` |  |
| secondary.resources.limits | object | `{}` |  |
| secondary.resources.requests | object | `{}` |  |
| secondary.revisionHistoryLimit | int | `10` |  |
| secondary.rollingUpdatePartition | string | `""` |  |
| secondary.schedulerName | string | `""` |  |
| secondary.service.annotations | object | `{}` |  |
| secondary.service.clusterIP | string | `""` |  |
| secondary.service.externalTrafficPolicy | string | `"Cluster"` |  |
| secondary.service.extraPorts | list | `[]` |  |
| secondary.service.loadBalancerIP | string | `""` |  |
| secondary.service.loadBalancerSourceRanges | list | `[]` |  |
| secondary.service.nodePorts.mysql | string | `""` |  |
| secondary.service.ports.mysql | int | `3306` |  |
| secondary.service.sessionAffinity | string | `"None"` |  |
| secondary.service.sessionAffinityConfig | object | `{}` |  |
| secondary.service.type | string | `"ClusterIP"` |  |
| secondary.sidecars | list | `[]` |  |
| secondary.startupProbe.enabled | bool | `false` |  |
| secondary.startupProbe.failureThreshold | int | `10` |  |
| secondary.startupProbe.initialDelaySeconds | int | `120` |  |
| secondary.startupProbe.periodSeconds | int | `15` |  |
| secondary.startupProbe.successThreshold | int | `1` |  |
| secondary.startupProbe.timeoutSeconds | int | `5` |  |
| secondary.startupWaitOptions | object | `{}` |  |
| secondary.tolerations | list | `[]` |  |
| secondary.topologySpreadConstraints | object | `{}` |  |
| secondary.updateStrategy.type | string | `"RollingUpdate"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| volumePermissions.enabled | bool | `false` |  |
| volumePermissions.image.pullPolicy | string | `"IfNotPresent"` |  |
| volumePermissions.image.pullSecrets | list | `[]` |  |
| volumePermissions.image.registry | string | `"docker.io"` |  |
| volumePermissions.image.repository | string | `"bitnami/bitnami-shell"` |  |
| volumePermissions.image.tag | string | `"10-debian-10-r399"` |  |
| volumePermissions.resources.limits | object | `{}` |  |
| volumePermissions.resources.requests | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
