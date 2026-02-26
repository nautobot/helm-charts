# Kubernetes Jobs Support

This Helm Chart has direct support for using Kubernetes Jobs for executing
Nautobot Jobs. This approach is alternative to always-on Celery workers, where
Celery Pods are constantly running and they pick up Nautobot jobs from the
task queue. On the other side, the Kubernetes Jobs are created on demand.

You can read more on Kubernetes Jobs in the [Nautobot documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/platform-functionality/jobs/kubernetes-job-support/#nautobot_kubernetes_job_manifest).

> Note, that this Helm Chart requires Nautobot version `3.1`.

## How is the Support for Kubernetes Jobs Implemented

Before Nautobot can run a Job as a Kubernetes Job, it requires a Job manifest.
There is one-to-one mapping between a Job Queue and a Kubernetes Job manifest,
which means that each Job Queue, configured in Nautobot, requires a dedicated
Kubernetes Job manifest.

Nautobot gets manifests from the file system. All manifests must be stored in
a single base directory. There should be one directory for each Job Queue. The
directory contains the `manifest.json` or `manifest.yaml` which contains the
Kubernetes Job manifest.

The following is an example of the directory structure:

```
.
├── alpha
│   └── manifest.json
└── beta
    └── manifest.json
```

The manifest is not stored in memory, so there is no requirement to have all the
manifests present at startup. Nautobot reads the manifest when a Nautobot job is
executed.

This Helm Chart generates manifests for you. There will be one Job manifest for
every Job Queue that you enable in `values.yaml`. The default location is
`/etc/nautobot/job-queues`, which is defined with the `kubernetes.jobsManifestsMountPath`
attribute.

## How to Configure Job Queues

The `values.yaml` contains the section `kubernetes.defaults`, where all the
default values for your Jobs are defined. Any setting defined here, is applied
to all Kubernetes Jobs. For example, you want to inject an extra environmental
variable to your Jobs, define this new variable in the `kubernetes.defaults`
section.

```yaml
kubernetes:
  defaults:
    extraEnvVars:
      - name: "ENVIRONMENT"
        value: "development"
```

The environmental variable `ENVIRONMENT` will be applied to all of the Kubernetes
Jobs.

The specific Job Queues are enabled or disabled in the `workers` section. This
section contains a map of workers that are defined in your environment. Each
worker must have a unique name, which can contain alphanumeric symbols.

To define a Kubernetes worker job, you must set two values:

* `workers.<worker name>.enable: true`
* `workers.<worker name>.type: "kubernetes"`

> Note: The `type` defines the worker type. The default value is `celery`, which makes this Helm Chart backward compatible.

The following is an example of how you would enable two different Job Queues:

```yaml
workers:
  alpha:
    enabled: true
    type: "kubernetes"
  beta:
    enabled: true
    type: "kubernetes"
```

Using the configuration above, the Helm Chart generates two manifests and store
them to the location provided with the `kubernetes.jobsManifestsMountPath`
attribute:

```shell
nautobot@nautobot-default:~$ ls -al /etc/nautobot/job-queues/
total 16
drwxr-xr-x 4 root root 4096 Feb 26 07:50 .
drwxr-xr-x 3 root root 4096 Feb 26 07:50 ..
drwxr-xr-x 2 root root 4096 Feb 26 07:50 alpha
drwxr-xr-x 2 root root 4096 Feb 26 07:50 beta
```

Each worker above, inherits settings from the `kubernetes.defaults` section.
If you want to override any of those settings you can define them under your
worker configuration.

```yaml
kubernetes:
  defaults:
    extraEnvVars:
      - name: "ENVIRONMENT"
        value: "development"

workers:
  alpha:
    enabled: true
    type: "kubernetes"
    extraEnvVars:
      - name: "ENVIRONMENT"
        value: "production"
  beta:
    enabled: true
    type: "kubernetes"
```