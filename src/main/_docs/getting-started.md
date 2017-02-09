---
tag: [ "codenvy" ]
title: Getting Started
excerpt: ""
layout: docs
permalink: /docs/
---
{% include base.html %}

You can get started with Codenvy through our hosted offering or by installing it yourself.

| Get Started Options |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Action&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|:--- | :---: |
|**Create a Free Account at codenvy.io**. Everyone gets 3GB for free. Connect to a public toolchain and be coding in minutes.| [Sign up](https://codenvy.io/)
|**Download Codenvy**. Install Codenvy anywhere Docker runs and connect it to your private toolchain. Control security and configuration–even add your own extensions.|[Install Now]({{base}}{{site.links["admin-installation"]}})

## Install
With Docker 1.11+ (1.12.5+ recommended) on Windows, Mac, or Linux:
```
$ docker run codenvy/cli start
```
This command will give you additional instructions on how to run the Codenvy CLI while setting your hostname, configuring volume mounts, and testing your Docker setup. Once setup you'll be brought into the Codenvy system.

![multi-machine-ide.png]({{base}}/docs/assets/imgs/codenvy/multi-machine-ide.png)

## Where To Go Next  

|I am a...| Check out the... |
| --- | --- |
| **System administrator** | [*The Admin Guide*]({{base}}/docs/admin-guide/installation/index.html).<br> Install, configure, and operate a global Codenvy cloud servicing all your developers. |
| **Developer** | [*The User Guide*]({{base}}/docs/getting-started/admin-intro/index.html).<br> Configure and use workspaces and the Che IDE (or any desktop IDE). |
| **DevOps** or **Team Lead** | [*The DevOps Guide*]({{base}}/docs/integration-guide/workspace-automation/index.html).<br> Automate workspace creation with Factories and integrate Codenvy with your private toolchain including GitHub, BitBucket, JIRA and Jenkins. |
| **Plug-in Developer** | [*Che Plugin Guide*](https://www.eclipse.org/che/docs/plugins/introduction/index.html).<br> Codenvy is based on Eclipse Che - to extend Codenvy simply build Che extensions. If you are going to place your extensions into a Codenvy On-Prem instance please [contact us for guidance](https://codenvy.com/contact/questions/). |
