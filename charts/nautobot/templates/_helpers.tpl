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

{{/*
The secret name where the nautobot secret_key used by django will exist.
*/}}
{{- define "nautobot.django.secretName" -}}
  {{- default (printf "%s-env" (include "common.names.fullname" .)) .Values.nautobot.django.existingSecret -}}
{{- end -}}

{{/*
The secret key where the nautobot secret_key used by django will exist.
*/}}
{{- define "nautobot.django.existingSecretSecretKeyKey" -}}
  {{- default (printf "NAUTOBOT_SECRET_KEY") .Values.nautobot.django.existingSecretSecretKeyKey -}}
{{- end -}}

{{/*
Retrieve existing django/nautobot secret key, use one provided via values or generate a random one
*/}}
{{- define "nautobot.django.secretKey" -}}
  {{- include "common.secrets.passwords.manage" (dict "secret" (include "nautobot.django.secretName" .) "key" (include "nautobot.django.existingSecretSecretKeyKey" .) "providedValues" (list "nautobot.django.secretKey" "nautobot.secretKey") "length" 64 "strong" true "context" $) -}}
{{- end -}}

{{- define "nautobot.superUser.secretName" -}}
  {{- default (printf "%s-env" (include "common.names.fullname" .)) .Values.nautobot.superUser.existingSecret -}}
{{- end -}}

{{- define "nautobot.superUser.existingSecretPasswordKey" -}}
  {{- default (printf "NAUTOBOT_SUPERUSER_PASSWORD") .Values.nautobot.superUser.existingSecretPasswordKey -}}
{{- end -}}

{{- define "nautobot.superUser.existingSecretApiTokenKey" -}}
  {{- default (printf "NAUTOBOT_SUPERUSER_API_TOKEN") .Values.nautobot.superUser.existingSecretApiTokenKey -}}
{{- end -}}

{{- define "nautobot.superUser.apiToken" -}}
  {{- include "common.secrets.passwords.manage" (dict "secret" (include "nautobot.superUser.secretName" . ) "key" (include "nautobot.superUser.existingSecretApiTokenKey" .) "providedValues" (list "nautobot.superUser.apitoken") "length" 40 "strong" false "context" $) -}}
{{- end -}}

{{- define "nautobot.superUser.password" -}}
  {{- include "common.secrets.passwords.manage" (dict "secret" (include "nautobot.superUser.secretName" . ) "key" (include "nautobot.superUser.existingSecretPasswordKey" .) "providedValues" (list "nautobot.superUser.password") "length" 64 "strong" true "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nautobot.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "nautobot.database.engine" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- if (.Values.nautobot.metrics) -}}
      django_prometheus.db.backends.postgresql
    {{- else -}}
      django.db.backends.postgresql
    {{- end -}}
  {{- else -}}
    {{- .Values.nautobot.db.engine -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "nautobot.postgresql.fullname" . }}
  {{- else -}}
    {{- .Values.nautobot.db.host -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.dbname" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.database -}}
  {{- else -}}
    {{- .Values.nautobot.db.name -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.nautobot.db.port -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.secretName" -}}
{{ printf "%s-%s" .Release.Name "db" | quote }}
{{- end -}}

{{/*
The following scenarios are supported to define the NAUTOBOT_DB_USER env var:
1) Managed PostgreSQL is enabled (postgresql.enabled=true). The username is taken
   from there (postgresql.auth.username).
2) External database is used (postgresql.enabled=false). You have existing K8s Secret
   containing the username (nautobot.db.existingSecret). The NAUTOBOT_DB_USER env var
   pulls the username directly from the existing K8s Secret. The key in the K8s secret
   where the username is stored is defined by nautobot.db.existingSecretUsernameKey.
3) External database is used (postgresql.enabled=false). You don't have existing K8s
   Secret. The Chart creates a K8s Secret containing the username and password.
   The username is taken from nautobot.db.user variable.
*/}}
{{- define "nautobot.database.userEnvVarDef" -}}
  {{- if eq .Values.postgresql.enabled true -}}
value: {{ .Values.postgresql.auth.username | quote }}
  {{- else -}}
    {{- if .Values.nautobot.db.existingSecret -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.nautobot.db.existingSecret | quote}}
    key: {{ .Values.nautobot.db.existingSecretUsernameKey | quote }}
    {{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ include "nautobot.database.secretName" . }}
    key: "username"
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
The following scenarios are supported to define the NAUTOBOT_DB_PASSWORD env var:
1) Managed PostgreSQL is enabled (postgresql.enabled=true). You have an existing K8s Secret
   containing the password (postgresql.auth.existingSecret). The NAUTOBOT_DB_PASSWORD env var
   pulls the password directly from the existing K8s Secret. The key in the K8s secret
   where the password is stored is defined by postgresql.auth.secretKeys.userPasswordKey.
2) Managed PostgreSQL is enabled (postgresql.enabled=true). You don't have existing K8s Secret.
   The Chart creates a K8s Secret containing the password. The password is taken
   from postgresql.auth.password. The K8s secret name is <release name>-postgresql if
   the postgresql.nameOverride is not defined, otherwise it is <release name>-<nameOverride>.
3) External database is used (postgresql.enabled=false). You have existing K8s Secret
   containing the password (nautobot.db.existingSecret). The NAUTOBOT_DB_PASSWORD env var
   pulls the password directly from the existing K8s Secret. The key in the K8s secret
   where the password is stored is defined by nautobot.db.existingSecretPasswordKey.
4) External database is used (postgresql.enabled=false). You don't have existing K8s
   Secret. The Chart creates a K8s Secret containing the password. The password is taken
   from nautobot.db.password. The K8s secret name is <release name>-db.
*/}}
{{- define "nautobot.database.passEnvVarDef" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.postgresql.auth.existingSecret }}
    key: {{ default "password" .Values.postgresql.auth.secretKeys.userPasswordKey | quote }}
    {{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ printf "%s-%s" .Release.Name (default "postgresql" .Values.postgresql.nameOverride) | quote }}
    key: "password"
    {{- end -}}
  {{- else -}}
    {{- if .Values.nautobot.db.existingSecret -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.nautobot.db.existingSecret | quote }}
    key: {{ .Values.nautobot.db.existingSecretPasswordKey | quote }}
    {{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ printf "%s-%s" .Release.Name "db" | quote }}
    key: "password"
    {{- end -}}
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
  Return the secret name where the redis password will exist.
  Either in the value you've supplied to the Nautobot chart, the Redis chart
  or if a password is being generated, where it will be generated at.
*/}}
{{- define "nautobot.redis.passwordName" -}}
  {{- if .Values.nautobot.redis.existingSecret -}}
    {{- .Values.nautobot.redis.existingSecret -}}
  {{- else if .Values.redis.auth.existingSecret -}}
    {{- .Values.redis.auth.existingSecret -}}
  {{- else if .Values.redis.nameOverride -}}
    {{- printf "%s-%s" .Release.Name .Values.redis.nameOverride -}}
  {{- else -}}
    {{- printf "%s-redis" .Release.Name -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.redis.passwordKey" -}}
  {{- if .Values.nautobot.redis.existingSecretPasswordKey -}}
    {{- .Values.nautobot.redis.existingSecretPasswordKey -}}
  {{- else if .Values.redis.auth.existingSecretPasswordKey -}}
    {{- .Values.redis.auth.existingSecretPasswordKey -}}
  {{- else -}}
    {{- printf "redis-password" -}}
  {{- end -}}
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
