# Contributing

This section describes how to install Nautobot *helm-charts* for development, how to run tests, and make sure you are a good contributor.

## Branches

- `main` - Reserved for current release
- `develop` - Ready to release code, bases for new PRs
- `gh-pages` - Reserved to host the chart repository using GitHub Pages
- `<feature>` - Individual feature branches, should be PR'd to `develop`.

## Versioning

This project utilizes [Semver](https://semver.org/) versioning. As part of PRs the maintainers should carefully increment version numbers in each chart's respective `Chart.yaml`.

## Installing dependencies for local development

The following dependencies are required for development, their installation is outside the scope of this document.

* [Kubernetes](https://kubernetes.io/)/[Minikube](https://minikube.sigs.k8s.io/docs/start/) Obviously for testing you will need a Kubernetes cluster, any cluster will do, for local development minikube is suggested as the official Kubernetes
* [Helm 3](https://helm.sh/docs/intro/install/)
* [Pre-commit](https://pre-commit.com/)
* [Helm Docs](https://github.com/norwoodj/helm-docs) >= v1.6.0

## Running tests locally

### Linting

Pre-commit is used to run helm tests locally:

```shell
pre-commit run -a
```

Pre-commit will also use `helm lint` to validate the schema of the `values.yaml` file based on the [JSON schema](https://json-schema.org/) in `values.schema.json`.  The JSON schema is also validated at runtime when a user attempts to deploy the chart.

### Helm tests

Coming soon...
