---
tag: [ "codenvy" ]
title: Getting Started
excerpt: ""
layout: docs
permalink: /docs/
---
{% include base.html %}

|Options |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Action&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|:--- | :---: |
|*Create a Free Account at codenvy.io*. Everyone gets 3GB for free. Connect to a public toolchain and be coding in minutes.| [Sign up](https://codenvy.io/)
|*Download Codenvy*. Install Codenvy anywhere Docker runs and connect it to your private toolchain. Control security and configuration–even add your own extensions.|[Install Now]({{base}}{{site.links["admin-installation"]}})

## Quick Install
With Docker 1.11+ (1.12.5+ recommended) on Windows, Mac, or Linux:
```
$ docker run codenvy/cli start
```
You will be prompted with how to configure your hostname, volume mounts, and Docker configuration. Codenvy will launch a server that lets you create workspaces. *The admin guide*({{base}}/docs/admin-guide/installation/index.html) contains full installation instructions.

![multi-machine-ide.png]({{base}}/docs/assets/imgs/codenvy/multi-machine-ide.png)

## Codenvy.io Account
We run a free, hosted cloud at http://codenvy.io. This service lets you create accounts, invite other users, and create workspaces for development. The service gives you 3 GB of RAM and you can add more users or additional users for a small fee. Our terms of service and privacy policy are on [our legal page](http://codenvy.com/legal).

Your workspaces can clone Git or Subversion repositories into the project space. To prevent bad people from doing bad stuff, we whitelist all external Git providers individually. While it would be uncommon for your Git provider to not be listed in our whitelists, new providers do sometimes miss our coverage. If you are working with a non-standard provider, please consider asking us about whitelisting it by opening an issue on our [GitHub repository](http://github.com).

## Where To Go Next  

|I am a...| Check out the... |
| --- | --- |
| **System Administrator** | [*The Admin Guide*]({{base}}/docs/admin-guide/installation/index.html).<br> Install, configure, and operate a global Codenvy cloud servicing all your developers. |
| **Developer** | [*The User Guide*]({{base}}/docs/getting-started/intro/index.html).<br> Configure and use workspaces and the Che IDE (or any desktop IDE). |
| **DevOps** or **Team Lead** | [*The Factory Guide*]({{base}}/docs/factory/getting-started/index.html).<br> Automate workspace creation with Factories and [*integrate Codenvy with your private toolchain*]({{base}}/docs/integration-guide/issue-management/index.html) including GitHub, BitBucket, JIRA and Jenkins. |
| **Plug-in Developer** | [*Che Plugin Guide*](https://eclipse.org/che/docs/assemblies/intro/index.html).<br> Codenvy is based on Eclipse Che - to extend Codenvy simply build Che extensions. If you are going to place your extensions into a Codenvy On-Prem instance please [contact us for guidance](https://codenvy.com/contact/questions/). |
