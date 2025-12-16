# Openshift Tips

## Values File Customizations

In order to run the Nautobot helm chart on OpenShift there are a few considerations to take into account.

A service account is required. Add this snippet to your values.yaml file and modify for your needs:

```yaml
serviceAccount:
  create: true
  name: "nautobot"
  automountServiceAccountToken: true
```

Also, adjust security contexts for redis:

```yaml
redis:
  global:
    compatibility:
        openshift:
            adaptSecurityContext: "auto"
```

Disable security contexts for nautobot, beat, and workers. Add this section under `workers.beat`, `workers.default`, `nautobots.default` and `nautobot`. It may not be suitable to completely disable security contexts in your enviornment. See the [kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for further information on how to configure it implicitly. 

```yaml
workers:
  beat:
    podSecurityContext:
      enabled: false
    containerSecurityContext:
      enabled: false
  default:
    podSecurityContext:
      enabled: false
    containerSecurityContext:
      enabled: false
etc....
```

## Container Permissions

Create a script file called `fix-permissions` and save it in the root of your project. 

```bash
#!/bin/sh
# Fix permissions on the given directory to allow owner/group read/write of
# regular files and execute of directories.
# Note: Openshift uses random UIDs for running apps. Thus we need to grant
#       some world-writable perms :(
chgrp -R 0 $1
chmod -R og+rw $1
find $1 -type d -exec chmod g+x {} +
```

Modify the `Dockerfile` to modify permission inside the container image on build. 


Add this in the `Final Image` section of the Dockerfile. You may need to adjust this somewhat depending on your exact setup. For example if you are not using prometheus metrics you don't need to include the lines for the /tmp/prometheus or /tmp/matplotlib folders. 

```shell
# copy some useful container scripts
COPY ./fix-permissions /usr/local/bin/fix-permissions
RUN chmod +x /usr/local/bin/fix-permissions

# Create necessary directories and set permissions
RUN mkdir -p /tmp/prometheus/ /prom_cache/ /opt/nautobot /tmp/matplotlib

# Set permissions for OpenShift
RUN chown -R nautobot:0 /opt/nautobot && fix-permissions /opt/nautobot && \
    chown -R nautobot:0 /tmp/prometheus && fix-permissions /tmp/prometheus && \
    chown -R nautobot:0 /prom_cache && fix-permissions /prom_cache && \
    chown -R nautobot:0 /tmp/matplotlib && fix-permissions /tmp/matplotlib
```
