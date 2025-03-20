# Network Policy

There is the option to deploy a Network Policy to protect Nautobot Pods. With the below configuration Nautobot pod will have outbound access to DNS and backend services (DB & redis), and the Users will have connectivity to the Web Ports of the Nautobot web application.

```yaml
networkPolicy:
  enabled: true
  allowAllEgress: false
  allowExternalIngress: true
```

If you want to allow other Pods to connect to the Nautobot app, you need to label those as `release-name-client: "true"`. For example if the release is called `nautobot`, then the "client" pods should have the label `nautobot-client: "true"`.

There is also the option to specify extra rules both for Ingress and Egress connectivity according to your needs.
To achieve that you specify the extra rules under the keys `extraEgress` and `extraIngress` accordingly.
