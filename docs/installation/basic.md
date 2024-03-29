# Basic Installation

1. Make sure you meet the [prerequisites](../prerequisites/)
2. Add the Nautobot Helm Repo:

```no-highlight
helm repo add nautobot https://nautobot.github.io/helm-charts/
```

3. Install the Nautobot Chart from the Nautobot repo

!!! note
    The following command with install the chart with the release name `nautobot` (the release name is a label completely up to the user) DB and Redis passwords are required:

```no-highlight
helm install nautobot nautobot/nautobot --set postgresql.auth.password="change-me" --set redis.auth.password="change-me"
```

This command deploys Nautobot, on the Kubernetes cluster, in the default configuration. The [Reference](../../configuration/reference/) section lists the parameters that can be customized during installation.

> **Tip**: List all releases using `helm list`

## Accessing Nautobot

Immediately after install Helm will present the user with help text similar to the following:

```no-highlight
*********************************************************************
*** PLEASE BE PATIENT: Nautobot may take a few minutes to install ***
*********************************************************************

1. Get the Nautobot URL:

  echo "Nautobot URL: http://127.0.0.1:8080/"
  kubectl port-forward --namespace default svc/nautobot 8080:80

2. Get your Nautobot login admin credentials by running:

  echo Username: admin
  echo Password: $(kubectl get secret --namespace default nautobot-env -o jsonpath="{.data.NAUTOBOT_SUPERUSER_PASSWORD}" | base64 --decode)
  echo api-token: $(kubectl get secret --namespace default nautobot-env -o jsonpath="{.data.NAUTOBOT_SUPERUSER_API_TOKEN}" | base64 --decode)
```

This message should include basic information about connecting to Nautobot as well as accessing the superuser credentials if they were created.  Nautobot can take several minutes to deploy,
you will need to wait until that is complete before accessing Nautobot.

After several minutes, by default, a Nautobot super user will be created and you will be able to log in to Nautobot.  The default username is `admin` and the default password
was randomly generated by helm, you can find the password by running the following command:

```no-highlight
kubectl get secret nautobot-env -o jsonpath="{.data.NAUTOBOT_SUPERUSER_PASSWORD}" | base64 --decode
```

## Configure Nautobot Deployment Parameters

When [deploying a helm chart](https://helm.sh/docs/intro/using_helm/) there are several different methods to apply alternate configuration values.  One option is via the command line using the
`--set` argument, however, changing multiple variables becomes tedious, a better approach to changing multiple values is to create a YAML file and add the `--values custom_values.yaml` argument.
Other [examples/recommendations](../../advanced-features/) on this site demonstrate the usage of a custom YAML file to apply these values.  All of the available options are documented in the [reference](../../configuration/reference) section.  For additional examples be sure to check the [advanced features](../../advanced-features/) page.

### Required Settings

The following settings are the bare minimum required values to deploy this chart:

```yaml
postgresql:
  auth:
    password: "change-me"
redis:
  auth:
    password: "change-me"
```

This will deploy a PostgreSQL database and a Redis instance for Nautobot in the same namespace.
