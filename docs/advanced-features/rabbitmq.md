# RabbitMQ Support

!!! warning
    RabbitMQ Support for Nautobot is not tested by the Nautobot Core team and therefore support is minimal.

!!! warning
    RabbitMQ Support in this helm chart is considered experimental and should be used with caution.

!!! warning
    This example is extremely insecure, changes should be made for non-dev deployments.

In some situations it may be desirable to use RabbitMQ for task queuing instead of Redis, this is considered an advanced deployment pattern and should only be used when necessary.  It is important to note that Redis can not be completely replaced as of yet as it is still needed for caching in Nautobot.

RabbitMQ can be deployed with this helm chart by setting the following values:

```yaml
nautobot:
  extraVars:
    - name: "NAUTOBOT_CELERY_BROKER_URL"
      value: "amqp://admin:admin@nautobot-rabbitmq-headless.default.svc:5672/"

rabbitmq:
  enabled: true
  auth:
    username: "admin"
    password: "admin"
    erlangCookie: "someRandomValue"
```

The above values are only examples and additional options are available with the RabbitMQ subchart and can be found in the [upstream documentation](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq).

## Additional Considerations

With [RabbitMQ](https://www.rabbitmq.com/) operators should consider [TLS, Users, and Virtual Hosts](https://www.rabbitmq.com/access-control.html) at a minimum when configuring it for Nautobot Support.
