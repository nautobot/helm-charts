# Additional Nautobots

In certain situations Nautobot experiences a heavy load due to high API or GraphQL usage.  In these cases it may be desirable to scale out Nautobot specifically for the `/api` or `/graphql` endpoints to be able to handle this load better without scaling out the default UI deployments.  This can be accomplished using the `nautobots` key in the helm chart.

```yaml
nautobots:
  api:
    enabled: true
    ingressPath: "/api"
    initNautobot: false
```

This will create a separate deployment dedicated to `/api` requests.  Additionally if you wanted to further tweak this specific deployment you can use any of the keys from `nautobot` which are the default values used by this `api` Nautobot deployment and override them.  For example to increase the memory requests specifically for this deployment to 32G you could set the following:

```yaml
nautobots:
  api:
    enabled: true
    ingressPath: "/api"
    initNautobot: false
    resources:
      requests:
        memory: "32G"
```

This is completely dynamic so you can create `/graphql` or `/plugins` deployments depending on your use case.
