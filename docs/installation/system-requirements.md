# System Requirements

When installing Nautobot, or any application, the question of what are the system requirements comes up?  The answer is "It Depends!"  This is simply because how many resources an application requires depends on your individual use case, some things which will impact your requirements are:

* API Usage
* GraphQL Usage
* UI Usage
* Media Usage (images)
* Number of concurrent users
* High Availability
* Number of Devices

We have tried to come up with a general use case in this helm chart but these should be used as an initial starting point only:

* 2 Kubernetes Worker Nodes

The default Nautobot application requests:

* 300m CPU (Per Pod) * 2 Pods
* 1.2G RAM (Per Pod) * 2 Pods

The default Celery worker requests:

* 400m CPU (Per Pod) * 2 Pods
* 1G RAM (Per Pod) * 2 Pods

The default Celery beat requests:

* 5m CPU
* 256M RAM

Postgres:

* 250m CPU
* 256M RAM

Redis:

* Unbound by default

## Adjusting Resources

All of these system resource requests and limits can be adjusted by modifying the following Values (note the `resources` specification matches the [Kubernetes ResourceRequirements spec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#resourcerequirements-v1-core)):

```yaml
nautobot:
  resources:
celery:
  resources:
workers:
  beat:
    resources:
redis:
  master:
    resources:
postgresql:
  primary:
    resources:
```

## Summary

By default Nautobot will utilize approximately 1 CPU and 1.5Gb RAM.  Assuming there will be other services running on your Kubernetes nodes the Minimum requirements for running Nautobot are 2 CPU cores with 4GB RAM.  Nautobot disk space is negligible by default 10GB disk space per node should be sufficient.  However, these are BARE MINIMUM values and should be evaluated in your environment.
