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
