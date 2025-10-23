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

However, this configuration introduces a caveat: **the default celery probes may fail when a task is executed**. The reason behind it is that Celery doesn't have capacity to run the `ping` task, so it doesn't reply back. To address this issue, you can either:

* Disable the default probes using custom Helm values, or
* Implement a custom probe solution, as described below.

## Implementing a Custom Probe Solution

In order to have a custom solution, you can follow [this approach](github.com/celery/celery/issues/4079#issuecomment-1270085680).

1. Inject a custom `nautobot_config.py`, and include the following code snippet in that file:

```python
# Custom probing for celery
if "celery" in os.environ["HOSTNAME"]:
  from pathlib import Path

  from celery import bootsteps
  from celery.signals import beat_init, worker_ready, worker_shutdown

  BEAT_READINESS_FILE = Path("/tmp/beat_ready")
  WORKER_HEARTBEAT_FILE = Path("/tmp/worker_heartbeat")
  WORKER_READINESS_FILE = Path("/tmp/worker_ready")

  class LivenessProbe(bootsteps.StartStopStep):
      requires = {"celery.worker.components:Timer"}

      def __init__(self, worker, **kwargs):
          self.requests = []
          self.tref = None

      def start(self, worker):
          self.tref = worker.timer.call_repeatedly(
              1.0,
              self.update_WORKER_HEARTBEAT_FILE,
              (worker,),
              priority=10,
          )

      def stop(self, worker):
          WORKER_HEARTBEAT_FILE.unlink(missing_ok=True)

      def update_WORKER_HEARTBEAT_FILE(self, worker):
          WORKER_HEARTBEAT_FILE.touch()

  @worker_ready.connect
  def worker_ready(**_):
      WORKER_READINESS_FILE.touch()

  @worker_shutdown.connect
  def worker_shutdown(**_):
      WORKER_READINESS_FILE.unlink(missing_ok=True)

  @beat_init.connect
  def beat_ready(**_):
      BEAT_READINESS_FILE.touch()

  # app = Celery("appname")
  from nautobot.core.celery import app

  app.steps["worker"].add(LivenessProbe)
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
      - find /tmp/worker_heartbeat -mmin -1 | grep .
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
      - find /tmp/worker_ready | grep .
```

That way the celery containers are creating a file when they are ready and live, and you use that file to check that your pods are working as expected through the kubernetes probes.

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
