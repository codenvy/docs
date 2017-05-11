---
tag: [ "codenvy" ]
title: Monitoring
excerpt: "Monitoring of codenvy using Zabbix and Pingdom"
layout: docs
permalink: /:categories/monitoring/
---
{% include base.html %}

## Contents

- TOC
{:toc}

---

This article discribes production setup with  Master Node wthat configured to doesn't run workspaces and separate Workspace Nosdes for running workspace containers.

# What to monitor

## We need to monitor service resources, such as available disk space, RAM, number of containers etc.

This we will do with Zabbix

## Also we need to monitor services

This we will do with Pingdom for external accessible services and zabbix for general hosts avaiability


# Zabbix setup

In this article we will use Zabbix 3.2.1, for other versions may be requuired small changes.
We are using dockerized apphine-based instalation with postgresql and nginx.
https://www.zabbix.com/documentation/3.2/manual/installation/containers

## List of containers used:
- postgres:9.5
- zabbix/zabbix-java-gateway:alpine-3.2-latest
- zabbix/zabbix-server-pgsql:alpine-3.2-latest
- zabbix/zabbix-web-nginx-pgsql:alpine-3.2-latest
- zabbix/zabbix-agent:alpine-3.2-latest

## List of templates for Master Node:
- Codenvy KV Template
- Codenvy RAM Usage Template
- Codenvy Docker Space Template
- Codenvy Workspaces Template
- Template JMX Generic
- Template OS Linux

`Codenvy KV Template` is custom, used to monitor aviability of resources nedded for functioning of docker's overlay network. Needed because of https://github.com/docker/swarm/issues/2614 .

`Codenvy RAM Usage Template` is custom, used to monitor percentage of free RAM as it swarm sees. Trigger set to 85% because codenvy start fails to shedule new containers at level of 90%.

`Codenvy Docker Space Template` is custom, used to monitor percentage of free docker storage space. Trigger set to 80%.

`Codenvy Workspaces Template` is custom, used to monitor number of containers on swarm (this doesn't include codenvy itself, only workspace related). Triger set to alarm if less than 10, should be ajusted to Your env.

`Template JMX Generic` is generic JMX template, used to monitor JVM for main codenvy service. You should change Template XMX file before importing to match Your JMX user and password.

`Template OS Linux` is generic template, bundled with Zabbix. You may need to check/set permissions for monitoring available disk space with zabbix https://www.zabbix.com/forum/showthread.php?t=12790
in short for checking use: `su zabbix -s /bin/bash -c "df -h /mnt/data"` and set permissions: `setfacl -m u:zabbix:rx /mnt/data`



## List of templates for Workspace Nodes:
- Codenvy Docker Space Template
- Template OS Linux Node

`Codenvy Docker Space Template` is same as we using for Master Node

`Template OS Linux Node` is modified version of `Template OS Linux`, only changed trigger value for `Too many processes on {HOST.NAME}`. We bumped it to 800. You may consider other value depending of how many containers and processes in each container You expecting on Node.

# Pingdom setup

For pingdom we are externally monitoring aviability of next HTTP/HTTPS services:
- Login API: httpp[s]://codenvy.TLD/api/auth/login - additional request parameter should contains `{username: "some_user@DOMAIN.TLD", password: "some_password"}`
- Ping codenvy.TLD
- Aviability http[s]://codenvy.TLD
- User Settings http[s]://codenvy.TLD/api/user/settings - responce should contains `che.auth.user_self_creation`
