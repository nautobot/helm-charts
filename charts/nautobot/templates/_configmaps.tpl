{{- define "nautobot.configMap.env" -}}
NAUTOBOT_ALLOWED_HOSTS: {{ .Values.nautobot.allowedHosts | quote }}
{{- if .Values.nautobot.superUser.enabled }}
NAUTOBOT_CREATE_SUPERUSER: "true"
{{- else }}
NAUTOBOT_CREATE_SUPERUSER: "false"
{{- end }}
NAUTOBOT_DB_ENGINE: {{ include "nautobot.database.engine" . | quote }}
NAUTOBOT_DB_HOST: {{ include "nautobot.database.host" . | quote }}
NAUTOBOT_DB_NAME: {{ include "nautobot.database.dbname" . | quote }}
NAUTOBOT_DB_PORT: {{ include "nautobot.database.port" . | quote }}
NAUTOBOT_DB_TIMEOUT: {{ .Values.nautobot.db.timeout | quote }}
NAUTOBOT_DB_USER: {{ include "nautobot.database.username" . | quote }}
{{- if .Values.nautobot.debug }}
NAUTOBOT_DEBUG: "True"
{{- else }}
NAUTOBOT_DEBUG: "False"
{{- end }}
NAUTOBOT_LOG_LEVEL: {{ .Values.nautobot.logLevel | quote }}
{{- if or .Values.nautobot.metrics .Values.metrics.enabled }}
NAUTOBOT_METRICS_ENABLED: "True"
{{- else }}
NAUTOBOT_METRICS_ENABLED: "False"
{{- end }}
NAUTOBOT_REDIS_HOST: {{ include "nautobot.redis.host" . | quote }}
NAUTOBOT_REDIS_PORT: {{ include "nautobot.redis.port" . | quote }}
NAUTOBOT_REDIS_USERNAME: {{ .Values.nautobot.redis.username | quote }}
NAUTOBOT_REDIS_SSL: {{ include "nautobot.redis.ssl" . | quote }}
{{- if .Values.nautobot.superUser.enabled }}
NAUTOBOT_SUPERUSER_EMAIL: {{ .Values.nautobot.superUser.email | quote }}
NAUTOBOT_SUPERUSER_NAME: {{ .Values.nautobot.superUser.username | quote }}
{{- end }}
{{- if .Values.nautobot.extraVars }}
{{- range .Values.nautobot.extraVars }}
{{- .name }}: {{ .value | quote }}
{{- end }}
{{- end }}
{{ end }}

{{- define "nautobot.configMap.config" -}}
{{- if .Values.nautobot.config }}
nautobot_config.py: |
{{- .Values.nautobot.config | nindent 2 }}
{{- end }}
uwsgi.ini: |
{{- if .Values.nautobot.uWSGIini }}
{{- .Values.nautobot.uWSGIini | nindent 2 }}
{{ else }}
{{- include "nautobot.uwsgi.ini" . | nindent 2 }}
{{- end }}
{{ end }}
