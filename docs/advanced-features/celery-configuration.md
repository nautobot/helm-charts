# Celery Configuration

The Nautobot Helm chart provides several configuration options to control the behavior of Celery task execution. By default, only the Celery setting `worker_prefetch_multiplier` is overridden to `1`. With all the other values as default, this ensures that each Celery worker fetches the minimum tasks as pending.
This minimizes the risk of losing un-started tasks in the event of a worker restart (for example, during a Kubernetes scaling event).

Below the default values of helm charts for those settings:

```yaml
celery:
  concurrency: 0
  task_acks_late: false
  worker_prefetch_multiplier: 1
```

!!! note
    More information on Celery queue behavior, refer to the  [official Nautobot Core documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/administration/guides/celery-queues/#celery-task-queues) and the [official Celery documentation](https://docs.celeryq.dev/en/latest/userguide/configuration.html).

As a general guideline for kubernetes deployment we propose the below scenario. Have both `concurrency` and `worker_prefetch_multiplier` to `1`. That way only one job is executed simultaneously and another one is waiting in queue. Even if the worker is lost, at most two tasks are affected.

However, this configuration introduces a caveat: **Celery doesn't have capacity to run the `ping` task, so it doesn't reply back**. That's why this chart uses files as health probes for Celery workers based on [this approach](github.com/celery/celery/issues/4079#issuecomment-1270085680).

## Example: Single-task Worker configuration

To configure Celery workers to handle only one task at a time, use the following values.

```yaml
celery:
  concurrency: 1
  task_acks_late: true
  worker_prefetch_multiplier: 1
```

!!! warning
    Note that in order to change the `task_acks_late` to `true`, your Nautobot jobs have to be idempotent -- meaning they can safely be re-executed without causing data inconsistencies. Otherwise, tasks retried after a failure event may lead to data duplication or corruption. Use this setting with caution.

## Specify the file paths of health probes

Nautobot support files as health probes for Celery workers. This is enabled by default in the chart, by using the [respective configuration](https://docs.nautobot.com/projects/core/en/stable/user-guide/administration/configuration/settings/?h=celery_health_probes_as_files#celery_health_probes_as_files).

!!! warning
    Minimum Nautobot version should be `3.0.1` in order to support health probes files.

If you are in an environment where you need to specify the file paths to avoid filesystem issues (eg Openshift), you can use the below example.

1. Specify through environmental variables the necessary file paths:

```yaml
celery:
  extraEnvVars:
    - name: NAUTOBOT_CELERY_WORKER_HEARTBEAT_FILE
      value: "/tmp/my-writable-dir/worker_heartbeat"
    - name: NAUTOBOT_CELERY_WORKER_READINESS_FILE
      value: "/tmp/my-writable-dir/worker_ready"

```

2. Update the Celery Probes in helm values. Change the default probes similar to the following:

```yaml
livenessProbe:
  enabled: true
  timeoutSeconds: 2
  periodSeconds: 10
  initialDelaySeconds: 10
  failureThreshold: 4
  exec:
    command:
      - /bin/sh
      - -c
      - find /tmp/my-writable-dir/worker_heartbeat -mmin -1 | grep .
readinessProbe:
  enabled: true
  timeoutSeconds: 2
  periodSeconds: 10
  initialDelaySeconds: 10
  failureThreshold: 4
  exec:
    command:
      - /bin/sh
      - -c
      - find /tmp/my-writable-dir/worker_ready | grep .
```

That way the celery containers are creating a file in a writable directory when they are ready and live, and you use that file to check that your pods are working as expected.

### Still use ping for Celery health checks

Of course you can disable the custom probe solution by using `celery.worker_health_probes_as_files: false` and use `ping` task for health checks:

```yaml
celery:
  livenessProbe:
    enabled: true
    exec:
      command:
        - "bash"
        - "-c"
        - "nautobot-server celery inspect ping --destination celery@$HOSTNAME"
    initialDelaySeconds: 10
    periodSeconds: 60
    timeoutSeconds: 10
    failureThreshold: 3
    successThreshold: 1

  readinessProbe:
    enabled: true
    exec:
      command:
        - "bash"
        - "-c"
        - "nautobot-server celery inspect ping --destination celery@$HOSTNAME"
    initialDelaySeconds: 10
    periodSeconds: 60
    timeoutSeconds: 10
    failureThreshold: 3
    successThreshold: 1
```
