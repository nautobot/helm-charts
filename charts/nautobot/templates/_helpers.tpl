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

{{- define "nautobot.database.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- template "nautobot.postgresql.fullname" . }}
  {{- else -}}
    {{- .Values.nautobot.db.host -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.dbname" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlDatabase -}}
  {{- else -}}
    {{- .Values.nautobot.db.name -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.port" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.nautobot.db.port -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.database.username" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.postgresqlUsername -}}
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
{{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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

{{/*
Create a list of dictionaries for extra volumes/volumemounts, if nautobot.config is set prepend it to the list for
nautobot/celeryWorker/rqWorker
*/}}
{{- define "nautobot.extraVolumes" -}}
  {{- if (or .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- $configVolume := (dict "name" "nautobot-config" "configMap" (dict "name" (printf "%s-config" (include "nautobot.names.fullname" . )))) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configVolume) .Values.nautobot.extraVolumes) "context" $) -}}
  {{- else -}}
    {{- .Values.nautobot.extraVolumes -}}
  {{- end -}}
{{- end -}}

{{- define "celeryWorker.extraVolumes" -}}
  {{- if (or .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- $configVolume := (dict "name" "nautobot-config" "configMap" (dict "name" (printf "%s-config" (include "nautobot.names.fullname" . )))) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configVolume) .Values.celeryWorker.extraVolumes) "context" $) -}}
  {{- else -}}
    {{- .Values.celeryWorker.extraVolumes -}}
  {{- end -}}
{{- end -}}

{{- define "rqWorker.extraVolumes" -}}
  {{- if (or .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- $configVolume := (dict "name" "nautobot-config" "configMap" (dict "name" (printf "%s-config" (include "nautobot.names.fullname" . )))) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configVolume) .Values.rqWorker.extraVolumes) "context" $) -}}
  {{- else -}}
    {{- .Values.rqWorker.extraVolumes -}}
  {{- end -}}
{{- end -}}

{{- define "nautobot.extraVolumeMounts" -}}
  {{- $configMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/nautobot_config.py" "subPath" "nautobot_config.py") -}}
  {{- $uwsgiMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/uwsgi.ini" "subPath" "uwsgi.ini") -}}
  {{- if (and .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) (list $uwsgiMount) .Values.nautobot.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.config -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) .Values.nautobot.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.uWSGIini -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $uwsgiMount) .Values.nautobot.extraVolumeMounts) "context" $) -}}
  {{- else -}}
    {{- .Values.nautobot.extraVolumeMounts -}}
  {{- end -}}
{{- end -}}

{{- define "celeryWorker.extraVolumeMounts" -}}
  {{- $configMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/nautobot_config.py" "subPath" "nautobot_config.py") -}}
  {{- $uwsgiMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/uwsgi.ini" "subPath" "uwsgi.ini") -}}
  {{- if (and .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) (list $uwsgiMount) .Values.celeryWorker.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.config -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) .Values.celeryWorker.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.uWSGIini -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $uwsgiMount) .Values.celeryWorker.extraVolumeMounts) "context" $) -}}
  {{- else -}}
    {{- .Values.celeryWorker.extraVolumeMounts -}}
  {{- end -}}
{{- end -}}

{{- define "rqWorker.extraVolumeMounts" -}}
  {{- $configMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/nautobot_config.py" "subPath" "nautobot_config.py") -}}
  {{- $uwsgiMount := (dict "name" "nautobot-config" "mountPath" "/opt/nautobot/uwsgi.ini" "subPath" "uwsgi.ini") -}}
  {{- if (and .Values.nautobot.config .Values.nautobot.uWSGIini) -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) (list $uwsgiMount) .Values.rqWorker.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.config -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $configMount) .Values.rqWorker.extraVolumeMounts) "context" $) -}}
  {{- else if .Values.nautobot.uWSGIini -}}
    {{- include "common.tplvalues.render" (dict "value" (concat (list $uwsgiMount) .Values.rqWorker.extraVolumeMounts) "context" $) -}}
  {{- else -}}
    {{- .Values.rqWorker.extraVolumeMounts -}}
  {{- end -}}
{{- end -}}