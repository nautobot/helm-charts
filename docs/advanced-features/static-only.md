# Separate Static Files Deployment

It may be desirable to host the Nautobot static files completely separately from the other Nautobots deployments, this can help with deployment times and load in certain cases.  Similarly to how we can scale out other Nautobot endpoints with the [Additional Nautobots](additional-nautobots/) documentation, this can be accomplished with the following values:

```yaml
---
nautobots:
  static:
    enabled: true
    ingressPath: "/static"
    initNautobot: true
    staticFilesOnly: true
```
