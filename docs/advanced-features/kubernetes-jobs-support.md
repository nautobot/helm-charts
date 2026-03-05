# Kubernetes Jobs Support

This Helm Chart has support for using Kubernetes jobs for executing
Nautobot jobs. This approach is an alternative to always-on Celery workers, where
Celery Pods are constantly running and they pick up Nautobot jobs from the
task queue. On the other hand, the Kubernetes Jobs are created on demand when
a Nautobot job is started.

You can read more on Kubernetes Jobs in the [Nautobot documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/platform-functionality/jobs/kubernetes-job-support/).

> Note, that support for reading Kubernetes job manifests from a file system is
> required. Consult the Nautobot docs for more info.

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

The environment variable `ENVIRONMENT` that is configured in the example above,
will be applied to all of the Kubernetes jobs.

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

### Celery Workers

This Helm Chart supports mixing Celery workers and using Kubernetes jobs for
Nautobot jobs. If you only use one approach it makes sense to disable the other.
This Helm Chart enables Celery workers by default. So, if you only use Kubernetes
jobs, you should disable Celery workers. The following snippet shows configuration
to disable Celery workers:

```yaml
workers:
  default:
    enabled: false
```

!!! note
    Scheduled jobs will still require the Celery Beat worker (`workers.beat`) at this time.

### Kubernetes Service Account Usage

The Nautobot service account requires additional Kubernetes permissions to be
able to spin up Kubernetes jobs. The Helm Chart supports creating a new `Role`
and a new `RoleBinding` in the namespace. These two Kubernetes objects allow
Nautobot to query the Kubernetes API to read, list, and create Kubernetes jobs.
The following is the snippet that shows how to configure these permissions for
your service account:

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
```

By default, this Helm Chart associates the same service account as used for
Nautobot to Kubernetes job manifests. As discussed above, the service account
requires permissions to spin up new Kubernetes jobs. Since the same service
account is used for Kubernetes jobs by default, it means that your job will have
permissions to spin up new Kubernetes jobs (job chaining). Some use cases
requires this settings as new Kubernetes jobs are created from the parent job.
If this use case is not something you use in your environment, it is better to
prevent creating additional Kubernetes jobs from the parent job. You will need
a dedicated service account for Kubernetes jobs in this case. The following
example shows how to do that:

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

> If your Kubernetes job needs to query the Kubernetes API (for example, if you
> need to list pods in the namespace), you must create additional `Role` and
> `RoleBinding` objects for this new service account. However, this will not be
> required in most use cases.


For more information and customization options for the ServiceAccount roles, see
[RBAC Roles and RoleBindings](rbac-roles.md).
