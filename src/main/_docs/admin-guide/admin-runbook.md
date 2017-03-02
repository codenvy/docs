---
tag: [ "codenvy" ]
title: Runbook
excerpt: "Running a production Codenvy system"
layout: docs
permalink: /docs/admin-guide/runbook/
---
{% include base.html %}

This article provides specific performance and security guidance for Codenvy on-premises installations based on our experience running codenvy.io hosted SaaS and working with our enterprise customers. We assume a multi-node setup where workspaces are run on Workspace Nodes and the Master Node does not operate workspaces, ie the Master Node's IP is not included in the `codenvy.env` Swarm list.

# Recommended Docker Versions
Codenvy can run on Docker 1.11+, but we recommend **Docker 1.12.5+**. Versions below 1.12.5 have known issues:

| Issue | Link | Fixed In |
|--- |--- |--- |
| DockerConnector exception "Could not kill running container" | https://github.com/codenvy/codenvy/issues/1164 | Docker 1.12.5

# Zookeeper Configuration
Zookeeper is a key-value store used by Docker in a clustered setup. To optimize the setup:

**Step 1**: On the Master Node ensure that port 2181 is open. For example, if you're using `iptables`:

```
#etcd
-A INPUT -m state --state NEW -m tcp -p tcp --dport 2379 -j ACCEPT
...
#zookeeper
-A INPUT -m state --state NEW -m tcp -p tcp --dport 2181 -j ACCEPT
...
-A INPUT -m state --state NEW -m udp -p udp --dport 4789 -j ACCEPT
```

**Step 2**: Change the Docker daemon configuration (subsituting the hostname for your instance and the appopriate network adapter):

```
DOCKER_NETWORK_OPTIONS=' --bip=172.17.42.1/16 -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=zk:// codenvy.com:2181 --cluster-advertise=eth0:2375'
```

# Network Infrastructure
We have 2 classes of instances:

1. Master Nodes used for running internal Codenvy services.
2. Workspace Nodes that runs user workspaces.

We suggest separating traffic bewteen two subnets: one for Master and one for Workspace Nodes. This keeps the traffic purpose and security properly segregated and allows the use of subnet masks, rather than individual IPs when writing firewall rules. VNET will use addresses 10.0.0.0/8 and two subnets 10.1.0.0/16 for Master and 10.2.0.0/16 for Workspace Nodes.

# Storage
Cloud-based installs (AWS, Google Cloud, etc...) can quickly scale disk space up. To utilise this we suggest LVM and XFS and recommend using caching for both read and write.

Machine Nodes typically require fast I/O access to give developers the best experience. This is espeically important with languages like node.js and PHP that can require access to a large number of small files. To optimize performance we suggest using SSD in all locations. 

For Machine Nodes local storage is strongly preferred as it will provide the best performance.

For the Master, LVM or RAID is recommended for redundancy and network attached storage can be used. If using Amazon Web Services we recommend LVM with snapshotting turned on for faster backups of the key data.

## Directories

For Master Node:

```
/var/lib/pgsql
/var/lib/docker
/var/lib/docker-distribution
/home/codenvy/codenvy-data/fs
/home/codenvy/codenvy/instance/data/codenvy/che-machines
```

And for Machine Nodes:

```
/var/log/journal
/var/lib/docker
/home/codenvy/codenvy-data
```

### Master Node: Disk Setup

After starting the instance inside the first subnet we need to attach 3 data disks:
- For databases and logs: initial size is about 300 GB.
- For file system (main project storage/backups): initial size is about 1TB but this should be monitored as the demands will depend heavily on the type of projects and developer usage patterns in the organization.
- For Docker image snapshots: initial size is about 1TB.

1. Unmount used ephemeral disk: `# umount /dev/sdb1`
2. Zeroing beginning of ephemeral disk: `# dd if=/dev/zero of=/dev/sdb`
3. Add ephemeral disk to LVM: `# pvcreate /dev/sdb`
4. Create volume group: `# vgcreate vg-docker /dev/sdb`
5. Create swap volume with size 4 GB: `#  lvcreate -L 4G -n swap vg-docker`
6. Create docker’s metadata volume with size 2 GB: `#  lvcreate -L 2G -n metadata vg-docker`
7. Create docker data volume using all remaining disk space: `#  lvcreate -l 100%FREE -n data vg-docker`
8. Make swap volume become swap: `#  mkswap /dev/vg-docker/swap`
9. Activate swap volume: `#  swapon /dev/vg-docker/swap`

For databases and logs:

1. Add data disk to LVM: `# pvcreate /dev/sdc`
2. Create volume group: `# vgcreate vg-data /dev/sdc`
3. Create journal volume with size 10 GB: `#  lvcreate -L 10G -n journal vg-data`
4. Create logs volume with size 20 GB: `#  lvcreate -L 20G -n logs vg-data`
5. Create machine-logs volume with size 30 GB: `#  lvcreate -L 30G -n machine-logs vg-data`
6. Create ldap volume with size 10 GB: `#  lvcreate -L 10G -n ldap vg-data`  (Not needed after 5.0.0-M5)
7. Create mongo volume with size 20 GB: `#  lvcreate -L 20G -n mongo vg-data`  (Not needed after 5.0.0-M5)
8. Create pgsql volume with size 20 GB: `#  lvcreate -L 20G -n psql vg-data`
9. Create docker data volume using all remaining disk space: `#  lvcreate -l 100%FREE -n docker vg-docker`

For filesystem:

1. Add data disk to LVM: `# pvcreate /dev/sdd`
2. Create volume group: `# vgcreate vg-fs /dev/sdd`
3. Create FS volume using all remaining disk space: `#  lvcreate -l 100%FREE -n fs vg-fs`

For Docker snapshots:

1. Add data disk to LVM: `# pvcreate /dev/sde`
2. Create volume group: `# vgcreate vg-ddistr /dev/sde`
3. Create FS volume using all remaining disk space: `#  lvcreate -l 100%FREE -n ddistr vg-ddistr`

Make XFS filesystem for:

1. journal: `# mkfs.xfs /dev/vg-data/journal`
2. logs: `# mkfs.xfs /dev/vg-data/logs`
3. machine-logs: `# mkfs.xfs /dev/vg-data/machine-logs`
4. ldap: `# mkfs.xfs /dev/vg-data/ldap`  (Not needed after 5.0.0-M5)
5. mongo: `# mkfs.xfs /dev/vg-data/mongo`  (Not needed after 5.0.0-M5)
6. pgsql: `# mkfs.xfs /dev/vg-data/pgsql`
7. docker: `# mkfs.xfs /dev/vg-data/docker`
8. fs: `# mkfs.xfs /dev/vg-fs/fs`
9. Snapshots: `# mkfs.xfs /dev/vg-ddistr/ddistr`

For /etc/fstab entries (note the *nofail* option):

```
#
# /etc/fstab
# Created by anaconda on Thu Mar 14 11:03:34 2013
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
LABEL=rootfs            /           ext4    defaults,relatime  1   1
tmpfs                   /dev/shm                tmpfs   defaults        0 0
devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
sysfs                   /sys                    sysfs   defaults        0 0
proc                    /proc                   proc    defaults        0 0
/dev/vg-docker/swap     swap                    swap    defaults,nofail        0 0
/dev/vg-data/fs         /home/codenvy/codenvy-data/fs   xfs     defaults,nofail         0 0
/dev/vg-ddist/ddist     /var/lib/docker-distribution    xfs     defaults,nofail         0 0
/dev/vg-docker/machinelogs      /home/codenvy/codenvy-data/che-machines-logs    xfs     defaults,nofail         0 0
```

- Activate all fstab entries: `# mount -a`
- Check if swap activated: `# free`
- Check if all volumes mounted and have correct sizes: `# df -h`

### Workspace Nodes: Disk Setup

After starting instance inside second subnet we need to attach 2 data disks:
- For Docker and logs: initial size is about 300 GB
- For workspace project storage: initial size is about 1TB, but this should be monitored as the demands will depend heavily on the type of projects and developer usage patterns in the organization.

1. Unmount used ephemeral disk: `# umount /dev/sdb1`
2. Zeroing beginning of ephemeral disk: `# dd if=/dev/zero of=/dev/sdb`
3. Add ephemeral disk to LVM: `# pvcreate /dev/sdb`
4. Create volume group: `# vgcreate vg-docker /dev/sdb`
5. Create swap volume with size 4 GB: `#  lvcreate -L 4G -n swap vg-docker`
6. Create docker’s metadata volume with size 2 GB: `#  lvcreate -L 2G -n metadata vg-docker`
7. Create docker data volume using all remaining disk space: `#  lvcreate -l 100%FREE -n data vg-docker`
8. Make swap volume become swap: `#  mkswap /dev/vg-docker/swap`
9. Activate swap volume: `#  swapon /dev/vg-docker/swap`

For Docker and logs:

1. Add data disk to LVM: `# pvcreate /dev/sdc`
2. Create volume group: `# vgcreate vg-data /dev/sdc`
3. Create journal volume with size 10 GB: `#  lvcreate -L 10G -n journal vg-data`
4. Create docker data volume using all remaining disk space: `#  lvcreate -l 100%FREE -n docker vg-data`

For Workspace Storage:

1. Add data disk to LVM: `# pvcreate /dev/sdd`
2. Create volume group: `# vgcreate vg-fs /dev/sdd`
3. Create FS volume using all remaining disk space: `#  lvcreate -l 100%FREE -n fs vg-fs`

Make XFS filesystem for:

1. journal: `# mkfs.xfs /dev/vg-data/journal`
2. docker: `# mkfs.xfs /dev/vg-data/docker`
3. FS: `# mkfs.xfs /dev/vg-fs/fs`

Add /etc/fstab entries (note the *nofail* option):

```
#
# /etc/fstab
# Created by anaconda on Thu Mar 14 11:03:34 2013
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
LABEL=rootfs            /           ext4    defaults,relatime  1   1
tmpfs                   /dev/shm                tmpfs   defaults        0 0
devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
sysfs                   /sys                    sysfs   defaults        0 0
proc                    /proc                   proc    defaults        0 0
/dev/vg-docker/swap     swap                    swap    defaults,nofail        0 0
/dev/vg-data/fs         /home/codenvy/codenvy-data/fs   xfs     defaults,nofail         0 0
/dev/vg-ddist/ddist     /var/lib/docker-distribution    xfs     defaults,nofail         0 0
/dev/vg-docker/machinelogs      /home/codenvy/codenvy-data/che-machines-logs    xfs     defaults,nofail         0 0
```

- Activate all fstab entries: `# mount -a`
- Check if swap activated: `# free`
- Check if all volumes mounted and have correct sizes: `# df -h`

## Increasing Disk Space
If additional disk space is needed you can attach a new data disk (caches turned ON), then issue the following commands:

1. Create physical volume: `# pvcreate /dev/sdg`
2. Scan disks for changes, new disk should appear here:`lvmdiskscan\npvdisplay\npvscan`
3. Extend volume group: `# vgextend vg-data /dev/sdg`
4. Extend logical volume: `# lvextend -l +100%FREE /dev/vg-fs/fs`
5. To grow the actual filesystem, it must be run on mounted volume, no need to stop codenvy or unmount filesystem: `# xfs_growfs /home/codenvy/codenvy-data/fs/`

## Detaching Disks
If you need to detach disks, you need to stop all services that may be using that volume:

```
service puppet stop\nservice crond stop\nservice codenvy stop
```

1. Unmount FS: `# umount /home/codenvy/codenvy-data/fs`
2. Deactivate volume group: `# vgchange -an vg-fs`
3. Detach data disk using azure web-interface or CLI from old instance
4. Reattach data disk using azure web-interface or CLI to new instance (turn ON caching)
5. Activate volume group: `# vgchange -ay vg-fs`
