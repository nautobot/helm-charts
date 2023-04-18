# Custom `nautobot_config.py`

To replace the entire `nautobot_config.py` configuration file with a custom file use the `nautobot.config` value.  For example, if your custom `nautobot_config.py` file is located at `./path/to/nautobot_config.py` with other helm values in `./my_values.yaml` you can install the chart using:

```no-highlight
helm install nautobot nautobot/nautobot -f ./my_values.yaml --set-file nautobot.config=./path/to/nautobot_config.py
```
