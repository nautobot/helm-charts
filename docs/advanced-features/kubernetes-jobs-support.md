# Kubernetes Jobs Support

This Helm Chart supports using Kubernetes jobs to execute Nautobot jobs. This
approach is an alternative to always-on Celery workers, where Celery Pods run
continuously and pick up Nautobot jobs from task queues. In contrast, Kubernetes
Jobs are created on demand when a Nautobot job is started.

You can read more about Kubernetes Jobs in the [Nautobot documentation](https://docs.nautobot.com/projects/core/en/stable/user-guide/platform-functionality/jobs/kubernetes-job-support/).

> **Note:** Support for reading Kubernetes job manifests from a file system is
> required. Consult the Nautobot documentation for more information.

## How is Support for Kubernetes Jobs Implemented

Each Nautobot job has one or more associated job queues. A job queue defines
the configuration for executing Nautobot jobs. In traditional Celery-based
deployments, each Celery worker defines one or more task queues. When you add
a job to a specific job queue, one of the workers that has this task queue
configured will pick up and execute the job.

The pattern changes when Kubernetes jobs are used to execute Nautobot jobs. The
job queue is no longer associated with a task queue on a Celery worker. Instead,
the job queue has a Kubernetes job manifest associated with it. There is
a one-to-one mapping between a job queue and a Kubernetes job manifest, which
means that each job queue configured in Nautobot requires a dedicated Kubernetes
job manifest.

Before Nautobot can execute a job, it must first load the Kubernetes job manifest.
Nautobot retrieves manifests from the file system. All manifests must be stored in
a single base directory, with one directory for each configured job queue.
The directory name must match the job queue name configured in Nautobot. Nautobot
supports Kubernetes job manifests in JSON format. The file name must be
`manifest.json` and must contain the Kubernetes job manifest.

The following is an example of the directory structure:

```shell
.
├── alpha
│   └── manifest.json
└── beta
    └── manifest.json
```

The manifest is not stored in memory, so there is no requirement to have all
manifests present at startup. Nautobot reads the manifest when a Nautobot job
is executed.

This Helm Chart generates manifests for you. There will be one Kubernetes job
manifest for every job queue that you enable in `values.yaml`. The default
location is `/etc/nautobot/job-queues`, which is defined by the
`nautobot.jobsManifestsMountPath` attribute.

## How to Configure Job Queues

The `values.yaml` file contains the `kubernetesJobs` section, where all
default values for your job manifests are defined. Any setting defined here
is applied to all job manifests. For example, if you want to inject an extra
environment variable into your jobs, define this new variable in the
`kubernetesJobs` section.

```yaml
kubernetesJobs:
  extraEnvVars:
    - name: "ENVIRONMENT"
      value: "development"
```

The environment variable `ENVIRONMENT` that is configured in the example above
will be applied to all Kubernetes jobs.

Specific job queues are enabled or disabled in the `workers` section. This
section contains a map of workers defined in your environment. Each worker must
have a unique name, which can consist of alphanumeric characters.

To define a job queue, you must set two values:

* `workers.<worker name>.enable: true`
* `workers.<worker name>.type: "kubernetes"`

> **Note:** The `type` defines the job queue type. The default value is `celery`,
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
them in the location specified by the `nautobot.jobsManifestsMountPath`
attribute:

```shell
nautobot@nautobot-default:~$ ls /etc/nautobot/job-queues/
alpha  beta
```

Each worker above inherits settings from the `kubernetesJobs` section.
If you want to override any of those settings, you can define them under your
worker configuration.

```yaml
kubernetesJobs:
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

> **Note:** When you override a list, it will override the entire list and not
> merge entries. You must duplicate the entries if you need to keep some of the
> entries from the global `kubernetesJobs` configuration.

## Additional Notes

### Celery Workers

This Helm Chart supports mixing Celery workers and using Kubernetes jobs for
Nautobot jobs. If you only use one approach, it makes sense to disable the other.
This Helm Chart enables Celery workers by default. Therefore, if you only use
Kubernetes jobs, you should disable Celery workers. The following snippet shows
the configuration needed to disable Celery workers:

```yaml
workers:
  default:
    enabled: false
```

!!! note
    Scheduled jobs will still require the Celery Beat worker (`workers.beat`) at this time.

### Kubernetes Service Account Usage

The Nautobot service account requires additional Kubernetes permissions to
create Kubernetes jobs. The Helm Chart supports creating a new `Role` and a new
`RoleBinding` in the namespace. These two Kubernetes objects allow Nautobot to
query the Kubernetes API to read, list, and create Kubernetes jobs. The following
snippet shows how to configure these permissions for your service account:

```yaml
serviceAccount:
  roles:
    jobCreator:
      create: true
```

By default, this Helm Chart associates the same service account used for Nautobot
with Kubernetes job manifests. As discussed above, the service account requires
permissions to create new Kubernetes jobs. Since the same service account is used
for Kubernetes jobs by default, your job will have permissions to create new
Kubernetes jobs (job chaining). Some use cases require this setting. For example
your job spins a separate job for each device you want to configure.

If you don't need to spin up new jobs from the parent job, then it is better to
prevent it. You will need a dedicated service account for Kubernetes jobs in
this case. The following example shows how to configure this:

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

> **Note:** If your Kubernetes job needs to query the Kubernetes API (for example, to
> list pods in the namespace), you must create additional `Role` and
> `RoleBinding` objects for this new service account. However, this will not be
> required in most use cases.

For more information and customization options for the ServiceAccount roles, see
[RBAC Roles and RoleBindings](rbac-roles.md).
