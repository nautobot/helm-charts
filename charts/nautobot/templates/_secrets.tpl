{{define "nautobot.secret.env" -}}
{{- if not .Values.nautobot.django.existingSecret -}}
NAUTOBOT_SECRET_KEY: {{ include "nautobot.django.secretKey" .}}
{{ end -}}
{{- if (and .Values.nautobot.superUser.enabled (not .Values.nautobot.superUser.existingSecret)) -}}
NAUTOBOT_SUPERUSER_API_TOKEN: {{ include "nautobot.superUser.apiToken" .}}
NAUTOBOT_SUPERUSER_PASSWORD: {{ include "nautobot.superUser.password" .}}
{{- end -}}
{{- end }}