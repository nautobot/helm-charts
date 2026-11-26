# Contributing

This section describes how to install Nautobot *helm-charts* for development, how to run tests and make sure you are a good contributor.

## Branches

* `main` - Reserved for the current release
* `develop` - Ready to release code, bases for new PRs, typically the next minor or patch release
* `next` - Reserved for development of the next major release
* `gh-pages` - Reserved to host the chart repository using GitHub Pages
* `<feature>` - Individual feature branches, should be PR'd to `develop`.

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
pre-commit run -av
```

In some cases, such as documentation updates pre-commit will actually make the docs changes for you so it's possible to run the command above 1 time, it will fail because an update was necessary, but on subsequent runs, it will succeed.

Before pushing any code the pre-commit tests should all pass locally, these tests will again be run by the CI process and will prevent CI from succeeding.

### Linting

Pre-commit runs several [built-in hooks](https://pre-commit.com/hooks.html) for linting tasks such as:

* `check-case-conflict` - Check for files that would conflict in case-insensitive file systems.
* `check-json` - This hook checks json files for parsable syntax.
* `check-yaml` - This hook checks yaml files for parsable syntax.
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

* [`helm_lint`](https://helm.sh/docs/helm/helm_lint/) - Performs basic helm linting as well as [schema validation](https://json-schema.org/) with `values.schema.json`.  The JSON schema is also validated at runtime when a user attempts to deploy the chart.
* [`yamllint`](https://github.com/adrienverge/yamllint) - Runs `yamllint` based on the `.yamllint` configuration in the root of the repo.
* <!-- cspell:disable-line -->[`markdownlint`](https://github.com/markdownlint/markdownlint) - Checks all *.md files for common markdown mistakes based on the `.mdlrc` and `.mdl.rb` files
* [`cspell`](https://github.com/streetsidesoftware/cspell-cli) - Spell Checking uses a local dictionary `cSpell_dict.txt`

To run a single check from the above list run:

```no-highlight
pre-commit run -av {check name}
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

To update the README.md files for a chart you can run `invoke update-docs`. Add `--local` to run it locally (`helm-docs` must be installed).

```no-highlight
invoke update-docs
```

or using pre-commit:

```no-highlight
pre-commit run -av helm-docs
```

The [official docs site](https://docs.nautobot.com/projects/helm-charts/en/stable) is built using mkdocs from the `/docs` folder in the root of the repo.  To preview the docs you can run:

```no-highlight
invoke docs
```

or if you don't have `invoke` installed simply run:

```no-highlight
mkdocs serve -v
```

## Values Schema

Helm validates the chart values against `charts/nautobot/values.schema.json`. This file is generated, do not edit it.

* `charts/nautobot/schema/values.schema.json` - The source, edit this file. It references the Kubernetes types with a `$ref` to the [kubernetes-json-schema](https://github.com/yannh/kubernetes-json-schema) repository.
* `charts/nautobot/values.schema.json` - The built schema. It is a copy of the source with every Kubernetes `$ref` replaced by an inline copy in `$defs`. Helm would otherwise download each `$ref` on every command, which fails without internet access.

To change the schema:

1. Edit `charts/nautobot/schema/values.schema.json`.
2. Open a PR. The `Update Schema` workflow builds `charts/nautobot/values.schema.json` and commits it to the PR branch.
3. Run `git pull` before you push again.

The other CI checks do not run again on the commit made by the workflow. If the linter values or the unit tests use a value that you added to the schema, build the schema yourself and commit both files:

```no-highlight
invoke update-schema
```

The task needs internet access. Also run it yourself when the PR comes from a fork. The workflow cannot push to a fork, so it fails and shows the command to run in the job summary.

### Kubernetes Types

To validate a value against a Kubernetes type, reference its schema in the source file:

```json
"affinity": {
  "$ref": "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.35.10-standalone-strict/affinity.json"
}
```

* Use the same Kubernetes version as the other references.
* The `<version>-standalone-strict` folders reject unknown fields, the `<version>` folders accept them.
* The build fails on a `$ref` to any other URL.

Renovate tracks the Kubernetes version and every 3 months opens a PR that updates all references. A new version can change which values are valid, so review the diff of the built schema in that PR.
