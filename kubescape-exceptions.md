# Kubescape Exceptions

This page is intended to document the exceptions to kubescape testing that have been implemented and
the rationale for these exceptions which are captured in kubescape-exceptions.json.

## Immutable Filesystems

*Name:* ignore-immutable-container-filesystem
*Reference:* [https://hub.armo.cloud/docs/c-0017](https://hub.armo.cloud/docs/c-0017)

These containers currently require rw filesystems for scratch space.

## Resource Limits

*Name:* ignore-resource-policies
*Reference:* [https://hub.armo.cloud/docs/c-0009](https://hub.armo.cloud/docs/c-0009)

Nautobot pods have default requests/limits, however the postgres, mysql, and redis containers do not by default,
these are to be defined by the end user of the chart.

## Credentials

*Name:* ignore-credentials-false-positive
*Reference:* [https://hub.armo.cloud/docs/c-0012](https://hub.armo.cloud/docs/c-0012)

The redis-master and redis-node StatefulSets uses an environment variable called `ALLOW_EMPTY_PASSWORD` which is defined
in the StatefulSet manifest itself, not a secret.  This is flagged because of the key `PASSWORD` even though
the value is `no` and not sensitive.

## Automount Service Account

*Name:* ignore-automount-service-account-false-positive
*Reference:* [https://hub.armo.cloud/docs/c-0034](https://hub.armo.cloud/docs/c-0034)

The service account used by the `mariadb` StatefulSet is `mariadb` and has the `automountServiceAccountToken` set to false.  This is a false finding.

## Allowed Registries

*Name:* ignore-default-registries
*Reference:* [https://hub.armo.cloud/docs/c-0078](https://hub.armo.cloud/docs/c-0078)

Some of these containers are hosted on docker.io

## Pods in default namespace

*Name:* ignore-no-namespace
*Reference:* [https://hub.armo.cloud/docs/c-0061](https://hub.armo.cloud/docs/c-0061)

This is an artifact of using helm to generate the template manifests which are passed to kubescape.  The issue here is helm uses the k8s api to specify a namespace for the manifests outside of the manifests themselves.  There is a lengthy discussion on this [here](https://github.com/helm/helm/issues/5465).

## No Signature Exists

*Name:* ignore-no-signature
*Reference:* [https://hub.armosec.io/docs/c-0237](https://hub.armosec.io/docs/c-0237)

Many containers we deploy are not signed to include Nautobot, there is nothing this helm-chart project can fix.
