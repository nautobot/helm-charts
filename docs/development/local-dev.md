# Local Development

This page describes deploying the Nautobot Helm Chart locally on a MacOS (amd64) system running in [minikube](https://minikube.sigs.k8s.io/docs/start/) and is intended only for testing and development purposes.

## Install and Configure minikube

### Install minikube

```no-highlight
brew install minikube
```

### Configure minikube

```no-highlight
minikube config set driver hyperkit
minikube config set container-runtime containerd
```

### Start minikube

These settings are here simply to demonstrate how to change them, they are not requirements.

```no-highlight
minikube start --memory=4G --cpus=4 --disk-size 10000mb --extra-config=apiserver.service-node-port-range=80-32767
```

### Running minikube Config

1. NTP Tends to be an issue with minikube and hyperkit the easiest solution is to provide hosts entries for `time[1-4].google.com` be sure to replace the IP with a valid NTP server

```no-highlight
minikube ssh -- "echo {IP of a valid NTP server} time1.google.com time2.google.com time3.google.com time4.google.com | sudo tee -a /etc/hosts"
minikube ssh sudo systemctl restart systemd-timesyncd
```

#### Configure Minikube DNS

This will configure your MacOS DNS resolver to point `minikube.local` to the minikube VM for DNS resolution.

```no-highlight
minikube addons enable ingress
minikube addons enable ingress-dns
sudo mkdir -p /etc/resolver
sudo tee /etc/resolver/minikube > /dev/null <<EOT
domain minikube.local
nameserver $(minikube ip)
search_order 1
timeout 5
EOT
```

### Install Nautobot

Checkout the `contrib` folder for several example `values.yaml` files for deployment, this basic one deploys a single Nautobot pod with a single worker with DEBUG enabled.  After several minutes once all pods are running, you should be able to open a browser to `http://nautobot.minikube.local/` or `https://nautobot.minikube.local/` (invalid certificate) and log in with the username `admin` and password `admin`.

```no-highlight
helm install nautobot charts/nautobot -f contrib/minikube.yaml
```

## Optional Dependencies

### Prometheus Operator

This will install the [`kube-prometheus-stack`](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) chart with default values.

!!! note
    The `kube-prometheus-stack` requires a fair amount of resources to run locally

```no-highlight
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack -f contrib/kube-stack-prometheus.yaml
helm upgrade nautobot charts/nautobot -f contrib/minikube-with-metrics.yaml
```

Using the predefined values file the following endpoints will be available:

* `http://grafana.minikube.local` (username: `admin` password: `admin`)
* `http://prometheus.minikube.local`
* `http://alertmanager.minikube.local`

### Cert-Manager

The following will install `cert-manager`, configure a CA, issue certificates, and trust the CA locally on your system

```no-highlight
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --set installCRDs=true
```

TODO Document self signed certs

### Metrics Server

```no-highlight
minikube addons enable metrics-server
```
