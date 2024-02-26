{{- define "nautobot.secret.env" -}}
NAUTOBOT_SECRET_KEY: {{ include "nautobot.encryptedSecretKey" .}}
{{- if .Values.nautobot.superUser.enabled }}
NAUTOBOT_SUPERUSER_API_TOKEN: {{ include "nautobot.encryptedSuperUserAPIToken" .}}
NAUTOBOT_SUPERUSER_PASSWORD: {{ include "nautobot.encryptedSuperUserPassword" .}}
{{- end }}
{{ end }}
