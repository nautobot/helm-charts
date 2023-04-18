# Prometheus Operator Metrics

If you have the [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator) installed the following values can be used to deploy `ServiceMonitor` resources:

```yaml
metrics:
  enabled: true
  prometheusRule:
    enabled: true

postgresql:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true

redis:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
```

For additional metrics you can deploy the [`nginxExporter`](https://github.com/nginxinc/nginx-prometheus-exporter) and the [`uwsgiExporter`](https://github.com/timonwong/uwsgi_exporter).  These components are provided as third party dependencies and should be used at your own risk.

```yaml
metrics:
  nginxExporter:
    enabled: true
  uwsgiExporter:
    enabled: true
```
