{{- define "nautobot.uwsgi.ini" -}}
[uwsgi]
; The IP address (typically localhost) and port that the WSGI process should listen on
{{- if and .Values.nautobot.nginx.enabled }}
socket = 127.0.0.1:8001
; Listen on localhost 8003 for readiness checks
http = 0.0.0.0:8003
{{ else }}
http = 0.0.0.0:8080
https = 0.0.0.0:8443,/opt/nautobot/nautobot.crt,/opt/nautobot/nautobot.key
{{ end }}

{{- if .Values.metrics.uwsgiExporter.enabled -}}
; Export statistics used for metrics gathering
stats = 127.0.0.1:1717
stats-http = true
{{ end }}

; Fail to start if any parameter in the configuration file isn’t explicitly understood by uWSGI
strict = true

; Enable master process to gracefully re-spawn and pre-fork workers
master = true

; Allow Python app-generated threads to run
enable-threads = true

;Try to remove all of the generated file/sockets during shutdown
vacuum = true

; Do not use multiple interpreters, allowing only Nautobot to run
single-interpreter = true

; Shutdown when receiving SIGTERM (default is respawn)
die-on-term = true

; Prevents uWSGI from starting if it is unable load Nautobot (usually due to errors)
need-app = true

; By default, uWSGI has rather verbose logging that can be noisy
disable-logging = true

; Assert that critical 4xx and 5xx errors are still logged
log-4xx = true
log-5xx = true

; Enable HTTP 1.1 keepalive support
http-keepalive = 1

;
; Advanced settings (disabled by default)
; Customize these for your environment if and only if you need them.
; Ref: https://uwsgi-docs.readthedocs.io/en/latest/Options.html
;

; Number of uWSGI workers to spawn. This should typically be 2n+1, where n is the number of CPU cores present. Default 3 as n will be >= 1
processes = {{ .Values.nautobot.uwsgi.processes }}

; Number of uWSGI threads each worker will be pre-forked into before starting
threads = {{ .Values.nautobot.uwsgi.threads }}

; set the socket listen queue size, in production the suggested value is 1024, however RHEL based kernels have a max of 128 by default
; you may need to increase the somaxconn parameter in your kernel
listen = {{ .Values.nautobot.uwsgi.listen }}

; If using subdirectory hosting e.g. example.com/nautobot, you must uncomment this line. Otherwise you'll get double paths e.g. example.com/nautobot/nautobot/.
; See: https://uwsgi-docs.readthedocs.io/en/latest/Changelog-2.0.11.html#fixpathinfo-routing-action
; route-run = fixpathinfo:

; If hosted behind a load balancer uncomment these lines, the harakiri timeout should be greater than your load balancer timeout.
; Ref: https://uwsgi-docs.readthedocs.io/en/latest/HTTP.html?highlight=keepalive#http-keep-alive
; harakiri = 65
; add-header = Connection: Keep-Alive
; http-keepalive = 1
{{ end }}
