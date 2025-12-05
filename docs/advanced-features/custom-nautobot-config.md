# Custom `nautobot_config.py`

To replace the entire `nautobot_config.py` configuration file with a custom file
use the `nautobot.config` value.  For example, if your custom `nautobot_config.py`
file is located at `./path/to/nautobot_config.py` with other helm values in
`./my_values.yaml` you can install the chart using:

```no-highlight
helm install nautobot nautobot/nautobot \
  -f ./my_values.yaml \
  --set-file nautobot.config=./path/to/nautobot_config.py
```

This will set the inline value `nautobot.config`.

In some scenarios, you want to have your `nautobot_config.py` stored in a `ConfigMap`.
In those cases you can set the `nautobot.configCM` parameter, where you specify
the name of the `ConfigMap`. Please note that the `ConfigMap` must have the key
`nautobot_config.py` where the configuration is stored.

Use the following commands:

```no-highlight
kubectl create configmap nautobot-config-custom \
  --from-file=nautobot_config.py=./path/to/nautobot_config.py
```

```no-highlight
helm install nautobot nautobot/nautobot \
  -f ./my_values.yaml \
  --set nautobot.configCM=nautobot-config-custom
```

Note, that `nautobot.config` takes precedence over `nautobot.configCM`.
