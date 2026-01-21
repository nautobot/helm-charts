# NGINX sidecar

When using Nginx container as a sidecar to Nautobot, requests are being proxied from Nginx to Nautobot.
In order to deploy this, you have to enable `nginx` under nautobot key in `values.yaml` similar to the below:

```yaml
nautobot:
  nginx:
    enabled: true
```

With that configuration it is achieved to use the native (socket) uwsgi protocol as described in uwsgi's [docs](https://uwsgi-docs.readthedocs.io/en/latest/Protocol.html).

!!! Warning
    Default readiness Probes for Nautobot Pods are going to fail.

The cause for the failure of probes is that now Nautobot's uwsgi server doesn't expose HTTP/8080 ports to do `httpGet` requests against it, and uwsgi's socket is not behaving like normal TCP socket to use a probe of kind `tcpSocket`.

To overcome it you have either to disable the probes for Nautobot pods or configure them to use `exec` similar to the example below:

```yaml
nautobot:
  readinessProbe:
    enabled: true
    exec:
      command:
        - "bash"
        - "-c"
        - "nautobot-server health_check"
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 15
    failureThreshold: 3
    successThreshold: 1
```

## Custom Nginx configuration

You can pass a custom Nginx configuration similar with nautobot_config.py and uwsgi.ini files. As an example to pass it through file you can use `--set-file nautobot.nginx.config=nginx.config` when installing the chart.

## Custom TLS certificates

### Image built with the certificates

There is an extra `initContainer` that copies the certificates from Nautobot containers into a shared volume that Nginx sidecar is using to get the certificates for TLS termination. If you have internal PKI, you maybe build the nautobot image with those certificates inside. You can specify the path (without the trailing slash `/`) of the directory with the `certificates_path` value. Keep in mind that the files must be named `nautobot.crt` and `nautobot.key`.

```yaml
nautobot:
  nginx:
    certificates_path: "/opt/nautobot/internal_certs"
```

### TLS certificates as existing kubernetes secret

Another option is to create a kubernetes secret with those certificates, more info in the page for [existing secrets](existing-secrets/). If you have the secret created, then just specify it's name into values as shown below:

```yaml
nautobot:
  secret_name_tls: "internal-tls"
```

Nginx will mount that secret and use it accordingly for serving the application.
