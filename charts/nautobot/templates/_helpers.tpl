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
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
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
    django.db.backends.postgresql
  {{- else if .Values.mariadb.enabled -}}
    django.db.backends.mysql
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
    {{- .Values.postgresql.postgresqlDatabase -}}
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
    {{- .Values.postgresql.postgresqlUsername -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
    {{- .Values.postgresqlha.postgresql.username -}}
  {{- else if eq .Values.mariadb.enabled true -}}
    {{- .Values.mariadb.auth.username -}}
  {{- else -}}
    {{- .Values.nautobot.db.user -}}
  {{- end -}}
{{- end -}}

{{/*
  Return the decoded database password.  If postgres is enabled check the existing secret passed to postgres.
  If not check the existing secret passed to Nautobot.  Either the "postgresql-password" or the existingSecretPasswordKey key is used
*/}}
{{- define "nautobot.database.rawPassword" -}}
  {{- if eq .Values.postgresql.enabled true -}}
      {{- if .Values.postgresql.existingSecret -}}
        {{- $password := "" -}}
        {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.postgresql.existingSecret) -}}
        {{- if $secret -}}
          {{- if index $secret.data "postgresql-password" -}}
            {{- $password = index $secret.data "postgresql-password" -}}
          {{- else -}}
            {{- fail (printf "Key 'postgresql-password' not found in secret %s" .Values.postgresql.existingSecret) -}}
          {{- end -}}
        {{- else -}}
          {{- fail (printf "Existing secret %s not found!" .Values.postgresql.existingSecret) -}}
        {{- end -}}
        {{- $password | b64dec -}}
      {{- else -}}
        {{- required "A Postgres Password is required!" .Values.postgresql.postgresqlPassword -}}
      {{- end -}}
  {{- else if eq .Values.postgresqlha.enabled true -}}
      {{- if .Values.postgresqlha.postgresql.existingSecret -}}
        {{- $password := "" -}}
        {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.postgresqlha.postgresql.existingSecret) -}}
        {{- if $secret -}}
          {{- if index $secret.data "postgresql-password" -}}
            {{- $password = index $secret.data "postgresql-password" -}}
          {{- else -}}
            {{- fail (printf "Key 'postgresql-password' not found in secret %s" .Values.postgresqlha.postgresql.existingSecret) -}}
          {{- end -}}
        {{- else -}}
          {{- fail (printf "Existing secret %s not found!" .Values.postgresqlha.postgresql.existingSecret) -}}
        {{- end -}}
        {{- $password | b64dec -}}
      {{- else -}}
        {{- required "A Postgres Password is required!" .Values.postgresqlha.postgresql.password -}}
      {{- end -}}
  {{- else if eq .Values.mariadb.enabled true -}}
      {{- if .Values.mariadb.auth.existingSecret -}}
        {{- $password := "" -}}
        {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.mariadb.auth.existingSecret) -}}
        {{- if $secret -}}
          {{- if index $secret.data "mariadb-password" -}}
            {{- $password = index $secret.data "mariadb-password" -}}
          {{- else -}}
            {{- fail (printf "Key 'mariadb-password' not found in secret %s" .Values.mariadb.auth.existingSecret) -}}
          {{- end -}}
        {{- else -}}
          {{- fail (printf "Existing secret %s not found!" .Values.mariadb.auth.existingSecret) -}}
        {{- end -}}
        {{- $password | b64dec -}}
      {{- else -}}
        {{- required "A MariaDB Password is required!" .Values.mariadb.auth.password -}}
      {{- end -}}
  {{- else -}}
    {{- if .Values.nautobot.db.existingSecret -}}
      {{- $password := "" -}}
      {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.nautobot.db.existingSecret) -}}
      {{- if $secret -}}
        {{- if index $secret.data .Values.nautobot.db.existingSecretPasswordKey -}}
          {{- $password = index $secret.data .Values.nautobot.db.existingSecretPasswordKey -}}
        {{- else -}}
          {{- fail (printf "Key '%s' not found in secret %s" .Values.nautobot.db.existingSecretPasswordKey .Values.nautobot.db.existingSecret) -}}
        {{- end -}}
      {{- else -}}
        {{- fail (printf "Existing secret %s not found!" .Values.nautobot.db.existingSecret) -}}
      {{- end -}}
      {{- $password | b64dec -}}
    {{- else -}}
      {{- required "A Database Password is required!" .Values.nautobot.db.password -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.encryptedPassword" -}}
  {{- include "nautobot.database.rawPassword" . | b64enc | quote -}}
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
*/}}
{{- define "nautobot.redis.rawPassword" -}}
  {{- if eq .Values.redis.enabled true -}}
      {{- if .Values.redis.auth.existingSecret -}}
        {{- $password := "" -}}
        {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.redis.auth.existingSecret) -}}
        {{- if $secret -}}
          {{- if index $secret.data .Values.redis.auth.existingSecretPasswordKey -}}
            {{- $password = index $secret.data .Values.redis.auth.existingSecretPasswordKey -}}
          {{- else -}}
            {{- fail (printf "Key '%s' not found in secret %s" .Values.redis.auth.existingSecretPasswordKey .Values.redis.auth.existingSecret) -}}
          {{- end -}}
        {{- else -}}
          {{- fail (printf "Existing secret %s not found!" .Values.redis.auth.existingSecret) -}}
        {{- end -}}
        {{- $password | b64dec -}}
      {{- else -}}
        {{- required "A Redis Password is required!" .Values.redis.auth.password -}}
      {{- end -}}
  {{- else -}}
    {{- if .Values.nautobot.redis.existingSecret -}}
      {{- $password := "" -}}
      {{- $secret := (lookup "v1" "Secret" $.Release.Namespace .Values.nautobot.redis.existingSecret) -}}
      {{- if $secret -}}
        {{- if index $secret.data .Values.nautobot.redis.existingSecretPasswordKey -}}
          {{- $password = index $secret.data .Values.nautobot.redis.existingSecretPasswordKey -}}
        {{- else -}}
          {{- fail (printf "Key '%s' not found in secret %s" .Values.nautobot.redis.existingSecretPasswordKey .Values.nautobot.redis.existingSecret) -}}
        {{- end -}}
      {{- else -}}
        {{- fail (printf "Existing secret %s not found!" .Values.nautobot.redis.existingSecret) -}}
      {{- end -}}
      {{- $password | b64dec -}}
    {{- else -}}
      {{- required "A Redis Password is required!" .Values.nautobot.redis.password -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.redis.encryptedPassword" -}}
  {{- include "nautobot.redis.rawPassword" . | b64enc | quote -}}
{{- end -}}
