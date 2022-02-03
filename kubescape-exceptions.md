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
