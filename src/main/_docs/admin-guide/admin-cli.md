---
tag: [ "codenvy" ]
title: CLI Reference
excerpt: "Manage your Codenvy installation on the command line."
layout: docs
permalink: /:categories/cli/
---
{% include base.html %}

Running `codenvy/cli` executes Codenvy's CLI launcher from within a Docker container. The CLI launcher uses the `codenvy.env` configuration file to launch and configure a set of containers that actually run Codenvy. The CLI launcher also includes a number of helper functions for admins.

Note: The CLI will hide most error conditions from standard out. Internal stack traces and error output is redirected to `cli.log`, which is saved in the host folder where `:/data` is mounted.

```
USAGE:
  docker run -it --rm <DOCKER_PARAMETERS> codenvy/cli:<version> [COMMAND]

MANDATORY DOCKER PARAMETERS:
  -v <LOCAL_PATH>:/data                Where user, instance, and log data saved

OPTIONAL DOCKER PARAMETERS:
  -e CODENVY_HOST=<YOUR_HOST>          IP address or hostname where codenvy will serve its users
  -v <LOCAL_PATH>:/data/instance       Where instance, user, log data will be saved
  -v <LOCAL_PATH>:/data/backup         Where backup files will be saved
  -v <LOCAL_PATH>:/repo                codenvy git repo - uses local binaries and manifests
  -v <LOCAL_PATH>:/assembly            codenvy assembly - uses local binaries
  -v <LOCAL_PATH>:/sync                Where remote ws files will be copied with sync command
  -v <LOCAL_PATH>:/unison              Where unison profile for optimizing sync command resides
  -v <LOCAL_PATH>:/chedir              Soure repository to convert into workspace with Chedir utility

COMMANDS:
  action <action-name>                 Start action on codenvy instance
  backup                               Backups codenvy configuration and data to /data/backup volume mount
  config                               Generates a codenvy config from vars; run on any start / restart
  destroy                              Stops services, and deletes codenvy instance data
  dir <command>                        Use Chedir and Chefile in the directory mounted to :/chedir
  download                             Pulls Docker images for the current codenvy version
  help                                 This message
  info                                 Displays info about codenvy and the CLI
  init                                 Initializes a directory with a codenvy install
  offline                              Saves codenvy Docker images into TAR files for offline install
  restart                              Restart codenvy services
  restore                              Restores codenvy configuration and data from /data/backup mount
  rmi                                  Removes the Docker images for <version>, forcing a repull
  ssh <wksp-name> [machine-name]       SSH to a workspace if SSH agent enabled
  start                                Starts codenvy services
  stop                                 Stops codenvy services
  sync <wksp-name>                     Synchronize workspace with local directory mounted to :/sync
  test <test-name>                     Start test on codenvy instance
  upgrade                              Upgrades codenvy from one version to another with migrations and backups
  version                              Installed version and upgrade paths
  add-node                             Adds a physical node to serve workspaces intto the Codenvy cluster
  list-nodes                           Lists all physical nodes that are part of the Codenvy cluster
  remove-node <ip>                     Removes the physical node from the Codenvy cluster

GLOBAL COMMAND OPTIONS:
  --fast                               Skips networking, version, nightly and preflight checks
  --offline                            Runs CLI in offline mode, loading images from disk
  --debug                              Enable debugging of codenvy server
  --trace                              Activates trace output for debugging CLI
```
You can override any value in `codenvy.env` for a single execution by passing in `-e NAME=VALUE` on the command line. The CLI will detect the values on the command line and ignore those imported from `codenvy.env`.

## codenvy init  
Initializes an empty directory with a Codenvy configuration and instance folder where user data and runtime configuration will be stored. You must provide a `<path>:/data` volume mount, then Codenvy creates a `instance` and `backup` subfolder of `<path>`. You can optionally override the location of `instance` by volume mounting an additional local folder to `/data/instance`. You can optionally override the location of where backups are stored by volume mounting an additional local folder to `/data/backup`.  After initialization, a `codenvy.env` file is placed into the root of the path that you mounted to `/data`.

These variables can be set in your local environment shell before running and they will be respected during initialization:

| Variable | Description |
|----------|-------------|
| `CODENVY_HOST` | The IP address or DNS name of the Codenvy service. We use `eclipse/che-ip` to attempt discovery if not set. |

Codenvy depends upon Docker images. We use Docker images in three ways:

1. As cross-platform utilites within the CLI. For example, in scenarios where we need to perform a `curl` operation, we use a small Docker image to perform this function. We do this as a precaution as many operating systems (like Windows) do not have curl installed.
2. To look up the master version and upgrade manifest, which is stored as a singleton Docker image called `codenvy/version`.
3. To perform initialization and configuration of Codenvy such as with `codenvy/init`. This image contains templates that are delivered as a payload and installed onto your computer. These payload images can have different files based upon the image's version.
4. To run Codenvy and its dependent services, which include Codenvy, HAproxy, nginx, Postgres, socat, and Docker Swarm.

You can control the nature of how Codenvy downloads these images with command line options. All image downloads are performed with `docker pull`.

| Mode >>>>>> | Description |
|------|-------------|
| `--no-force` | Default behavior. Will download an image if not found locally. A local check of the image will see if an image of a matching name is in your local registry and then skip the pull if it is found. This mode does not check DockerHub for a newer version of the same image. |
| `--pull` | Will always perform a `docker pull` when an image is requested. If there is a newer version of the same tagged image at DockerHub, it will pull it, or use the one in local cache. This keeps your images up to date, but execution is slower. |
| `--force` | Performs a forced removal of the local image using `docker rmi` and then pulls it again (anew) from DockerHub. You can use this as a way to clean your local cache and ensure that all images are new. |
| `--offline` | Loads Docker images from `backup/*.tar` folder during a pre-boot mode of the CLI. Used if you are performing an installation or start while disconnected from the Internet. |

The initialization of a Codenvy installation requires the acceptance of our default [Fair Source license agreement](http://codenvy.com/legal), which allows for some access to the source code and free usage for up to three people. You can auto-accept the license agreement without prompting for a response for silent installation by passing the `--accept-license` command line option.

You can reinstall Codenvy on a folder that is already initialized and preserve your `/data/codenvy.env` values by passing the `--reinit` flag.

## codenvy config
Generates a Codenvy instance configuration thta is placed in `/data/instance`. This command uses puppet to generate configuration files for Codenvy, haproxy, swarm, socat, nginx, and postgres which are mounted when Codenvy services are started. This command is executed on every `start` or `restart`.

If you are using a `codenvy/cli:<version>` image and it does not match the version that is in `/instance/codenvy.ver`, then the configuration will abort to prevent you from running a configuration for a different version than what is currently installed.

This command respects `--no-force`, `--pull`, `--force`, and `--offline`.

## codenvy start
Starts Codenvy and its services using `docker-compose`. If the system cannot find a valid configuration it will perform a `codenvy init`. Every `start` and `restart` will run a `codenvy config` to generate a new configuration set using the latest configuration. The starting sequence will perform pre-flight testing to see if any ports required by Codenvy are currently used by other services and post-flight checks to verify access to key APIs.  

## codenvy stop
The default stop is a graceful stop where each workspace is stopped and confirmed shutdown before stopping system services. If workspaces are configured to snap on stop, then all snaps will be completed before system service shutdown begins. You can ignore workspace stop behavior and shut down only system services with `--force` flag. Your admin user and password are required to perform a shutdown and provided by `--user` and `--password`

## codenvy restart
Performs a `codenvy stop` followed by a `codenvy start`, respecting `--pull`, `--force`, and `--offline`.

## codenvy destroy
Deletes `/docs`, `codenvy.env` and `/instance`, including destroying all user workspaces, projects, data, and user database. If you pass `--quiet` then the confirmation warning will be skipped. Passing `--cli` will also destroy the `cli.log`. By default this is left behind for traceability.

## codenvy offline
Saves all of the Docker images that Codenvy requires into `/backup/*.tar` files. Each image is saved as its own file. If the `backup` folder is available on a machine that is disconnected from the Internet and you start Codenvy with `--offline`, the CLI pre-boot sequence will load all of the Docker images in the `/backup/` folder.

`--list` option will list all of the core images and optional stack images that can be downloaded. The core system images and the CLI will always be saved, if an existing TAR file is not found. `--image:<image-name>` will download a single stack image and can be used multiple times on the command line. You can use `--all-stacks` or `--no-stacks` to download all or none of the optional stack images.

## codenvy rmi
Deletes the Docker images from the local registry that Codenvy has downloaded for this version.

## codenvy download
Used to download Docker images that will be stored in your Docker images repository. This command downloads images that are used by the CLI as utilities, for Codenvy to do initialization and configuration, and for the runtime images that Codenvy needs when it starts.  This command respects `--offline`, `--pull`, `--force`, and `--no-force` (default).  This command is invoked by `codenvy init`, `codenvy config`, and `codenvy start`.

This command is invoked by `codenvy init` before initialization to download the images for the version specified by `codenvy/cli:<version>`.

## codenvy version
Provides information on the current version and the available versions that are hosted in Codenvy's repositories. `codenvy upgrade` enforces upgrade sequences and will prevent you from upgrading one version to another version where data migrations cannot be guaranteed.

## codenvy upgrade
Manages the sequence of upgrading Codenvy from one version to another. Run `codenvy version` to get a list of available versions that you can upgrade to.

Upgrading Codenvy is done by using a `codenvy/cli:<version>` that is newer than the version you currently have installed. For example, if you have 5.0.0-M2 installed and want to upgrade to 5.0.0-M7, then:

```
# Get the new version of Codenvy
docker pull codenvy/cli:5.0.0-M7

# You now have two codenvy/cli images (one for each version)
# Perform an upgrade - use the new image to upgrade old installation
docker run <volume-mounts> codenvy/cli:5.0.0-M7 upgrade
```

The upgrade command has numerous checks to prevent you from upgrading Codenvy if the new image and the old version are not compatiable. In order for the upgrade procedure to proceed, the CLI image must be newer than the value of '/instance/codenvy.ver'.

The upgrade process: a) performs a version compatibility check, b) downloads new Docker images that are needed to run the new version of Codenvy, c) stops Codenvy if it is currently running triggering a maintenance window, d) backs up your installation, e) initializes the new version, and f) starts Codenvy.

You can run `codenvy version` to see the list of available versions that you can upgrade to.

`--skip-backup` option allow to skip [backup](https://github.com/codenvy/che-docs/blob/master/src/main/_docs/setup/setup-cli.md#backup) during update, that could be useful to speed up upgrade because [backup](https://github.com/codenvy/che-docs/blob/master/src/main/_docs/setup/setup-cli.md#backup) can be very expensive operation if `/instace` folder is really big due to many user worksapces and projects.

## codenvy info
Displays system state and debugging information. `--network` runs a test to take your `CODENVY_HOST` value to test for networking connectivity simulating browser > Codenvy and Codenvy > workspace connectivity.

## codenvy backup
Tars your `/instance` into files and places them into `/backup`. These files are restoration-ready.

## codenvy restore
Restores `/instance` to its previous state. You do not need to worry about having the right Docker images. The normal start / stop / restart cycle ensures that the proper Docker images are available or downloaded, if not found.

This command will destroy your existing `/instance` folder, so use with caution, or set these values to different folders when performing a restore.
