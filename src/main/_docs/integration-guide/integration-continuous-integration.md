---
tag: [ "codenvy" ]
title: Continuous Integration
excerpt: ""
layout: docs
permalink: /:categories/continuous-integration/
---
{% include base.html %}

Codenvy can use [Factories]({{base}}{{site.links["factory-getting-started"]}}) with a Jenkins CI system to generate developer workspaces pre-configured with the context of the CI job. For example, a failed CI build email can be customized to include a link to two factories that open a workspace pre-configured to:
* The branch and commit ID that broke the build for the project. 
* The head of the master branch for the project.

These Factories are included in the Jenkins job description and in the email notifications, speeding diagnosis and resolution for failed builds and giving anyone a quick way to run or debug the latest build.

Because configuring this integration requires system-level property settings it can only be used by customer with Codenvy installed [on-premises]({{base}}{{site.links["admin-installation"]}}).

If you'd like to speak to us about an integrations between Codenvy and another CI system, [please contact us](https://codenvy.com/contact/questions/).

# Configuring the Integration

## Set up Plugins  
Go to **Manage Jenkins - Manage Plugins** and install:
1. GitHub plug-in
2. Post-Build script plug-in
3. Email extension template plug-in.

![plugins.png]({{base}}/docs/assets/imgs/codenvy/plugins.png)

## Create a Jenkins Job  
(Skip this step if you have your Jenkins job already set up).

Set up a Jenkins Job that matches your project requirements (JDK, Maven, Node.js etc). You may need to install additional plugins that your project requires.

## Configure the Jenkins Job's Post Build Actions  
Once a Jenkins job is set up you need to make sure that an email is sent out when a job succeeds or fails. You should use a [.jelly template]({{base}}/docs/integration-guide/html-factory.jelly) as the default message template. Download it and save to `/var/lib/jenkins/email-templates/html-factory.jelly` on the instance where Jenkins runs.

In the **Post-build Actions** configuration section:

### Add an Editable Email Notification Task
In the task add the following message content: `${JELLY_SCRIPT,template="html-factory"}`. For example:

![postbuild.png]({{base}}/docs/assets/imgs/codenvy/postbuild-email-notification.png)

### Add an Execute a Set of Scripts Task
Inside that panel's **Execute shell** build step insert the following command:

```
curl -H "Content-Type: application/json" -H "Jenkins-Event: jenkins" -X POST -d '{"jobName" : "'$JOB_NAME'", "buildId" : "'$BUILD_ID'", "jenkinsUrl" : "'$JENKINS_URL'", "repositoryUrl" : "<http(s) repository url>"}' <Codenvy url>/api/jenkins-webhook
```

![postbuild.png]({{base}}/docs/assets/imgs/codenvy/postbuild-script.png)

## Create a Codenvy Factory  

You need a Codenvy Factory configured to use the project you want associated with your Jenkins job. This Factory will be modified by the plugin and injected into Jenkins job emails. See: [Factories]({{base}}{{site.links["factory-creating"]}}).

Your Factory will need to outline the location of the git repo associated with the job and the default branch.

```
  "source": {
          "location": "https://github.com/che-samples/console-ruby-simple.git",
          "type": "git",
          "parameters": {
            "branch": "TEST-1"
          }
        }
```

## Set Codenvy Environment Variables

### Credentials

Update the `codenvy.env` with the username and password of the user who created the Factory in Codenvy. You only need one user for all the Factories used by your Jenkins integration:

```text
CODENVY_INTEGRATION_FACTORY_OWNER_USERNAME=somebody@somemail.com
CODENVY_INTEGRATION_FACTORY_OWNER_PASSWORD=password
```

### Git
The Jenkins integration supports both GitHub and BitBucket Server repos.

#### For GitHub

Update the `codenvy.env` with `GitHub` webhooks properties. Note that you can rename "WEBHOOK1" with any identifier. Webhooks are tied to connectors through Factory IDs. There can be multiple webhooks (if you need to receive webhooks from multiple repositories) - in this case, add a new entry with a different name for WEBHOOKID and FACTORY1_ID.

```text  
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_REPOSITORY_URL=https://github.com/example/testrepo.git
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_FACTORY1_ID=factory1Id
```

One webhook can update more than one Factory. Add a different Factory identifier, for example `FACTORY2_ID`:

```text
CODENVY_GITHUB_WEBHOOK_WEBHOOK1_FACTORY2_ID=factory2Id
```

In this case, the webhook with ID `WEBHOOK_WEBHOOK1` will update two Factories - `FACTORY1_ID` and `FACTORY2_ID`.

#### BitBucket Server

Update the `codenvy.env` with `Bitbucket Server` webhooks properties. Webhooks are tied to connectors through Factory IDs. There can be multiple webhooks (if you need to receive webhooks from multiple repositories) - in this case, add a new entry with a different name for WEBHOOKID and FACTORY1_ID.

```text  
CODENVY_BITBUCKET_SERVER_WEBHOOK_WEBHOOKID_REPOSITORY_URL=https://github.com/eclipse/che
CODENVY_BITBUCKET_SERVER_WEBHOOK_WEBHOOKID_FACTORY1_ID=hfdhfd749347hd64

```

One webhook can update more than one Factory. Add a different Factory identifier, for example `FACTORY2_ID`:

```text
CODENVY_BITBUCKET_SERVER_WEBHOOK_WEBHOOKID_FACTORY2_ID=hfdhfd749347hd64
```

In this case, webhook with ID `WEBHOOK_WEBHOOK1` will update 2 Factories - `FACTORY1_ID` and `FACTORY2_ID`.

### Jenkins Connector
Update the `codenvy.env` with the connectors properties. Note that you can rename "CONNECTOR1" to anything you want. The system will match the Git and Jenkins Connector variables using the Factory IDs. You can setup as many connectors as you need: CONNECTOR1, CONNECTOR2, CONNECTORx, etc...:

```text  
CODENVY_JENKINS_CONNECTOR_CONNECTOR1_FACTORY_ID=r6p0l1sfnwm99k94
CODENVY_JENKINS_CONNECTOR_CONNECTOR1_URL=http://userName:password@jenkins.codenvy-dev.com:8080
CODENVY_JENKINS_CONNECTOR_CONNECTOR1_JOB_NAME=new_job
```

A Jenkins user should have write access to a targeted Jenkins job in order to update it.

### Configure Repo Webhooks
The Jenkins integration supports both GitHub and BitBucket Server repos.

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
