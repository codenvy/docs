---
tag: [ "codenvy" ]
title: Organizations
excerpt: "Managing Organizations and group of users in Codenvy"
layout: docs
permalink: /:categories/organizations/
---
{% include base.html %}

# Organizations in Codenvy
Organization allow to regroup developers on Codenvy and allocate resources. Resources and permissions are controlled and allocated within Codenvy admin dashboard by system administrator.

## Roles
There are two different roles in an organization:  

- **Admin**: Organization's admins are able to manage the organization. Admins can edit settings, manage members, sub-organization and its resources.  
- **Members**: Organization's members are able create workspace, manage own workspaces and use any other workspaces they have permissions for.

Also there is **System Admin**, who can create root organizations, manage all the resources, members and sub-organizations.

## Organization Workspaces
Workspaces created in an organization use organization resources granted and allocated by the system administrator.

## Organization Workspace Resources
Resources for organization are taken from the parent one. Admins can control whether all, or a portion of the resources, that are shared with the sub-organization.  

## Root Organization
Root organization is the start point for other sub-organizations in the form of the tree. It can be created only by system admin, as well as it's resources are also maintained only by system admin.
There can be more than one root organization in the system.

# Creating an Organization
Codenvy system administrator is able to create organizations.   

To create an organization, use the menu in the left sidebar, which leads to the list of organizations:  
![organization-menu.png]({{base}}/docs/assets/imgs/codenvy/organization-menu.png){:style="width: 30%"}  

A new page is displayed with all root organizations in your system. Click on the top-left button to create a new organization.
![organization-list.png]({{base}}/docs/assets/imgs/codenvy/organization-list.png)

A new page is displayed in which an organization name should set and organization members may be added.
![organization-create.png]({{base}}/docs/assets/imgs/codenvy/organization-create.png)

## Organization List
The list of all organizations are displayed on organizations page:
![organization-list2.png]({{base}}/docs/assets/imgs/codenvy/organization-list2.png)

The list contains the general information for each organization: number of members, total and available RAM and number of sub-organizations.

## Adding Organization Members
Adding organization members by clicking the "Add" button will display a new popup. You can add multiple users at the same time by separating emails with a comma but note that all users added at the same time will be given the same [role]({{base}}{{site.links["admin-organizations"]}}#roles):

![organization-multiple-invites.png]({{base}}/docs/assets/imgs/codenvy/organization-multiple-invites.png)


You can change a organization member's role or remove them from the organization at any time.
![organization-create-invite-members.png]({{base}}/docs/assets/imgs/codenvy/organization-create-invite-members.png)

Note: Users with the green checkmark beside their name already have an account on your Codenvy system and will be added to the organization. Users without a checkmark do not have an account and will not be added into the organization.

## Workspaces in Organization
Workspace is created inside of an organization and uses the resources of this very organization. Workspace creator has to choose the organization on workspace creation page:
![organization-create-workspace.png]({{base}}/docs/assets/imgs/codenvy/organization-create-workspace.png)

## Create Sub-Organization

The creation of sub-organization can be done from organization details page by selecting Sub-Organizations tab and clicking "Add Sub-Organization" button.
The flow of sub-organization creation is the same as for organization one: name should be provided and members can be added. 

### Add members to Sub-Organization

The sub-organization members can be added only from the list of parent organization's members:

![sub-organization-add-members.png]({{base}}/docs/assets/imgs/codenvy/sub-organization-add-members.png)

# Organization and Sub-Organization Administration

![organization-settings.png]({{base}}/docs/assets/imgs/codenvy/organization-settings.png)

Organization settings are visible to all members of the organization, but only the Codenvy system administrator is able to modify the settings.

## Rename an Organization or Sub-Organization
**Action restricted to**: Codenvy system administrator and admins of the organization.

To rename an Organization, click in the "Name" textfield and start editing the name of the organization. Once edited, the save mode will appear - click on "Save" button to update the name.

The name of the organization is restricted to the following rules:  
- Only alphanumeric characters or a single "-" can be used  
- Spaces cannot be used in organization names  
- Each organization name must be unique within the Codenvy install
- Each sub-organization name must be unique within an organization

## Leave an Organization or Sub-Organization
This action is not possible for members of an organization. Users have to contact organization's admin or Codenvy system admin.

## Delete an Organization or Sub-Organization
**Action restricted to**: Codenvy system administrator and admins of the organization.

![organization-delete.png]({{base}}/docs/assets/imgs/codenvy/organization-delete.png){:style="width: 40%"}

To delete an organization or a sub-organization, click on "Delete" button.
This action can't be reverted and all workspaces created under the organization will be deleted.

All members of the organization will receive an email notification to inform about organization deletion.

## Manage Organization and Sub-Organization Limits
**Action restricted to**: Codenvy system administrator and admins of the organization.

The organization default caps are taken from the system configuration. The admin of the organization can manage only the limits of it's sub-organizations.
By default, there are no resource limits applied to the organization so all members can benefit from all the allocated resources. If an organization admin wishes to set limits they have three options:  
- **Workspace Cap**: The maximum number of workspaces that can exist in the organization.  
- **Running Workspace Cap**: The maximum number of workspaces which can run simultaneously in the organization.  
- **Workspace RAM Cap**: The maximum total RAM organization workspaces can use in GB.  

## Update Organization and Sub-Organization Member Roles
**Action restricted to**: Codenvy system administrator and admins of the organization.

To edit the role of a organization member click on the "Edit" button in the "Actions" column:
![organization-edit-role-action.png]({{base}}/docs/assets/imgs/codenvy/organization-edit-role-action.png)

You'll get a popup where you can update the role of the selected member:
![organization-edit-role.png]({{base}}/docs/assets/imgs/codenvy/organization-edit-role.png)

Click "Save" to confirm the update.


## Remove Organization and Sub-Organization Members
**Action restricted to**: Codenvy system administrator and admins of the organization.

To remove a member from the organization, you can click on the "Delete" button in the "Actions" column:
![organization-remove-single-member.png]({{base}}/docs/assets/imgs/codenvy/organization-remove-single-member.png)

You'll get a confirmation popup, where you can confirm or cancel your action.

You can also select multiple members from the organization, using the checkboxes. A delete button will appear in the header of the table:
![organization-remove-members.png]({{base}}/docs/assets/imgs/codenvy/organization-remove-members.png)

The members that are removed from the organization will receive an email notification.


