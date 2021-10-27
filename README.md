# Nautobot Helm Charts
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<!-- [![All Contributors]()](#contributors-) -->
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/nautobot&style=for-the-badge)](https://artifacthub.io/packages/search?repo=nautobot)
<!-- [![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=data:image/svg+xml;base64,)](https://github.com/renovatebot/renovate) -->

This repo is intented to house [Helm](https://helm.sh/) charts for the Nautobot project, today there is one Nautobot chart but we are ready for more if the need arises.  Helm is the unofficial package manager for Kubernetes, it provides a simple way for users to deploy applications to Kubernetes without defining custom Kubernetes manifests.  This allows users of all experience levels to deploy applications the way the developers intend for them to be deployed.  Helm is capable of also providing restrictions and tests to validate the deployment configuration.

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

* **Documentation**: See the [Nautobot chart README](./charts/nautobot/README.md).
* **Slack**: checkout the **#nautobot** channel on the [Network to Code slack](https://networktocode.slack.com/)!

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)

## Releases

See the [Release Checklist](./docs/release-checklist.md)

## License

[Apache 2.0 License](./LICENSE.txt)
