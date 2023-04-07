# Testing

Additional help is needed to develop a proper testing framework of the charts.

## Syntax Linting

This project is [pre-commit](https://pre-commit.com/) enabled, please make sure to run pre-commit tests before committing to the repo.

## Linting Templates

It is possible to do some basic linting with an existing set of `linter_values*.yaml` files.  These files have the following purposes to simulate various deployment methods:

* `linter_values.yaml` - This file is intended to test as much as possible of the templates, if it can be added/deployed it should be in this file.
* `linter_values_minimum.yaml` - This file is intended to test the bare-minimum default values.
* `linter_values_mysql.yaml` - This file is intended to test the templates when deploying with mysql.
* `linter_values_postgresql_ha.yaml` - This file is intended to deploy a redis sentinel cluster with postgresql HA.

We really should run functional testing with these templates but they require various levels of system resources which makes this impractical on a developer laptop.

## Functional Testing

Deploy it in [minikube](/development/local-dev) and test... yes this needs some work.

## Security Testing

We use [kubescape](https://github.com/kubescape/kubescape) in the CI pipeline to test for various security best practice patterns in the helm deployment against the above mentioned linter values files.  As well as [Snyk](https://snyk.io/).  You can test `kubescape` locally with:

```no-highlight
helm template -n testing -f charts/nautobot/linter_values.yaml charts/nautobot | kubescape scan framework nsa - --fail-threshold 0 --exceptions ./kubescape-exceptions.json
```

We test with 3 frameworks: `nsa`, `mitre`, and `armobest`

We are also working towards implementing [checkov](https://www.checkov.io/) ([GitHub](https://github.com/bridgecrewio/checkov)) tests, these can be run locally with:

```no-highlight
checkov --directory charts/nautobot --skip-path charts/nautobot/linter_values.*.yaml --var-file charts/nautobot/linter_values.yaml --framework helm
```

## Per-Deployment Testing

Helm provides the capability of [running tests in each deployment](https://helm.sh/docs/topics/chart_tests/).  This is something for us to explorer in much more detail in the future.  Today we have a fairly simple curl to ensure the web service is up.
