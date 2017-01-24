---
tag: [ "codenvy" ]
title: Continuous Integration
excerpt: ""
layout: docs
permalink: /:categories/continuous-integration/
---
{% include base.html %}

**Applies To**: Codenvy on-premises installs.

---
Codenvy is connected to your repo so any change made to the repo that would normally trigger a CI job will continue to trigger a CI job when the change is made in Codenvy.

# Integrating Codenvy and Jenkins
Codenvy can also use [Factories]({{base}}/docs/integration-guide/workspace-automation/index.html) with your CI system to generate developer workspaces pre-configured with the context of the CI job. For example, a failed CI build email can be customized to include a link to a Codenvy Factory that will generate a workspace already tied to the repo, branch and commit ID that broke the build, simplifying diagnosis.

If you'd like to speak to us about an integrations between Codenvy and another CI system, [please contact us](https://codenvy.com/contact/questions/).

## Configuring the Integration

### Set up Plugins  
Go to **Manage Jenkins - Manage Plugins** and install GitHub and Email Extension Template Plugins.
![plugins.png]({{base}}/docs/assets/imgs/codenvy/plugins.png)

### Create a Jenkins Job  
(Skip this step if you have your Jenkins job already set up.)
Set up a Jenkins Job that matches your project requirements (JDK, Maven, Node.js etc). You may need to install additional plugins that your project requires.

### Configure the Jenkins Job's Post Build Actions  
Once a Jenkins job is set up you need to make sure that an email is sent out when a job succeeds or fails. You should use a **[.jelly template](https://gist.githubusercontent.com/stour/219f30ae3c6aa260ffd5/raw/f83feec8ee08142fe1fca2d1c8c1f9edc52a0e34/html-factory.jelly)** as the default message template. Download it and save to `/var/lib/jenkins/email-templates/html-factory.jelly` on the instance where Jenkins runs.

In your Jenkins job configuration, define the message content as:

`${JELLY_SCRIPT,template="html-factory"}`
![postbuild.png]({{base}}/docs/assets/imgs/codenvy/postbuild.png)

### Create a Codenvy Factory  
You need a Codenvy Factory configured to use the project you want associated with your Jenkins job. This Factory will be modified by the plugin and injected into Jenkins job emails. See: [Factories]({{base}}/docs/integration-guide/workspace-automation/index.html).

### Add Factory URL to Job
In the job in Jenkins replace the description with the Factory link. It should look something like:

`<a href="https://codenvy.io/f?id=factoryp6ewi838lux62bo1">Open Project in Codenvy</a>`

where the URL in quotes is the Factory URL to be used with the Jenkins job.

### Create Property Files
#### Credentials File
In a directory outside the Codenvy contianer create a `credentials.properties` file and enter the username and password of the use who created the Jenkins Factory in Codenvy.

```  
username=somebody@somemail.com
password=some-password
```

#### Git File
**For GitHub**
In a directory outside the Codenvy contianer create a `github-webhooks.properties` file.

```text  
webhook1=github,https://github.com/orgName/web-java-spring,factory7nfrelk0v8b77fekn
[webhook-name],[GitHub-URL],[Factory-id]
```   

**For BitBucket**
In a directory outside the Codenvy contianer create a `bitbucketserver-webhooks.properties` file.

```text  
webhook1=bitbucketserver,http://owner@bitbucketserver.host/scm/projectkey/repository.git,factoryId
[webhook-name],[repository-url],[factory-id];[factory-id];...;[factory-id]
```

#### Jenkins Connector File 
In a directory outside the Codenvy contianer create a `connectors.properties` file.

```text  
jenkins1=jenkins,factory7nfrelk0v8b77fek,http://userName:password@jenkins.codenvy-dev.com:8080,EvgenTestn

[connector-name],[factory-ID],[$protocol://$userName:$password@$jenkinsURL],[jenkins-job-name]
```   

### Copy Property Files to Container
**This is a temporary workaround - a mounting mechanism is being developed to remove the need to re-add these property files at each container start**
For each of the three property files, copy it into the root of the Codenvy container:

```shell
docker cp <file name> codenvy_codenvy_1:/<file name>
# Example: docker cp credentials.properties codenvy_codenvy_1:/credentials.properties (edited)
```

This must be done each time the container is restarted. If you have an automated start script or restart script add these commands to that.

### Configure Repo Webhooks  
#### For GitHub
In your GitHub repo settings, configure the following webhook: `http(s)://$codenvyURL/api/github-webhook`

#### For BitBucket Server

- Log into the Bitbucket Server as an Admin
- Install Post-Receive WebHooks plugin.
- In repo settings, configure the plugin to use Bitbucket Server webhook: `http(s)://$codenvyURL/api/bitbucketserver-webhook`
- Configure `bitbucket_endpoint` property with the URL of your Bitbucket Server

## Test Integration  
To trigger the email you will need to make the build fail. If everything is configured correctly the build failed email should include a "Codenvy Factory" line in the build information at the top of the email.
