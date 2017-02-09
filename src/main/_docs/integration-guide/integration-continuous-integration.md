---
tag: [ "codenvy" ]
title: Continuous Integration
excerpt: ""
layout: docs
permalink: /:categories/continuous-integration/
---
{% include base.html %}

Codenvy is connected to your repo so any change made to the repo that would normally trigger a CI job will continue to trigger a CI job when the change is made in Codenvy.

# Integrating Codenvy and Jenkins
Codenvy can also use [Factories]({{base}}/docs/integration-guide/workspace-automation/index.html) with your CI system to generate developer workspaces pre-configured with the context of the CI job. For example, a failed CI build email can be customized to include a link to a Codenvy Factory that will generate a workspace already tied to the repo, branch and commit ID that broke the build, simplifying diagnosis.

Because configuring this integration requires system-level property settings it can only be used by customer with [on-premises Codenvy]({{base}}{{site.links["admin-installation"]}}).

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

### Set Codenvy Environment Variables

#### Credentials
Update the `codenvy.env` with the username and password of the user who created the Factory in Codenvy: 

```text
CODENVY_INTEGRATION_FACTORY_OWNER_USERNAME=omebody@somemail.com
CODENVY_INTEGRATION_FACTORY_OWNER_PASSWORD=password
```

#### Git
**For GitHub**
Update the `codenvy.env` with `GitHub` webhooks properties. Note that you can rename "WEBHOOK1" with any identifer. The system will treat Git and Jenkins Connector variables with the same name as related so ensure you have both identically named for each install:

```text  
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_REPOSITORY_URL=https://github.com/testrepo.git
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_FACTORY1_ID=factory1Id
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_FACTORY2_ID=factory2Id
```

**For BitBucket Server**
Update the `codenvy.env` with `Bitbucket Server` webhooks properties:

```text  
CODENVY_BITBUCKET_SERVER_WEBHOOK1_REPOSITORY_URL=https://github.com/testrepo.git
CODENVY_BITBUCKET_SERVER_WEBHOOK1_WEBHOOK1_FACTORY1_ID=factory1Id
CODENVY_BITBUCKET_SERVER_WEBHOOK1_WEBHOOK1_FACTORY2_ID=factory2Id
```

#### Jenkins Connector 
Update the `codenvy.env` with connectors properties. Note that you can rename "WEBHOOK1" with any identifer. The system will treat Git and Jenkins Connector variables with the same name as related so ensure you have both identically named for each install:

```text  
#CODENVY_JENKINS_CONNECTOR_CONNECTOR1_FACTORY_ID=<factory id>
#CODENVY_JENKINS_CONNECTOR_CONNECTOR1_URL=<url>
#CODENVY_JENKINS_CONNECTOR_CONNECTOR1_JOB_NAME=<job name>
```

### Configure Repo Webhooks 

#### For GitHub

1. On your repository's GitHub page, go to Settings > Webhooks & services.
2. Click the "Add webhook" button.
3. In the Payload URL field enter: `http://{your-codenvy-url}/api/github-webhook`.
4. Content Type is application/json.
5. Leave the Secret field empty.
5. Select "Let me select individual events" radio button.
6. Check "Push" and "Pull Request" checkboxes.

#### For BitBucket Server

1. Log into the Bitbucket Server as an Admin
2. Install Post-Receive WebHooks plugin.
3. In repo settings, configure the plugin to use Bitbucket Server webhook: `http(s)://$codenvyURL/api/bitbucketserver-webhook`
4. Configure `bitbucket_endpoint` property with the URL of your Bitbucket Server

## Test Integration  
To trigger the email you will need to make the build fail. If everything is configured correctly the build failed email should include a "Codenvy Factory" line in the build information at the top of the email.
