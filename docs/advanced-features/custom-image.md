# Custom Nautobot Image

If you need to build a custom Nautobot image to include additional plugins or a separate `nautobot_config.py` which might be more complicated then injecting the values into this chart you can use the following values:

```yaml
nautobot:
  image:
    registry: "ghcr.io"
    repository: "nautobot/nautobot"
    tag: "1.5.16-py3.10"
    pullPolicy: "Always"
    pullSecrets:
      - ghcr-pull-secret
```
