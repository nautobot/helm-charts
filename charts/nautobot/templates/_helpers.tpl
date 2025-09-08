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


{{/*
Generate the secret that is used for `NAUTOBOT_DB_PASSWORD` environmental variable
in nautobot-deployment.yaml.

The following is the logic:
* If you have an existing K8s Secret containing the password it will take the secret from there.
  Note: If you deploy PostgreSQL as part of this chart (postgresql.enabled==true) you have to
        also define `postgresql.auth.existingSecret`
  Test:
    nautobot:
      db:
        existingSecret: "my-db-secret"
        existingSecretPasswordKey: "password"

* If the existing secret is not defined and you deploy PostgreSQL as part of this chart
  it either takes the values from the existing secret defined in the postgresql
  subchart (if defined) or it takes the secret that is generated by the subchart, which
  is done automatically when the subchart is enabled. The name of the secret that
  the subchart generates consists of <release name>-<nameOverride>. If you don't
  define the postgresql.nameOverride it takes "postgresql".

  Test1:
    `kubectl create secret generic my-db-secret --from-literal=password=database-password --from-literal=postgresql-password=database-admin-password`

    postgresql:
      enabled: true
      auth:
        existingSecret: "my-db-secret"

  Test2:
    postgresql:
      enabled: true

* The same logic is used for PostgreSQL in HA mode.

* If you enable mariadb then you have to disable postgresql. If you define
  the existing secret, it will use that one. If not, if will create a secret name
  from '<release name>-' and either 'nameOverride' if defined, or 'mariadb'.

  Test:
    postgresql:
      enabled: false
    mariadb:
      auth:
        existingSecret: "my-db-secret"

* If you defined the password in "nautobot.db.password" it will create the
  K8s Secret. This scenario is used for cases when you are using the external
  database, so you should also disable postgresql: postgresql.enabled=false.

  Test:
    nautobot:
      db:
        password: "database-password"
    postgresql:
      enabled: false

*/}}
{{- define "nautobot.database.passwordName" -}}
  {{- if .Values.nautobot.db.existingSecret -}}
    {{- .Values.nautobot.db.existingSecret -}}
  {{- else if eq .Values.postgresql.enabled true -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
      {{- .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
      {{- printf "%s-%s" .Release.Name (default "postgresql" .Values.postgresql.nameOverride) -}}
    {{- end -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- if .Values.postgresqlha.postgresql.existingSecret -}}
      {{- .Values.postgresqlha.postgresql.existingSecret -}}
    {{- else -}}
      {{- printf "%s-%s-postgresql" .Release.Name (default "postgresqlha" .Values.postgresqlha.nameOverride) -}}
    {{- end -}}
  {{- else if eq .Values.mariadb.enabled true -}}
    {{- if .Values.mariadb.auth.existingSecret -}}
      {{- .Values.mariadb.auth.existingSecret -}}
    {{- else -}}
      {{- printf "%s-%s" .Release.Name (default "mariadb" .Values.mariadb.nameOverride) -}}
    {{- end -}}
  {{- else -}}
    {{- printf "%s-db-password" (include "common.names.fullname" .) -}}
  {{- end -}}
{{- end -}}


{{- define "nautobot.database.passwordKey" -}}
  {{- if .Values.nautobot.db.existingSecret -}}
    {{- .Values.nautobot.db.existingSecretPasswordKey -}}
  {{- else if eq .Values.postgresql.enabled true -}}
    {{- if and .Values.postgresql.auth.existingSecret .Values.postgresql.auth.secretKeys -}}
      {{- default "password" .Values.postgresql.auth.secretKeys.userPasswordKey -}}
    {{- else -}}
      {{- printf "password" -}}
    {{- end -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{/* PostgresqlHA & MariaDB sub-charts don't specify a Secret Key,
      you need always to create the secrets with necessary keys like `password` before the helm install.
    */}}
    {{- printf "password" -}}
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
