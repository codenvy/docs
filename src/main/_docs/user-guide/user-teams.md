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
- **Developer**: Team's developers are able create workspace, manage own workspaces and use any other workspaces they have permissions for.  

## Team Workspaces
Workspaces created in a team use team resources and can be shared with all, or a subset of team members.  

## Team Workspace Resources
Resources for team are taken from the owner's resource pool. Owners can control whether all, or a portion of their resources are shared with the team.  

On Codenvy.io, all users are granted 3 free GB of RAM which can be used either for personal workspaces or team workspaces. Additional RAM can be purchased to provide more resources for personal or team use, learn more [here]({{base}}{{site.links["user-subscriptions"]}}).  

# Creating a Team
All users are able to create a team and invite other users to join it. The user who creates a team is designated as the team owner and controls the resources shared with the team.  

To create a team, use the menu in the left sidebar:  
![team-menu.png]({{base}}/docs/assets/imgs/codenvy/team-menu.png){:style="width: 30%"}  

A new page is displayed in which a team name is set and team members are added.
![team-create.png]({{base}}/docs/assets/imgs/codenvy/team-create.png)  

## Adding Team Members
Adding team members by clicking the "Add" button will display a new popup. You can add multiple users at the same time by separating emails with a comma but note that all users added at the same time will be given the same [role]({{base}}{{site.links["user-teams"]}}#roles):

![team-multiple-invites.png]({{base}}/docs/assets/imgs/codenvy/team-multiple-invites.png)


You can change a team member's role or remove them from the team at any time.
![team-create-invite-members.png]({{base}}/docs/assets/imgs/codenvy/team-create-invite-members.png)

Note: Users with the green checkmark beside their name already have a Codenvy account and will be invited to join the team. Users without a checkmark are not found in the Codenvy system. Team owners should contact those users separately to have them create a Codenvy account so that they can be added to the team.

## Team Workspaces
Members of the team are able to browse certain team's workspaces, create new workspaces and manage them under the "Workspaces" tab of the team's page.

![team-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-workspaces.png)

### Browse Workspaces
- **Owner and Admins**: will see all the workspaces in the team.
- **Developers**: will see only the workspaces they created or that they have been invited to.

Click on a workspace to access its details or use it. Learn more about [workspaces]({{base}}{{site.links["ws-admin-intro"]}}).

Alternatively, team workspaces can be accessed along with personal workspaces in the "Workspaces" page from Dashboard:
![team-list-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-list-workspaces.png)

### Create a Team Workspace

All members of a team are able to create workspaces in a team by clicking the "Add Workspaces" button. Team workspaces are administered in the same way as personal workspaces.

When you are member of multiple teams, you must select which team the workspace will be created in:
![team-create-workspace-select-team.png]({{base}}/docs/assets/imgs/codenvy/team-create-workspace-select-team.png)

You always have the choice to keep your workspace private - just select "personal" under the team selector.

Note that when you are using a team, resources come from the team owner's account and may be subject to [resource caps]({{base}}{{site.links["user-teams"]}}#manage-team-limits).

Depending on the team settings, you may get error messages while trying to do certain action:
- Restriction on workspace creation: The owner has set a limit on the total number of workspaces that can be created and this limit has been reached.
- Restriction on workspace starting: The owner of the team has limited the number of workspaces that can run simultaneously in the team and this limit has been reached.

### Share a Workspace

{% assign TODO="As a **team owner or admin**, you are able to share workspaces with all members of the team by selecting the "share with all team members" option.[TODO add snapshot when implem finished]" %}

As a **team developer**, you can share workspaces with other team members by using the "Share" tab under the workspace's details. You can control which team members can access to the workspace. The wizard show you the team members that are not yet invited into the workspace.

![team-workspace-share.png]({{base}}/docs/assets/imgs/codenvy/team-workspace-share.png)

{% assign TODO="Update the image after merged" %}

### Manage Workspaces
Team workspaces can be managed by team owners, team admins or a team member if they created the specific workspace.

To stop workspaces:
![team-stop-workspace.png]({{base}}/docs/assets/imgs/codenvy/team-stop-workspace.png)

To remove workspaces, use the checkboxes to select a single or multiple workspaces. A delete button will appear in the header of the table:
![team-remove-workspaces.png]({{base}}/docs/assets/imgs/codenvy/team-remove-workspaces.png)

# Team Administration

![team-settings.png]({{base}}/docs/assets/imgs/codenvy/team-settings.png)

Team settings are visible to all members of the team, but only the team owner and admins are able to modify the settings.

## Rename a Team
To rename a team, click in the "Name" textfield and start editing the name of the team. Once edited, the team name will automatically be saved and applied. When a team is renamed all members of the team will receive an email notification with the new team name.

The name of the team is restricted to the following rules:  
- Only alphanumeric characters or a single "-" can be used  
- Spaces cannot be used in team names  
- Each team name must be unique within the Codenvy install  

## Delete a Team
**Action restricted to**: Owner of the Team.

![team-delete.png]({{base}}/docs/assets/imgs/codenvy/team-delete.png){:style="width: 40%"}

To delete a team, click on "Delete" button.
This action can't be reverted and all team's workspaces will be deleted.

All members of the team will receive an email notification to inform about team deletion.

## Manage Team Limits
By default, there are no resource limits applied to the team so team workspaces can use all the resources of the team owner's account. If a team owner wishes to set limits they have three options:  
- **Workspace Cap**: The maximum number of workspaces that can exist in the team.  
- **Running Workspace Cap**: The maximum number of workspaces which can run simultaneously in the team.  
- **Workspace RAM Cap**: The maximum RAM each single workspace can use in GB.  

Note that codenvy.io has a built-in workspace idle timeout of 10 minutes for free accounts (paid accounts receive a 4 hours timeout). Locally installed Codenvy instances default to a 6 hour idle timeout, but this can be set in the `codenvy.env`.

## Update Team Member Roles
**Action restricted to**: Owner and Admins of the team.

To edit the role of a team member click on the "Edit" button in the "Actions" column:
![team-edit-role-action.png]({{base}}/docs/assets/imgs/codenvy/team-edit-role-action.png)

You'll get a popup where you can update the role of the selected member:
![team-edit-role.png]({{base}}/docs/assets/imgs/codenvy/team-edit-role.png)

Click "Save" to confirm the update.

## Remove Team Members
**Action restricted to**: Owner and Admins of the team.

To remove a member from the team, you can click on the "Delete" button in the "Actions" column:
![team-remove-single-member.png]({{base}}/docs/assets/imgs/codenvy/team-remove-single-member.png)

You'll get a confirmation popup, where you can validate or cancel your action.

You can also select multiple members from the team, using the checkboxes. A delete button will appear in the header of the table:
![team-remove-members.png]({{base}}/docs/assets/imgs/codenvy/team-remove-members.png)

The members that are removed from the team will receive an email notification.
