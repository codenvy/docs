---
tag: [ "codenvy" ]
title: Monitoring
excerpt: "Monitoring Codenvy"
layout: docs
permalink: /:categories/monitoring/
---
{% include base.html %}

## Contents

- TOC
{:toc}

---

This article discribes how to monitor a standard production setup with a master node that is not configured to run workspaces (the recommended setup for multi-node installations) and separate machine nodes for running workspace containers.

# What to Monitor
In this example and in our public cloud we use the following tools. Note that other tools can be used:

- Resource Monitoring: We use Zabbix to monitor service resources, such as available disk space, RAM, number of containers etc...
- Services Monitoring: We use Pingdom for externally accessible services and Zabbix to track the availability of hosts.

# Zabbix Setup

In this example we will use Zabbix 3.2.1 (other versions may require slight changes). To run Zabbix we are using a dockerized alpine-based instalation with PostgreSQL and nginx as per [Zabbix documentation](https://www.zabbix.com/documentation/3.2/manual/installation/containers).

## List of Containers Used
- postgres:9.5
- zabbix/zabbix-java-gateway:alpine-3.2-latest
- zabbix/zabbix-server-pgsql:alpine-3.2-latest
- zabbix/zabbix-web-nginx-pgsql:alpine-3.2-latest
- zabbix/zabbix-agent:alpine-3.2-latest

## List of Templates for Master Node:
- Codenvy KV Template
- Codenvy RAM Usage Template
- Codenvy Docker Space Template
- Codenvy Workspaces Template
- Template JMX Generic
- Template OS Linux

`Codenvy KV Template` is a custom template used to monitor the avialability of resources needed for Docker's overlay network due to [a Docker issue](https://github.com/docker/swarm/issues/2614).

`Codenvy RAM Usage Template` is a custom template used to monitor the percentage of free RAM as Docker Swarm sees it. A trigger is set to 85% RAM utilization because new container provisioning will start to fail at a utilization level of 90%.

`Codenvy Docker Space Template` is a custom template used to monitor percentage of free docker storage space. Trigger set to 80%.

`Codenvy Workspaces Template` is a custom template used to monitor the number of containers in the Docker Swarm cluster (this doesn't include the Codenvy containers, only containers started for workspaces). A trigger is set to alarm if there are less than 10 (based on the assumption that there are 10 Codenvy containers in the installation) - this can be ajusted if you have more/fewer Codenvy containers.

`Template JMX Generic` is a generic JMX template used to monitor the JVM for the main Codenvy services. You should change the Template JMX file before importing to match Your JMX user and password.

`Template OS Linux` is a generic template bundled with Zabbix. You may need to [check/set permissions for monitoring available disk space with zabbix](https://www.zabbix.com/forum/showthread.php?t=12790). To check permissions use: `su zabbix -s /bin/bash -c "df -h /mnt/data"` and to set permissions: `setfacl -m u:zabbix:rx /mnt/data`.

## List of Templates for Workspace Nodes:
- Codenvy Docker Space Template
- Template OS Linux Node

`Codenvy Docker Space Template` is the same template we used in the Master Node.

`Template OS Linux Node` is a modified version of the `Template OS Linux` above. The only change is to the trigger value for `Too many processes on {HOST.NAME}`. This is increased to 800 - this will depend on the number of workspaces and containers per workspace you expect across your machine nodes.

# Pingdom Setup

Pingdom can be used to externally monitor aviability of the following HTTP/HTTPS services:
- Login API: httpp[s]://codenvy.TLD/api/auth/login -- an additional request parameter should contain `{username: "some_user@DOMAIN.TLD", password: "some_password"}`
- Ping: codenvy.TLD
- Aviability: http[s]://codenvy.TLD
- User Settings: http[s]://codenvy.TLD/api/user/settings -- responce should contain `che.auth.user_self_creation`
