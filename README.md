# Notice

**WARNING** This repo is still in alpha state!

**NOTE!!** Due to the nature of the Nautobot GitHub organization and Private repositories, GitHub pages is unavailable.  Therefore the helm repo is not available directly.  This will be fixed when we go public, for now:

```
git clone git@github.com:nautobot/helm-charts.git
cd helm-charts/charts
helm install nautobot nautobot
```

# Nautobot Helm Charts
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<!-- [![All Contributors]()](#contributors-) -->
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
<!-- [![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=data:image/svg+xml;base64,)](https://github.com/renovatebot/renovate) -->
<!-- [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/nautobot&style=for-the-badge)](https://artifacthub.io/packages/search?repo=nautobot) -->


This repo is intented to house helm charts for the Nautobot project.  (Yes, today that is only the Nautobot chart, but we are ready for more)  Each chart in this repo uses [helm-docs](https://github.com/norwoodj/helm-docs) to generate the README.md for the individual charts.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add nautobot https://nautobot.github.io/helm-charts/
```

You can then run `helm search repo nautobot` to see the charts.

To install a chart from the nautobot repo run:

```console
helm install {Release Name} {Repo Name}/{Chart Name}
```

for example:

```console
helm install nautobot nautobot/nautobot
```

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
Helm value validation
