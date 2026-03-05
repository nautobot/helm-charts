# Kubernetes Jobs Support

This Helm Chart has support for using Kubernetes jobs for executing
Nautobot jobs. This approach is an alternative to always-on Celery workers, where
Celery Pods are constantly running and they pick up Nautobot jobs from the
task queue. On the other hand, the Kubernetes Jobs are created on demand when
a Nautobot job is started.

You can read more on Kubernetes Jobs in the [Nautobot documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/platform-functionality/jobs/kubernetes-job-support/).

> Note, that this Helm Chart requires Nautobot version `3.1`.

## How is Support for Kubernetes Jobs Implemented

Each Nautobot job has one or more associated job queues. A job queue defines
configuration for executing Nautobot jobs. In traditional Celery-based
deployment, each Celery worker defines one or more task queues. If you add
a job to a specific job queue, then one of the workers that has this task
queue configured will pick up and execute a job.

The pattern changes a bit, when Kubernetes jobs are used to execute Nautobot
jobs. The job queue is no longer associated with the task queue on a Celery
worker. The job queue has a Kubernetes job manifest associated with it. There is
one-to-one mapping between a job queue and a Kubernetes job manifest, which
means that each job queue configured in Nautobot requires a dedicated Kubernetes
job manifest.

Before Nautobot can execute a job, it must first load the Kubernetes job manifest.
Nautobot gets manifests from the file system. All manifests must be stored in
a single base directory. There should be one directory for each configured job queue.
The directory name must match the job queue configured in Nautobot. Nautobot
supports Kubernetes job manifests in JSON format. The file name must
be `manifest.json`. The file must contain the Kubernetes
job manifest.

The following is an example of the directory structure:

```shell
.
├── alpha
│   └── manifest.json
└── beta
    └── manifest.json
```

The manifest is not stored in memory, so there is no requirement to have all the
manifests present at startup. Nautobot reads the manifest when a Nautobot job is
executed.

This Helm Chart generates manifests for you. There will be one Kubernetes job
manifest for every job queue that you enable in `values.yaml`. The default
location is `/etc/nautobot/job-queues`, which is defined with the
`kubernetes.jobsManifestsMountPath` attribute.

## How to Configure Job Queues

The `values.yaml` contains the section `kubernetes.defaults`, where all the
default values for your job manifests are defined. Any setting defined here, is
applied to all job manifests. For example, you want to inject an extra environment
variable to your jobs. Define this new variable in the `kubernetes.defaults`
section.

```yaml
kubernetes:
  defaults:
    extraEnvVars:
      - name: "ENVIRONMENT"
        value: "development"
```

The environment variable `ENVIRONMENT` will be applied to all of the Kubernetes
jobs.

The specific job queues are enabled or disabled in the `workers` section. This
section contains a map of workers that are defined in your environment. Each
worker must have a unique name, which can consist of alphanumeric symbols.

To define a job queue, you must set two values:

* `workers.<worker name>.enable: true`
* `workers.<worker name>.type: "kubernetes"`

> Note: The `type` defines the job queue type. The default value is `celery`,
> which makes this Helm Chart backward compatible.

The following is an example of how you would enable two different job queues:

```yaml
workers:
  alpha:
    enabled: true
    type: "kubernetes"
  beta:
    enabled: true
    type: "kubernetes"
```

Using the configuration above, the Helm Chart generates two manifests and stores
them to the location provided with the `kubernetes.jobsManifestsMountPath`
attribute:

```shell
nautobot@nautobot-default:~$ ls /etc/nautobot/job-queues/
alpha  beta
```

Each worker above inherits settings from the `kubernetes.defaults` section.
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

The Kubernetes job manifest for the job queue `alpha` will contain a definition
for the environment variable `ENVIRONMENT` with the value `production`, while the
definition for the `beta` worker will contain the value `development`.

> Please note that whenever you override the list, it will override the whole list and not merge entries.
> You must duplicate the entries if you need to keep some of the entries from `defaults`.

## Additional Notes

### Kubernetes Service Account Usage

The template will associate the same service account to the job manifests as
used for the Nautobot pods by default. This approach allows user to spin up new
K8s jobs from the jobs (job chaining).

This pattern is not always desirable. To prevent those use cases, you have to
create a dedicated service account for Kubernetes jobs and then specify the
the service account name in the configuration for your worker. The following
examples shows one way of doing this:

```yaml
workers:
  alpha:
    serviceAccountName: nautobot-jobs

extraObjects:
  - apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: nautobot-jobs
```



TODO:

# Using Kubernetes Jobs in Nautobot

If you want to run your Nautobot jobs via Kubernetes Jobs instead of using the Nautobot Celery workers, here are the steps to configure your Nautobot deployment.

## (Optional) Disable the Default Celery Worker

If you want to disable the default Celery worker, you can set the `workers.default.enabled` value to `false`.

```yaml
workers:
  default:
    enabled: false
```

!!! note
    Scheduled jobs will still require the Celery Beat worker (`workers.beat`) at this time.

## Add the ServiceAccount Configuration

Here is the recommended configuration for the ServiceAccount that is needed to run Kubernetes Jobs:

```yaml
serviceAccount:
  automountServiceAccountToken: true
  roles:
    jobCreator:
      create: true
```

For more information and customization options for the ServiceAccount roles, see [RBAC Roles and RoleBindings](rbac-roles.md).
