# Celery Queues

Nautobot supports [multiple celery task queues](https://docs.nautobot.com/projects/core/en/stable/administration/celery-queues/) besides the `default` queue.  In order to take advantage of those you will want to deploy celery workers for each queue.  This can easily be accomplished with the `workers` key.  For example to deploy workers to specifically listen on the `cisco` queue you would use the following values:

```yaml
workers:
  cisco:
    enabled: true
    taskQueues: "cisco"
```

This will create a separate deployment for the celery workers listening to the `cisco` queue.  Additionally if you wanted to further tweak this specific deployment you can use any of the keys from `celery` which are the default values used by this `cisco` worker deployment and override them.  For example, if you knew you had a LOT of cisco tasks we could scale out to 5 workers specifically for this queue:

```yaml
workers:
  cisco:
    enabled: true
    taskQueues: "cisco"
    replicaCount: 5
```

This is completely dynamic you can create workers for any number of queues.
