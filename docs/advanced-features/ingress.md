# Ingress

To enable ingress, the following values are available for configuration:

```yaml
ingress:
  enabled: true
  hostname: nautobot.example.com
  tls: true
  secretName: ingress-cert
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd
```

The Helm chart supports configuring annotations for your ingress provider if needed. The annotations provided above are an example for the Traefik ingress provider.

## Example AWS ALB Controller

If you are using the [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/) the following values are an example of how an ALB might be deployed:

```yaml
ingress:
  enabled: true
  hostname: nautobot.example.com
  pathType: "Prefix"
  annotations:
    kubernetes.io/ingress.class: "alb"
    alb.ingress.kubernetes.io/tags: "Name=nautobot-loadbalancer,Organization=IT"
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    alb.ingress.kubernetes.io/ip-address-type: "dualstack"
    alb.ingress.kubernetes.io/target-type: "ip"
    alb.ingress.kubernetes.io/backend-protocol: "HTTPS"
    alb.ingress.kubernetes.io/healthcheck-protocol: "HTTP"
    alb.ingress.kubernetes.io/healthcheck-port: "8080"
    alb.ingress.kubernetes.io/healthcheck-path: "/health/"
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: "10"
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: "8"
    alb.ingress.kubernetes.io/healthy-threshold-count: "2"
    alb.ingress.kubernetes.io/unhealthy-threshold-count: "2"
    alb.ingress.kubernetes.io/security-groups: "nautobot-alb-sg"
    alb.ingress.kubernetes.io/group.name: "nautobot-loadbalancer"
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:us-west-2:xxxxx:certificate/xxxxxxx"
  extraPaths:
    - path: /
      pathType: Prefix
      backend:
        service:
          name: ssl-redirect
          port:
            name: use-annotation
```

Not all of the annotations are required, please see the AWS Load Balancer Controller [documentation](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/) for more information.
