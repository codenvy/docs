---
tag: [ "codenvy" ]
title: Teams
excerpt: ""
layout: docs
permalink: /:categories/teams/
---
{% include base.html %}

# Teams in Codenvy
Teams allow groups of developers to collaborate with private and shared workspaces. Resources and permissions are controlled and allocated within the team by the team administrator.

## Roles
There are three different roles in a team:
- **Owner**: The team owner is the user who creates the team. It is the owner's resources that are allocated within the team. Team owners can define limits on the resources that team members can use.
- **Admin**: Team's admins are able to manage the team. Admins can edit settings, manage workspaces, resources and members.
- **Developer**: Team's developers are the able create workspace, manage own workspaces and use any other workspaces they have permissions for.

## Team's workspaces

Team's workspaces are workspaces that are living under the team and benefit from the team's resources. They can be shared with all the other team members or only with subset of them.

## Team's resources

A team benefits from the resources the team's owner is having. Any team's workspace that is started from a team member will consume resources from the team's owner. As owner of the team, it is possible to share all or only a portion of the resources you are owning.

On Codenvy.io, any user is granted 3 free GB of RAM which can be used either for personal workspaces or team workspaces.
It is possible to buy more RAM, learn more here [TODO: add link to billing and subscriptions].

## Team's settings

Admins of a team are able to configure various settings for the team:
- **Workspace Cap**: The maximum number of workspaces that can exist in the team. This allows to limit the number of workspaces.
- **Running Workspace Cap**: The maximum number of workspaces which can run simultaneously in the team.
- **Workspace RAM Cap**: The maximum RAM a single workspace can use in GB. This allows to limit the resources a workspace can use.

[TODO: add mention about idle tiemout for codenvy.io]


# Create a Team

Any user on Codenvy is able to create a team and invite other users to collaborate in the team. The user who is creating the team is designated as the owner of the team, who is sharing his resources with the team.

To create a team, use the menu in the left sidebar:
![team-menu.png]({{base}}/docs/assets/imgs/codenvy/team-menu.png){:style="height: 40%; width: 40%"}

A new page is displayed which propose a form to provide a name to the team and invite other members.
![team-create.png]({{base}}/docs/assets/imgs/codenvy/team-create.png)

The name of the team is restricted to the following rules:
- Only alphanumeric characters or a single "-" can be used
- You can't create multiple teams with the same name
- Space characters are not allowed

It is possible to invite other users into the team while you are creating it. Click on the button "Add" under the _Developers_ section, it will display a new popup where you can provide information about the users to invite:
![team-invite.png]({{base}}/docs/assets/imgs/codenvy/team-invite.png)

Provide email address of the other users you want to invite. You can invite multiple users at the same time, by separating the email addresses using comma ",".
![team-multiple-invites.png]({{base}}/docs/assets/imgs/codenvy/team-multiple-invites.png)

Grant the appropriate role to the users you are inviting in your team (refer to the definition of roles [TODO: include link]).

Once added the users will be listed. You can adjust the roles or decide to cancel invitation by removing the users.
![team-create-invite-members.png]({{base}}/docs/assets/imgs/codenvy/team-create-invite-members.png)

Note: the users with the green checkmark are the users who already have an account. The users who don't have an account will receive an email to

Confirm the creation of the team by clicking "Create Team" button.

An email notification will be sent to the invited users.

# Team Administration

Owner and admins are able to:
- configure settings of a team
- manage members
- manage workspaces

## Teams settings

![team-settings.png]({{base}}/docs/assets/imgs/codenvy/team-settings.png)

Teams settings are visible to all members of the team independently of their role in the team.
Only the team owner and admins are able to modify the settings.

### Rename a Team
**Action restricted to**: Owner and Admins of the team.

To rename a team, click in the "Name" textfield and start editing the name of the team.

![team-rename.png]({{base}}/docs/assets/imgs/codenvy/team-rename.png)

Once edited, the team name will automatically be saved and applied.
All members of the team will receive an email notification to inform about the new team name.

The name of the team is restricted to the following rules:
- Only alphanumeric characters or a single "-" can be used
- You can't create multiple teams with the same name
- Space characters are not allowed

### Manage Team Caps
**Action restricted to**: Owner of the team.

![team-caps-limits.png]({{base}}/docs/assets/imgs/codenvy/team-caps-limits.png)

It is possible to apply certain caps to the team. As an team owner, you might want to control how the team can be used by other team members.
In order to do that, you have the ability to configure:
- **Workspace Cap**: The maximum number of workspaces that can exist in the team.
- **Running Workspace Cap**: The maximum number of workspaces which can run simultaneously in the team.
- **Workspace RAM Cap**: The maximum RAM a single workspace can use in GB. This allows to limit the resources a workspace can use.

By default, there are no caps applied to the team and a team workspace can use all the resource of the team's owner account.

### Delete a Team
**Action restricted to**: Owner of the Team.

![team-delete.png]({{base}}/docs/assets/imgs/codenvy/team-delete.png)

To delete a team, click on "Delete" button.
This action can't be reverted and all team's workspaces will be deleted.

All members of the team will receive an email notification to inform about team deletion.


## Manage members

You can manage members of the team, invite new users, update member's under the "Members" tab of team's details.

![team-manage-members.png]({{base}}/docs/assets/imgs/codenvy/team-manage-members.png)

### Invite members
**Action restricted to**: Owner and Admins of the team.

It is possible to invite new users into the team at any time. Click on the button "Add Member" button under the _Developers_ section, it will display a new popup where you can provide information about the users to invite:
![team-invite.png]({{base}}/docs/assets/imgs/codenvy/team-invite.png)

Provide email address of the other users you want to invite. You can invite multiple users at the same time, by separating the email addresses using comma ",".
![team-multiple-invites.png]({{base}}/docs/assets/imgs/codenvy/team-multiple-invites.png)

Grant the appropriate role to the users you are inviting in your team (refer to the definition of roles [TODO: include link]).

Once added the users will be listed and an email notification will be sent to the invited users.
. You can adjust the roles or decide to remove members from the team.
![team-manage-members.png]({{base}}/docs/assets/imgs/codenvy/team-manage-members.png)  

### Update member's role
**Action restricted to**: Owner and Admins of the team.

To edit the role of a team's member, just click on the "Edit" button in the "Actions" column:
![team-edit-role-action.png]({{base}}/docs/assets/imgs/codenvy/team-edit-role-action.png)

You'll get a popup where you can update the role of the selected member:
![team-edit-role.png]({{base}}/docs/assets/imgs/codenvy/team-edit-role.png)

Click "Save" to confirm the update.

### Remove members
**Action restricted to**: Owner and Admins of the team.

To remove a member from the team, you can click on the "Delete" button in the "Actions" column:
![team-remove-single-member.png]({{base}}/docs/assets/imgs/codenvy/team-remove-single-member.png)

You'll get a confirmation popup, where you can validate or cancel your action.

You can also select multiple members from the team, using the checkboxes. A delete button will appear in the header of the table:
![team-remove-members.png]({{base}}/docs/assets/imgs/codenvy/team-remove-members.png)

The members that are removed from the team will receive an email notification.

## Manage workspaces
Members of the team are able to browse certain team's workspaces, create new workspaces and manage them under the "Workspaces" tab of team's details.

![team-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-workspaces.png)


#### Browse workspaces

The "Workspaces" tab of a team's details allow to see the workspaces from the team:
- **Owner and Admins**: will see all the workspaces existing in the team.
- **Developers**: will see only the workspaces they created or they have been invited into.

Click on a workspace to access its details and administrate or use it. Learn more about workspace [TODO add link].

It is also possible to access the workspaces of teams in the "Workspaces" page from Dashboard:
![team-list-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-list-workspaces.png)

### Create a team workspace

All members of a team are able to create workspace in a team.

Click on "Add Workspaces" to get the form to create a new team workspace.
Team workspaces allow the same configuration as all workspace, you can lear more here. [TODO add link]

When you are member of multiple teams, you can select in which team the workspace will be created:
![team-create-workspace-select-team.png]({{base}}/docs/assets/imgs/codenvy/team-create-workspace-select-team.png)

You always have the choice to keep your workspace personal, by selecting "personal" under the team selector.

### Share a workspace

As **team owner or admin**, you are able to share the workspace to all members of the team.
This can be done by selecting the option "Share with all team members".

[TODO add snapshot when implem finished]

As **team developer**, you can share the team workspace with other team members by using the "Share" tab under the workspace's details.
You can select which team members can access to the workspace you created under the team.

[TODO add snapshot when implem finished]

### Manage workspaces

As **team owner or admin**, you can manage the workspaces of the team.

Click on the workspace to get its details and to reconfigure the workspace's configuration.

You can stop a workspace by click on the stop button, or directly from the workspace's details:
![team-stop-workspace.png]({{base}}/docs/assets/imgs/codenvy/team-stop-workspace.png)

To remove workspaces from the team, use the checkboxes to select a single or multiple workspaces. A delete button will appear in the header of the table:
![team-remove-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-remove-workspaces.png)

You'll get a confirmation popup, where you can validate or cancel your action.

As **team developer**, those actions are restricted to the workspace that you created and own in the team.


# Use Teams

When you are using a team, you are using the resources own by the team's owner which is also controlling certain caps. [TODO add link].

Depending on the team settings, you can get error messages while trying to do certain action:
- restriction on workspace creation: the **workspace cap** defines the maximum number of workspaces that can exist in the team. When the cap is reached, you'll not be able to create new workspaces anymore in the team.
- restriction on workspace starting: the owner of the team can limit the number of workspace which can run simultaneously in the team. As result, if the limit is reached, you'll get an error message while trying to start a workspace. Owner of the team can also configure the workspace RAM cap and limit the available RAM for the team. If the available RAM is not enough to start your workspace, you'll get an error message.
