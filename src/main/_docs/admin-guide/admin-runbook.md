---
tag: [ "codenvy" ]
title: Runbook
excerpt: "Running a production Codenvy system"
layout: docs
permalink: /docs/admin-guide/runbook/
---
{% include base.html %}

This article provides specific performance and security guidance for Codenvy on-premises installations based on our experience running codenvy.io hosted SaaS and working with our enterprise customers. For general information on managing a Codenvy on-premises instance see the [managing]({{base}}{{site.links["admin-managing"]}}) docs page.

# Recommended Docker Versions
Codenvy can run on Docker 1.10+, but we recommend **Docker 1.12.5** for the best experience. If you choose to run with a lower version you may experience the following issues:

| Issue | Link | Docker Version for Fix |
|--- |--- |--- |
| DockerConnector exception "Could not kill running container" | https://github.com/codenvy/codenvy/issues/1164 | Docker 1.12.5

# Zookeeper Configuration
Zookeeper is a key-value store that is needed by Swarm in a clustered Codenvy setup. To optimize the setup:

**Step 1**: On the master node ensure that port 2181 is opened. If you're using `iptables` for example:

```
#etcd
-A INPUT -m state --state NEW -m tcp -p tcp --dport 2379 -j ACCEPT
...
#zookeeper
-A INPUT -m state --state NEW -m tcp -p tcp --dport 2181 -j ACCEPT
...
-A INPUT -m state --state NEW -m udp -p udp --dport 4789 -j ACCEPT
```

**Step 2**: Change the configuration of the Docker daemon to look like the below. On CentOS this file is found at `/etc/sysconfig/docker-network`:

```
DOCKER_NETWORK_OPTIONS=' --bip=172.17.42.1/16 -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=zk://<%= scope.lookupvar('third_party::docker::install::docker_cluster_store') -%>:2181 --cluster-advertise=<%= scope.lookupvar('third_party::docker::install::docker_cluster_advertise') -%>:2375'
```

