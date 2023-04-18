# Custom `uwsgi.ini`

To replace the entire `uwsgi.ini` file with a custom file use the `nautobot.uWSGIini` value.  For example, if your custom `uwsgi.ini` file is located at `./path/to/uwsgi.ini` with other helm values in `./my_values.yaml` you can install the chart using:

```no-highlight
helm install nautobot nautobot/nautobot -f ./my_values.yaml --set-file nautobot.uWSGIini=./path/to/uwsgi.ini
```
