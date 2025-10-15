# Testing

Additional help is needed to develop a proper testing framework of the charts.

## Syntax Linting

This project is [pre-commit](https://pre-commit.com/) enabled, please make sure to run pre-commit tests before committing to the repo.

## Linting Templates

It is possible to do some basic linting with an existing set of `linter_values*.yaml` files.  These files have the following purposes to simulate various deployment methods:

* `linter_values_minimum.yaml` - This file is intended to test the bare-minimum default values.
* `linter_values.yaml` - This file is intended to test as much as possible of the templates, if it can be added/deployed it should be in this file.

We really should run functional testing with these templates but they require various levels of system resources which makes this impractical on a developer laptop.

## Unittesting

The repository support Helm unittesting using the `helm-unittest` library (https://github.com/helm-unittest/helm-unittest). Follow the installation docs to install the plugin.

After the plugin is installed you can run `helm unittest charts/nautobot` command to execute tests. The following snippet show an example:

```
### Chart [ nautobot ] charts/nautobot

 PASS  Test Nautobot K8s Deployment     charts/nautobot/tests/nautobot_deployment_test.yaml

Charts:      1 passed, 1 total
Test Suites: 1 passed, 1 total
Tests:       8 passed, 8 total
Snapshot:    0 passed, 0 total
Time:        6.864226708s
```

> Note: The tests are still in development and will be slowly added for majority of templates.


## Functional Testing

Deploy it in [minikube](/development/local-dev) and test... yes this needs some work.

## Security Testing

We use [kubescape](https://github.com/kubescape/kubescape) in the CI pipeline to test for various security best practice patterns in the helm deployment against the above mentioned linter values files.  As well as [Snyk](https://snyk.io/).  You can test `kubescape` locally with:

```no-highlight
helm template -n testing -f charts/nautobot/linter_values_minimum.yaml -f charts/nautobot/linter_values.yaml charts/nautobot | kubescape scan framework nsa - --fail-threshold 0 --exceptions ./kubescape-exceptions.json
```

We test with 3 frameworks: `nsa`, `mitre`, and `armobest`

We are also working towards implementing [checkov](https://www.checkov.io/) ([GitHub](https://github.com/bridgecrewio/checkov)) tests, these can be run locally with:

```no-highlight
checkov --directory charts/nautobot --skip-path "charts/nautobot/linter_values.*.yaml" --var-file charts/nautobot/linter_values_minimum.yaml --var-file charts/nautobot/linter_values.yaml --framework helm
```

## Per-Deployment Testing

Helm provides the capability of [running tests in each deployment](https://helm.sh/docs/topics/chart_tests/).  This is something for us to explorer in much more detail in the future.  Today we have a fairly simple curl to ensure the web service is up.
