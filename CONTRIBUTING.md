# Contributing

This section describes how to install Nautobot *helm-charts* for development, how to run tests and make sure you are a good contributor.

## Branches

- `main` - Reserved for the current release
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

## Local Development

[Pre-commit](https://pre-commit.com/) is used heavily by this project to speed up and standardize development.  Pre-commit will perform linting, docs updates, and testing for you.  To run all checks/tests run:

```no-highlight
$ pre-commit run -av
```

In some cases, such as documentation updates pre-commit will actually make the docs changes for you so it's possible to run the command above 1 time, it will fail because an update was necessary, but on subsequent runs, it will succeed.

Before pushing any code the pre-commit tests should all pass locally, these tests will again be run by the CI process and will prevent CI from succeeding.

### Linting

Pre-commit runs several [built-in hooks](https://pre-commit.com/hooks.html) for linting tasks such as:

* `check-case-conflict` - Check for files that would conflict in case-insensitive filesystems.
* `check-json` - This hook checks json files for parseable syntax.
* `check-yaml` - This hook checks yaml files for parseable syntax.
* `check-merge-conflict` - Check for files that contain merge conflict strings.
* `end-of-file-fixer` - Ensures that a file is either empty or ends with one newline.
* `fix-byte-order-marker` - removes UTF-8 byte order marker.
* `mixed-line-ending` - Replaces or checks mixed line ending.
* `pretty-format-json` - This hook sets a standard for formatting JSON files.
* `trailing-whitespace` - This hook trims trailing whitespace.

Some other [generic linting from Lucas-C](https://github.com/Lucas-C/pre-commit-hooks):

* `remove-crlf` - Removes carriage return followed by a line feed to keep all files in Unix style format.
* `remove-tabs` - Removes tabs to keep all spacing using standard spaces.

Project specific linting includes:

* [`helmlint`](https://helm.sh/docs/helm/helm_lint/) - Performs basic helm linting as well as [schema validation](https://json-schema.org/) with `values.schema.json`.  The JSON schema is also validated at runtime when a user attempts to deploy the chart.
* [`yamllint`](https://github.com/adrienverge/yamllint) - Runs `yamllint` based on the `.yamllint` configuration in the root of the repo.

To run a single check from the above list run:

```no-highlight
$ pre-commit run -av {check name}
```

### Security Scanning

For security scanning we utilize both:

* [Kubescape](https://github.com/armosec/kubescape)
* [Snyk](https://snyk.io/)

These tools can be run locally and are also run as part of the CI pipeline to validate the security posture of the helm charts.

### Helm tests

Coming soon...

## Documentation

Each chart in this repo uses [helm-docs](https://github.com/norwoodj/helm-docs) to generate the README.md for the individual charts.

Pre-commit runs [`helm-docs`](https://github.com/norwoodj/helm-docs), this uses the annotations in `values.yaml` plus the `README.md.gotmpl` to generate the `README.md` documentation for the Helm chart.  This ensures all of the configuration options are documented correctly.

To update the README.md files for a chart you can run `helm-docs` directly or use pre-commit:

```no-highlight
$ helm-docs
```

or

```no-highlight
$ pre-commit run -av helm-docs
```
