# Notice

**WARNING** This repo is still in alpha state!

# Nautobot Helm Charts

This repo is intented to house helm charts for the Nautobot project.  (Yes, today that is only the Nautobot chart, but we are ready for more)  Each chart in this repo uses [helm-docs](https://github.com/norwoodj/helm-docs) to generate the README.md for the individual charts.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add nautobot https://networktocode-llc.github.io/helm-charts/
```

You can then run `helm search repo nautobot` to see the charts.

## Support

* **Documentation**: Eventually we may have additional documentation on [Read the Docs](https://readthedocs.org/), for now we just have the READMEs.
* **Slack**: checkout the **#nautobot** channel on the [Network to Code slack](https://networktocode.slack.com/)!

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)
## License

[Apache 2.0 License](./LICENSE.txt)

## TODO Before Release
Testing
Linting / Pre-commit
GH Actions Publish Release
GH Actions Update Docs
Auto create admin account
document getting started steps
Enable Monitoring

## TODO Later
Provide method to update nautobot_config.py
Provide method to update uwsgi.ini
Automated testing
Handle Nautobot Media
Allow adding plugins
