# Kubernetes Gateway API

The chart manages route either by also creating a `Gateway`, or attaching them to an existing one. Set `route.enabled` equal to `true` to create the route, and `gateway.enabled` to `true` if you also want the chart to create the `Gateway`.

## Attaching to an existing Gateway

When you manage the `Gateway` yourself, leave `gateway.enabled` as `false` and point `route.parentRefs` at it:

```yaml
route:
  enabled: true
  parentRefs:
    - name: "example-gateway"
      namespace: "example-namespace"
      sectionName: "https"

gateway:
  enabled: false
```

## Encryption options

The chart supports different options of delivering traffic based on the Gateway API's TLS patterns. The `route.tls` block guides how traffic is encrypted: `enabled` turns the TLS listener on, and `mode` maps directly onto the Gateway API [TLSModeType](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.TLSModeType). The route kind is decided automatically based on the mode, because only a `TLSRoute` can attach to a `Passthrough` listener.

| Mode | `tls.enabled` | `tls.mode` | Client to Gateway | Gateway to Pod | Resources created |
| ---- | ------------- | ---------- | ----------------- | -------------- | ----------------- |
| Unencrypted | `false` | n/a | HTTP | HTTP | `HTTP` listener, `HTTPRoute` |
| TLS termination | `true` | `Terminate` | HTTPS | HTTP | `HTTPS` listener, `HTTPRoute` |
| End-to-end TLS | `true` | `Passthrough` | HTTPS | HTTPS | `TLS` listener, `TLSRoute` |

### Unencrypted

The Gateway and the backend service serve HTTP only on port 80, and the traffic is forwarded as plaintext. This is suitable for testing purposes.

```yaml
route:
  enabled: true
  hostname: "nautobot.local"
  tls:
    enabled: false

gateway:
  enabled: true
  gatewayClassName: "nginx"
```

### TLS termination on the Gateway

In this setup the Gateway decrypts the request, and forwards it to Nautobot over plain HTTP inside the cluster.

The certificate can be supplied by name through `route.tls.secretName` value as an existing k8s secret of type `kubernetes.io/tls`. Providing certificate is optional, you can leave it empty and no `certificateRefs` are rendered on the listener, which may be wanted if the Gateway controller supplies it (e.g a default wildcard certificate configured on the `GatewayClass`).

```yaml
route:
  enabled: true
  hostname: "nautobot.local"
  tls:
    enabled: true
    mode: "Terminate"
    secretName: "nautobot-gateway-tls"

gateway:
  enabled: true
  gatewayClassName: "nginx"
```

Because the Gateway can read the decrypted request in this mode, `route.pathMatchType`, `route.filters`, and `route.extraRules` all apply.

### End-to-end TLS encryption

Set `route.tls.mode` to `Passthrough` to keep traffic encrypted end-to-end. The chart creates a `TLS` listener and a `TLSRoute` as a backend, so the traffic is not decrypted, but forwarded to the Nautobot pods as is. Specifically the Gateway reads the Server Name Indication [SNI](https://en.wikipedia.org/wiki/Server_Name_Indication) from the TLS handshake, matches it against `route.hostname`, and sends it to the Nautobot service on `service.httpsPort`.

The certificate is therefore presented by the Nautobot pod, not by the Gateway, and the `route.tls.secretName` is unused. See [Existing TLS certificates](../existing-secrets/#existing-tls-certificates) for how to create and make Nautobot serve that certificate.

```yaml
nautobot:
  secret_name_tls: "nautobot-backend-tls"

route:
  enabled: true
  hostname: "nautobot.local"
  tls:
    enabled: true
    mode: "Passthrough"

gateway:
  enabled: true
  gatewayClassName: "nginx"
```

Because the client validates this certificate directly, its subject name must match `route.hostname`. Leaving `nautobot.secret_name_tls` empty falls back to the self-signed certificate in the Nautobot image, which is fine for a quick test but not for production.

### Limitations

A `TLSRoute` routes on SNI alone. The Gateway never sees HTTP, so anything that depends on inspecting the request does not apply:

* `route.filters` and `route.extraRules` are ignored, because they describe HTTP-level routing. Use `route.tls.mode: "Terminate"` if you need them.
* `route.pathMatchType` has no effect, because a `TLSRoute` carries no path matches.
* Only one Nautobot deployment can be served. See [Multiple Nautobot deployments](#multiple-nautobot-deployments).
* HTTP-to-HTTPS redirects must be handled by a separate HTTP listener and `HTTPRoute`.

## Multiple Nautobot deployments

When you run more than one Nautobot deployment you can create `HTTPRoute` resources to serve all of them. Each enabled deployment adds a rule, matching the paths in its own `ingressPaths` and forwarding to its own Service. This mirrors how `Ingress` behaves, and uses the same `ingressPaths` value, to be backwards compatible.

```yaml
nautobots:
  default:
    enabled: true
    ingressPaths:
      - "/"
  api:
    enabled: true
    initNautobot: false
    ingressPaths:
      - "/api"
  static:
    enabled: true
    initNautobot: false
    staticFilesOnly: true
    ingressPaths:
      - "/static"
```

A deployment with `staticFilesOnly` set matches `/static` and its own `ingressPaths` are ignored, again matching the `Ingress` behavior.

!!! warning
    End-to-end TLS cannot be used for multiple deployments because `TLSRoute` selects its backend from the TLS handshake and cannot see the encrypted request path. Use `Terminate` mode for multiple deployments, otherwise release fails at template time instead of leaving the extra deployments unreachable.
