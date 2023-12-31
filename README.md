# ddclient docker

This application is forked from [https://github.com/steasdal/ddclient-alpine](https://github.com/steasdal/ddclient-alpine) with heavy modifications.  Namely most of the environment variables have been removed and is now reliant on injecting a configuration file during container creation.  The original files have been preserved for reference under the "Original Files" folder.  

Original ddclient documentation can be located: [ddclient homepage](https://ddclient.net/)

## Usage

Since I run mostly Kubernetes all yaml manifests are designed towards the solution.  However, docker-compose can be adapted as necessary.

Create a config file for the relevant ddns provider of choice.  Examples are located here: [ddclient examples](https://github.com/ddclient/ddclient/blob/master/ddclient.conf.in)

_Note if running in a container "use=web" must be set since the application can not automatically derive the IP address from the internal container network_

**Keep this config file in a secure location that is not easily accessible**

The following environment variables are relevant:
```
- DDNS_DAEMON_OR_ONESHOT - specifies whether to run the application as a daemon or once (oneshot)
- DDNS_DAEMON_REFRESH_INTERVAL - specifies how frequenty the application will run if DDNS_DAEMON_OR_ONESHOT is set to daemon (defaults to 30 seconds if not specified)
```

### Kubernetes

Create a secret based on the above config file since it has sensitive information.

```
kubectl create secret generic -n some-namespace some-secret --from-file=ddclient.conf
```

Use this secret as a volume mount and ensure read-only minimal permissions are provided.  An example deployment manifest is provided in the Kubernetes directory

### Docker

Docker unfortunately does not have a good way of securing secrets unless using docker swarm.  Therefore store the config file on the docker host and expose it via a bind mount that is ro (read only).  Ensure the host directory/file are secured with tight permissions.

```
services:
  <service_name>:
    image: <image_name>
    volumes:
      - <host_directory>:/etc/ddclient/:ro
```