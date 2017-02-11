---
tag: [ "codenvy" ]
title: Configuration
excerpt: "Techniques for configuring Codenvy"
layout: docs
permalink: /:categories/configuration/
---
{% include base.html %}

## Contents

- TOC
{:toc}

---

Configuration is handledy by modifying `codenvy.env` placed in the host folder volume mounted to `:/data`. This configuration file is generated during the `codenvy init` phase. If you rerun `codenvy init` in an already initialized folder, the process will abort unless you pass `--force`, `--pull`, or `--reinit`.

Each variable is documented with an explanation and usually commented out. If you need to set a variable, uncomment it and configure it with your value. You can then run `codenvy config` to apply this configuration to your system. `codenvy start` also reapplies the latest configuration.

You can run `codenvy init` to install a new configuration into an empty directory. This command uses the `codenvy/init:<version>` Docker container to deliver a version-specific set of puppet templates into the folder.

If you run `codenvy config` Codenvy runs puppet to transform your puppet templates into a Codenvy instance configuration, placing the results into `/codenvy/instance` if you volume mounted that, or into a `instance` subdirectory of the path you mounted to `/codenvy`.  Each time you start Codenvy `codenvy config` is run to ensure instance configuration files are properly generated and consistent with the configuration you have specified in `codenvy.env`.

# Saving Configuration in Version Control
Administration teams that want to version control your Codenvy configuration should save `codenvy.env`. This is the only file that should be saved with version control. It is not necessary, and even discouraged, to save the other files. If you were to perform a `codenvy upgrade` we may replace these files with templates that are specific to the version that is being upgraded. The `codenvy.env` file maintains fidelity between versions and we can generate instance configurations from that.

The version control sequence would be:

1. `codenvy init` to get an initial configuration for a particular version.
2. Edit `codenvy.env` with your environment-specific configuration.
3. Save `codenvy.env` to version control.
4. Setup a new folder and copy `codenvy.env` from version control into the folder you will mount to `:/data`.
5. Run `codenvy config` or `codenvy start`.

# LDAP
You can configure Codenvy to synchronize the user database to your LDAP installation for the purposes of creating user accounts. The [LDAP guide]({{base}}{{site.links["admin-ldap"]}}) has the configuration and examples.

# oAuth Account Creation
By default in Codenvy users create accounts in the system by:

- Self-registering using an email and username
- Using oAuth from Google, GitHub or Microsoft

Optionally you can connect Codenvy to LDAP which will disable self-registration (see the section above) or you can add your own oAuth provider for user account creation by following the steps below.

To enable GitHub oAuth, add `CODENVY_HOST=codenvy.onprem` to `codenvy.env` and restart. If you have a custom DNS, you need to register a GitHub oAuth application with GitHub's oAuth registration service. You will be asked for the callback URL, which is `http://<your_hostname>/api/oauth/callback`. You will receive from GitHub a client ID and secret, which must be added to `codenvy.env`:

```
CODENVY_GITHUB_CLIENT_ID=yourID
CODENVY_GITHUB_SECRET=yourSecret
```

Google oAuth (and others) are configured in the same way:

```
CODENVY_GOOGLE_CLIENT_ID=yourID
CODENVY_GOOGLE_SECRET=yourSecret
```

If you are looking for a way to clone private git projects into your workspace see our [Git and SVN page]({{base}}{{site.links["ide-git-svn"]}}).

# HTTPS
By default Codenvy runs over HTTP as this is simplest to install. There are two requirements for configuring HTTP/S: 

1. You must bind Codenvy to a valid DNS name. The HTTP mode of Codenvy allows us to operate over IP addresses. HTTP/S requires certificates that are bound to a DNS entries that you purchase from a DNS provider.  
2. A valid SSL certificate issued by a *trusted* issuer. Sometimes free certificates will fail given restrictions with JVMs.

To configure HTTP/S, in `codenvy.env`:

```
CODENVY_HOST_PROTOCOL=https
CODENVY_PATH_TO_HAPROXY_SSL_CERTIFICATE=<path-to-certificate>
```

# Workspace Limits
You can place limits on how users interact with the system to control overall system resource usage. You can define how many workspaces created, RAM consumed, idle timeout, and a variety of other parameters. See "Workspace Limits" in `codenvy.env`.

You can also set limits on Docker's allocation of CPU to workspaces, which may be necessary if you have a very dense workspace population where users are competing for limited physical resources.

### Idle Timeout
Workspaces have idle timeouts that stop workspaces that a user has not interacted with in a specified time. The idle timeout is set by the `CODENVY_MACHINE_WS_AGENT_INACTIVE_STOP_TIMEOUT_MS` property in the `codenvy.env` file with a default value of `14400000` milliseconds or 4 hours. This allows Codenvy to to free up unused resources but may need to be increased if longer running workspaces are required.

# Docker
Workspace runtimes are powered by one or more Docker containers. When a user creates a workpace, they do so from a [stack]({{base}}{{site.links["ws-stacks"]}}) which includes a Dockerfile or reference to a Docker image which will be used to create the containers for the workspace runtimes. Stacks can pull that image from a public registry, like DockerHub, or a private registry. Images in a registry can be publicly visible or private, which require user credentials to access. You can also set up a private registry to act as a mirror to Docker Hub.  And, if you are running Codenvy behind a proxy, you can configure the Docker daemon registry to operate behind a proxy.

### Private Images  
When users create a workspace, they must select a Docker image (stack) to power the workspace. We provide ready-to-go stacks which reference images hosted at the public Docker Hub, which do not require any authenticated access to pull. You can provide your own images that are stored in a local private registry or at Docker Hub. The images may be publicly or privately visible, even if they are part of a private registry.

If your stack images that Codenvy wants to pull require authenticated access to any registry, or if you want Codenvy to push snapshot images into a registry (also requiring authenticated access), then you must configure registry authentication. 

In `codenvy.env`:

```
CODENVY_DOCKER_REGISTRY_AUTH_REGISTRY1_URL=url1
CODENVY_DOCKER_REGISTRY_AUTH_REGISTRY1_USERNAME=username1
CODENVY_DOCKER_REGISTRY_AUTH_REGISTRY1_PASSWORD=password1

CODENVY_DOCKER_REGISTRY_AWS_REGISTRY1_ID=id1
CODENVY_DOCKER_REGISTRY_AWS_REGISTRY1_REGION=region1
CODENVY_DOCKER_REGISTRY_AWS_REGISTRY1_ACCESS__KEY__ID=key_id1
CODENVY_DOCKER_REGISTRY_AWS_REGISTRY1_SECRET__ACCESS__KEY=secret1
```

There are different configurations for AWS EC2 and the Docker regsitry. You can define as many different registries as you'd like, using the numerical indicator in the environment variable. In case of adding several registries just copy set of properties and append `REGISTRY[n]` for each variable.


#### Pulling Private Images in Stacks
Once you have configured private registry access, any stack that has a `FROM <registry>/<repository>` that requires authenticated access will use the provided credentials within `codenvy.env` to access the registry.

```text  
# Syntax
FROM <repository>/<image>:<tag>

# Example:
FROM my.registry.url:9000/image:latest
```

### Using Snapshots with Private Registries
You can configure Codenvy to save your workspace snapshots to a private registry that you have installed, such as JFrog's Artifactory or Docker's Enterprise Registry. The default configuration of workspace snapshots is to have them saved within a private Docker registry that we start when you start Codenvy.

#### Save Workspace Snapshots to a Custom Private Registry
In `codenvy.env`:

```
CODENVY_DOCKER_REGISTRY_FOR_WORKSPACE_SHAPSHOTS=<registry-url>
```

### Custom Dockerfiles and Composefiles for Workspaces
Your workspaces are powered by a set of runtime environments. The default runtime is Docker. Typically, admins have pre-built images in DockerHub or another registry which are pulled when the workspace is created. You can optionally provide custom Dockerfiles (or let your users provide their own Dockerfiles), which will dynamically create a workspace image when a user creates a new workspace. 

To use your custom Dockerfiles, you can:

1. Create a [custom stack]({{base}}{{site.links["ws-stacks"]}}#custom-stack), which includes a [recipe]({{base}}{{site.links["ws-recipes"]}}) with your Dockerfile. 
2. Or, users can create a custom recipe when creating a workspace that references your registry.

### Privileged Mode
Docker's privileged mode allows a container to have root-level access to the host from within the container. This enables containers to do more than they normally would, but opens up security risks. You can enable your workspaces to have privileged mode, giving your users root-level access to the host where Che is running (in addition to root access of their workspace). Privileged mode is necessary if you want to enable certain features such as Docker in Docker.

By default, workspaces are not configured with Docker privileged mode.  There are many security risks to activating this feature - please review the various issues with blogs posted online. In `codenvy.env`:

```shell
CODENVY_MACHINE_DOCKER_PRIVILEGE_MODE=true
```

### Mirroring Docker Hub  
If you are running a private registry internally to your company, you can [optionally mirror Docker Hub](https://docs.docker.com/registry/recipes/mirror/). Your private registry will download and cache any images that your users reference from the public Docker Hub. You need to [configure your Docker daemon to make use of mirroring](https://docs.docker.com/registry/recipes/mirror/).

### Using Docker In Workspaces
If you'd like your users to work with projects which have their own Docker images and Docker build capabilities inside of their workspace, then you need to configure the workspace to work with Docker. You have two options:

1. Activate Docker's prvileged mode, where your user workspaces have access to the host.
2. Configure Codenvy workspaces to volume mount their host Daemon when starting

These two tactics will allow user workspaces to perform `docker` commands from within their workspace to create and work with Docker containers that will be outside the workspace. In other words, this makes your user's workspace feel like their laptop where they would normally be performing `docker build` and `docker run` commands.

You will need to make sure that your user's workspaces are powered from a stack that has a Docker client installed inside of it. Our defalt stacks do not have a Docker client installed, but we have sample stacks from Che-in-Che that have examples for how to handle this.

# SMTP
Codenvy embeds a dummy mail server which is used only for sending out confirmation emails in the event that the system allows users to self-register. Most enterprises prefer to integrate Codenvy with their [LDAP]({{base}}{{site.links["admin-ldap"]}}) or [oAuth]({{base}}/docs/admin-guide/configuration/index.html#oauth) server.

If you choose to allow self-service registration then we suggest you use your own SMTP server. Modify `codenvy.env` (below is an example for Gmail):

```
CODENVY_MAIL_HOST=smtp.gmail.com
CODENVY_MAIL_HOST_PORT=465
CODENVY_MAIL_SMTP_AUTH=true
СODENVY_MAIL_TRANSPORT_PROTOCOL=smtp
CODENVY_MAIL_SMTP_AUTH_USERNAME=example@gmail.com
CODENVY_MAIL_SMTP_AUTH_PASSWORD=password
CODENVY_MAIL_SMTP_SOCKETFACTORY_PORT=465
CODENVY_MAIL_SMTP_SOCKETFACTORY_CLASS=javax.net.ssl.SSLSocketFactory
CODENVY_MAIL_SMTP_SOCKETFACTORY_FALLBACK=false
```

# Development Mode
**Note**: While Codenvy's source code is publicly available on GitHub it is not an open-source project and requires a license from Codenvy to make any changes to the source code.

For Codenvy developers that are building and customizing Codenvy from its source repository, you can run Codenvy in development mode where your local assembly is used instead of the one that is provided in the default containers downloaded from DockerHub. This allows for a rapid edit / build / run cycle.

Dev mode is activated by volume mounting the Codenvy git repository to `:/repo` in your Docker run command.

```
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    -v <local-path>:/data \
                    -v <local-repo>:/repo \
                       codenvy/cli:<version> [COMMAND]
```

Dev mode will use files from your host repository:

1. During the `codenvy config` phase, the source repository's `/dockerfiles/init/modules` and `/dockerfiles/init/manifests` will be used instead of the ones that are included in the `codenvy/init` container.
2. During the `codenvy start` phase, a local assembly from `assembly/onpremises-ide-packaging-tomcat-codenvy-allinone/target/onpremises-ide-packaging-tomcat-codenvy-allinone` is mounted into the `codenvy/codenvy` runtime container. You must `mvn clean install` the `assembly/onpremises-ide-packaging-tomcat-codenvy-allinone/` folder prior to activated development mode. We also will mount the assemblies that generate the workspace agent and terminal agents.

You can only have the custom assemblies deployed into Codenvy and skip using repository configuration files by using the `:/assembly` volume mount instead.

To activate jpda suspend mode for debugging codenvy server initialization, in the `codenvy.env`:

```
CODENVY_DEBUG_SUSPEND=true
```

To change codenvy debug port, in the `codenvy.env`:

```
CODENVY_DEBUG_PORT=8000
```
