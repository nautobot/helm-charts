# Nautobot as a Subchart

When using Nautobot as a subchart make sure to include the following in your Chart.yaml:

```yaml
dependencies:
  - condition: "nautobot.enabled"
    name: "nautobot"
    repository: "https://nautobot.github.io/helm-charts/"
    version: "2.x.x"
```

The `global` values will be shared between the parent and child charts.  Nautobot can be enabled by setting `nautobot.enabled` to `true`.  Other Nautobot settings would then be found under the `nautobot` key in your parent chart's yaml file.  For more information on subcharts checkout the [helm documentation](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/).
