{{/*
Return the fill release name
*/}}
{{- define "nautobot.names.fullname" -}}
{{ include "common.names.fullname" . }}
{{- end -}}

{{/*
Return the proper nautobot image name
*/}}
{{- define "nautobot.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.nautobot.image "global" .Values.global) }}
{{- end -}}

{{- define "nautobot.nginx.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.nautobot.nginx.image "global" .Values.global) }}
{{- end -}}

{{- define "nautobot.nginxExporter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.nginxExporter.image "global" .Values.global) }}
{{- end -}}

{{- define "nautobot.uwsgiExporter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.uwsgiExporter.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "nautobot.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.nautobot.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "nautobot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "nautobot.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "nautobot.validateValues.foo" .) -}}
{{- $messages := append $messages (include "nautobot.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{- define "nautobot.encryptedSecretKey" -}}
  {{- if not .Values.nautobot.secretKey -}}
    {{ include "common.secrets.passwords.manage" (dict "secret" (printf "%s-env" (include "nautobot.names.fullname" . )) "key" "NAUTOBOT_SECRET_KEY" "providedValues" (list "nautobot.secretKey") "length" 64 "strong" true "context" $) }}
  {{- else -}}
    {{- .Values.nautobot.secretKey | b64enc | quote -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.encryptedSuperUserAPIToken" -}}
  {{- if not .Values.nautobot.superUser.apitoken -}}
    {{ include "common.secrets.passwords.manage" (dict "secret" (printf "%s-env" (include "nautobot.names.fullname" . )) "key" "NAUTOBOT_SUPERUSER_API_TOKEN" "providedValues" (list "nautobot.superUserAPIToken") "length" 40 "strong" false "context" $) }}
  {{- else -}}
    {{- .Values.nautobot.superUser.apitoken | b64enc | quote -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.encryptedSuperUserPassword" -}}
  {{- if not .Values.nautobot.superUser.password -}}
    {{ include "common.secrets.passwords.manage" (dict "secret" (printf "%s-env" (include "nautobot.names.fullname" . )) "key" "NAUTOBOT_SUPERUSER_PASSWORD" "providedValues" (list "nautobot.superUserPassword") "length" 64 "strong" true "context" $) }}
  {{- else -}}
    {{- .Values.nautobot.superUser.password | b64enc | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nautobot.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nautobot.mariadb.fullname" -}}
{{- $name := default "mariadb" .Values.mariadb.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nautobot.postgresqlha.fullname" -}}
{{- $name := default "postgresqlha-pgpool" .Values.postgresqlha.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nautobot.database.engine" -}}
  {{- if (and (or .Values.postgresql.enabled .Values.postgresqlha.enabled) .Values.mariadb.enabled ) -}}
    {{- fail (printf "Both PostgreSQL and MariaDB can't be enabled at the same time.") -}}
  {{- else if (and .Values.postgresql.enabled .Values.postgresqlha.enabled) -}}
    {{- fail (printf "Both PostgreSQL and PostgreSQL-HA can't be enabled at the same time.") -}}
  {{- end -}}
  {{- if (or .Values.postgresql.enabled .Values.postgresqlha.enabled) -}}
    {{- if (.Values.nautobot.metrics) -}}
      django_prometheus.db.backends.postgresql
    {{- else -}}
      django.db.backends.postgresql
    {{- end -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- if (.Values.nautobot.metrics) -}}
      django_prometheus.db.backends.mysql
    {{- else -}}
      django.db.backends.mysql
    {{- end -}}
  {{- else -}}
    {{- .Values.nautobot.db.engine -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "nautobot.postgresql.fullname" . }}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- template "nautobot.postgresqlha.fullname" . }}
  {{- else if eq .Values.mariadb.enabled true -}}
    {{- template "nautobot.mariadb.fullname" . }}
  {{- else -}}
    {{- .Values.nautobot.db.host -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.dbname" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.database -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- .Values.postgresqlha.postgresql.database -}}
  {{- else if eq .Values.mariadb.enabled true -}}
    {{- .Values.mariadb.auth.database -}}
  {{- else -}}
    {{- .Values.nautobot.db.name -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.port" -}}
  {{- if (or .Values.postgresql.enabled .Values.postgresqlha.enabled) -}}
    {{- printf "%s" "5432" -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" "3306" -}}
  {{- else -}}
    {{- .Values.nautobot.db.port -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.username" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.username -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- .Values.postgresqlha.postgresql.username -}}
  {{- else if eq .Values.mariadb.enabled true -}}
    {{- .Values.mariadb.auth.username -}}
  {{- else -}}
    {{- .Values.nautobot.db.user -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.passwordName" -}}
  {{- if .Values.nautobot.db.existingSecret -}}
    {{- .Values.nautobot.db.existingSecret -}}
  {{- else if eq .Values.postgresql.enabled true -}}
      {{- default (printf "%s-db-password" (include "common.names.fullname" .)) .Values.postgresql.auth.existingSecret -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
      {{- default (printf "%s-db-password" (include "common.names.fullname" .)) .Values.postgresqlha.auth.existingSecret -}}
    {{- else -}}
      {{- printf "%s-db-password" (include "common.names.fullname" .) -}}
    {{- end -}}
  {{- else if eq .Values.mariadb.enabled true -}}
      {{- default (printf "%s-db-password" (include "common.names.fullname" .)) .Values.mariadb.auth.existingSecret -}}
  {{- else -}}
    {{- printf "%s-db-password" (include "common.names.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.passwordKey" -}}
  {{- if .Values.nautobot.db.existingSecret -}}
    {{- .Values.nautobot.db.existingSecretPasswordKey -}}
  {{- else if eq .Values.postgresql.enabled true -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
      {{- default "password" .Values.postgresql.auth.secretsKeys.adminPasswordKey -}}
    {{- else -}}
      {{- printf "password" -}}
    {{- end -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
      {{- printf "postgresql-password" -}}
  {{- else if eq .Values.mariadb.enabled true -}}
      {{- printf "mariadb-password" -}}
  {{- else -}}
    {{- printf "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nautobot.redis.fullname" -}}
{{- $name := default "redis" .Values.redis.nameOverride -}}
{{- if eq .Values.redis.sentinel.enabled true -}}
{{- printf "%s-%s-headless" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "nautobot.redis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- template "nautobot.redis.fullname" . -}}
  {{- else -}}
    {{- .Values.nautobot.redis.host -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.redis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.nautobot.redis.port -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.redis.ssl" -}}
  {{- if .Values.nautobot.redis.ssl -}}
    {{- printf "%s" "True" }}
  {{- else -}}
    {{- printf "%s" "False" }}
  {{- end -}}
{{- end -}}

{{/*
  Return the decoded redis password.  If redis is enabled check the existing secret passed to redis.
  If not check the existing secret passed to Nautobot.  The existingSecretPasswordKey key is used to lookup the password

  Pseudo Code:
  if nautobot.redis.existingSecret:
    return value from the secret at the key nautobot.redis.existingSecretPasswordKey
  else if redis.enabled:
    if redis.auth.existingSecret:
      return value from the secret at the key redis.auth.existingSecretPasswordKey
    else
      return value from redis.auth.password
  else if nautobot.redis.password:
    return value from nautobot.redis.password
  else
    ERROR
*/}}
{{- define "nautobot.redis.rawPassword" -}}
  {{- if .Values.nautobot.redis.existingSecret -}}
      {{- $password := "" -}}
      {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.nautobot.redis.existingSecret) -}}
      {{- if $secret -}}
        {{- if index $secret.data .Values.nautobot.redis.existingSecretPasswordKey -}}
          {{- $password = index $secret.data .Values.nautobot.redis.existingSecretPasswordKey -}}
        {{- else -}}
          {{- fail (printf "Key '%s' not found in secret '%s'" .Values.nautobot.redis.existingSecretPasswordKey .Values.nautobot.redis.existingSecret) -}}
        {{- end -}}
      {{- else -}}
        {{- fail (printf "Existing secret '%s' not found!" .Values.nautobot.redis.existingSecret) -}}
      {{- end -}}
      {{- $password | b64dec -}}
  {{- else if eq .Values.redis.enabled true -}}
      {{- if .Values.redis.auth.existingSecret -}}
        {{- $password := "" -}}
        {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.redis.auth.existingSecret) -}}
        {{- if $secret -}}
          {{- if index $secret.data .Values.redis.auth.existingSecretPasswordKey -}}
            {{- $password = index $secret.data .Values.redis.auth.existingSecretPasswordKey -}}
          {{- else -}}
            {{- fail (printf "Key '%s' not found in secret '%s'" .Values.redis.auth.existingSecretPasswordKey .Values.redis.auth.existingSecret) -}}
          {{- end -}}
        {{- else -}}
          {{- fail (printf "Existing secret '%s' not found!" .Values.redis.auth.existingSecret) -}}
        {{- end -}}
        {{- $password | b64dec -}}
      {{- else -}}
        {{- required "A Redis Password is required. Path: .Values.redis.auth.password" .Values.redis.auth.password -}}
      {{- end -}}
  {{- else if .Values.nautobot.redis.password -}}
    {{- .Values.nautobot.redis.password -}}
  {{- else -}}
    {{- fail (printf "You have to configure redis credentials.") -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.redis.encryptedPassword" -}}
  {{- include "nautobot.redis.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for Horizontal Pod Autoscaler.
*/}}
{{- define "common.capabilities.hpa.apiVersion" -}}
{{- if semverCompare "<1.23-0" (include "common.capabilities.kubeVersion" .) -}}
{{- print "autoscaling/v2beta2" -}}
{{- else -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}

{{/*
Build a dict of nautobot deployments each item will be keyed by the name to use for the deployment
name and will contain "ingressPaths" specifying the path for which this Nautobot deployment will
respond.  The .Values.nautobot defines the default nautobot deployment with an ingressPaths of / and
the default values for all other nautobot deployments.  Other Nautobot deployments can be specified
in the .Values.Nautobots key which is a dictionary with the same spec as .Values.Nautobot.
*/}}
{{ define "nautobot.nautobots" }}
{{- $nautobots := dict }}
{{- range $nautobotName, $nautobot := .Values.nautobots }}
{{- $nautobots = mustMergeOverwrite $nautobots (dict $nautobotName (mustMergeOverwrite (deepCopy $.Values.nautobot) $nautobot (dict "component" "nautobot"))) }}
{{- end }}
{{- mustToJson $nautobots -}}
{{- end }}

{{/*
Build a dict of nautobot celery deployments each item will be keyed by the name to use for the deployment
name.  The .Values.celery defines the default celery deployment.  Other Celery deployments can be specified
in the .Values.workers key which is a dictionary with the same spec as .Values.Nautobot.
*/}}
{{ define "nautobot.workers" }}
{{- $workers := dict }}
{{/*
Handle deprecation of celeryWorkers and celeryBeat keys, precedence will be:

workers.[default|beat]
[celeryWorker|celeryBeat]
celery

where values in the new workers key will always win over the others
*/}}
{{- $workers := dict }}
{{- $workers = mustMergeOverwrite $workers (dict "default" (mustMergeOverwrite (deepCopy $.Values.celery) $.Values.celeryWorker)) }}
{{- $workers = mustMergeOverwrite $workers (dict "beat" (mustMergeOverwrite (deepCopy $.Values.celery) $.Values.celeryBeat)) }}
{{- range $celeryName, $celery := .Values.workers }}
{{- $workers = mustMergeOverwrite $workers (dict $celeryName (mustMergeOverwrite (deepCopy $.Values.celery) $celery (dict "component" "nautobot-celery"))) }}
{{- end }}
{{/*
Celery Beat can only have 1 replica enforce that here
*/}}
{{- $workers = mustMergeOverwrite $workers (dict "beat" (dict "replicaCount" 1)) }}
{{- $workers = mustMergeOverwrite $workers (dict "beat" (dict "autoscaling" (dict "enabled" false))) }}
{{- mustToJson $workers -}}
{{- end }}

{{/*
Get values for the init job if singleInit is true.  Default all values to the root .nautobot defaults
*/}}
{{ define "nautobot.initJob" }}
{{- $initJob := dict }}
{{- $initJob = mustMergeOverwrite (deepCopy $.Values.nautobot) $.Values.initJob }}
{{- mustToJson $initJob -}}
{{- end }}
