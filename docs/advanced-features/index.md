# Advanced Features

With [Kubernetes](https://kubernetes.io/), public clouds, and the [dependency subcharts](../installation/dependencies) we use the sky is the limit as far as installation and deployment possibilities.  There is no way we can capture everything here.  We have run into several common deployment use cases which may come in handy which we try to document here.  Each feature is documented as a stand alone option however they can be combined where it makes sense to do so.  We also have no control over many of the variables involved in these deployments so these examples are provided as-is and should be considered as a reference example only.

* [Additional Nautobots](additional-nautobots/)
* [Celery Configuration](celery-configuration/)
* [Celery Queues](celery-queues/)
* [Custom Nautobot Image](custom-image/)
* [Custom `nautobot_config.py`](custom-nautobot-config/)
* [Custom `uwsgi.ini`](custom-uwsgi/)
* [Existing Secrets](existing-secrets/)
* [External Database](external-database/)
* [External Redis](external-redis/)
* [Extra Objects](extra-objects/)
* [Ingress](ingress/)
* [Initialization Job](init-hook/)
* [Nautobot as a Subchart](nautobot-as-subchart/)
* [Network Policy](network-policy/)
* [Nginx Sidecar](nginx-sidecar/)
* [Persistent Volumes for Files](persistence/)
* [PostgreSQL TLS](postgresql-tls/)
* [Prometheus Operator Metrics](prometheus-metrics/)
* [Redis Sentinel](redis-sentinel/)
* [Redis TLS](redis-tls/)
* [Static Files Only](static-only/)

For additional configuration for one of the subcharts please see their documentation:

* [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) which can be configured under the `postgresql.*` values.
* [Bitnami Redis chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) which can be configured under the `redis.*` values.
