{{- define "nginx.nautobot.conf" -}}
server {
    listen 8443 ssl default_server;
    listen [::]:8443 ssl default_server;

    http2 on;

    server_name _;

    ssl_certificate /opt/nautobot_certs/nautobot.crt;
    ssl_certificate_key /opt/nautobot_certs/nautobot.key;

    client_max_body_size 25m;

    location /static/ {
        alias /opt/nautobot/static/;
    }

    location / {
        include uwsgi_params;
        uwsgi_pass  127.0.0.1:8001;
        uwsgi_param Host $host;
        uwsgi_param X-Real-IP $remote_addr;
        uwsgi_param X-Forwarded-For $proxy_add_x_forwarded_for;
        uwsgi_param X-Forwarded-Proto $http_x_forwarded_proto;
    }
}

server {
    listen 8080 default_server;
    listen [::]:8080 default_server;

    server_name _;

    client_max_body_size 25m;

    location /static/ {
        alias /opt/nautobot/static/;
    }

    location / {
        include uwsgi_params;
        uwsgi_pass  127.0.0.1:8001;
        uwsgi_param Host $host;
        uwsgi_param X-Real-IP $remote_addr;
        uwsgi_param X-Forwarded-For $proxy_add_x_forwarded_for;
        uwsgi_param X-Forwarded-Proto $http_x_forwarded_proto;
    }
}
server {
    listen 8002;
    location / {
        stub_status;
    }
}
{{ end }}
