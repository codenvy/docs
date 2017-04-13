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
There are three different roles in an organization:  

- **Admin**: Organization's admins are able to manage the organization. Admins can edit settings, manage members, resources and sub-organization.  
- **Members**: Organization's members are able create workspace, manage own workspaces and use any other workspaces they have permissions for.  

## Organization Workspaces
Workspaces created in an organization use organization resources granted and allocated by the system administrator.

## Organization Workspace Resources
Resources for team are taken from the owner's resource pool. Owners can control whether all, or a portion of their resources are shared with the team.  

## Root Organization
(to be detailled)

# Creating an Organization
Codenvy system administrator are able to create organizations.   

To create an organization, use the menu in the left sidebar to display the list of organizations:  
![organization-menu.png]({{base}}/docs/assets/imgs/codenvy/organization-menu.png){:style="width: 30%"}  

A new page is displayed with all current organizations in your system. Click on the top-left button to create a new organization.
![organization-list.png]({{base}}/docs/assets/imgs/codenvy/organization-list.png)

A new page is displayed in which an organization name is set and organization members are added.
![organization-create.png]({{base}}/docs/assets/imgs/codenvy/organization-create.png)

## Organization List
The list of all organizations are displayed on dashboard page:
![organization-list2.png]({{base}}/docs/assets/imgs/codenvy/organization-list2.png)

## Adding Organization Members
Adding organization members by clicking the "Add" button will display a new popup. You can add multiple users at the same time by separating emails with a comma but note that all users added at the same time will be given the same [role]({{base}}{{site.links["admin-organizations"]}}#roles):

![organization-multiple-invites.png]({{base}}/docs/assets/imgs/codenvy/organization-multiple-invites.png)


You can change a organization member's role or remove them from the organization at any time.
![organization-create-invite-members.png]({{base}}/docs/assets/imgs/codenvy/organization-create-invite-members.png)

Note: Users with the green checkmark beside their name already have an account on your Codenvy system and will be added to the organization. Users without a checkmark do not have an account and will not be added into the organization.

## Workspaces in Organization
(to be detailled)

## Create Sub-Organization
(to be detailled)

### Add members to Sub-Organization


# Organization and Sub-Organization Administration

![organization-settings.png]({{base}}/docs/assets/imgs/codenvy/organization-settings.png)

Organization settings are visible to all members of the organization, but only the Codenvy system administrator is able to modify the settings.

## Rename an Organization or Sub-Organization
**Action restricted to**: Codenvy system administrator and admins of the organization.
To rename an Organization, click in the "Name" textfield and start editing the name of the organization. Once edited, the organization name will automatically be saved and applied. When a organization is renamed all members of the organization will receive an email notification with the new organization name.

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
(to be defined: where the organization default caps are taken from)
By default, there are resource limits applied to the organization so all members can benefit from all the allocated resources. If an organization admin wishes to set limits they have three options:  
- **Workspace Cap**: The maximum number of workspaces that can exist in the organization.  
- **Running Workspace Cap**: The maximum number of workspaces which can run simultaneously in the organization.  
- **Workspace RAM Cap**: The maximum RAM each single workspace can use in GB.  

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

You'll get a confirmation popup, where you can validate or cancel your action.

You can also select multiple members from the organization, using the checkboxes. A delete button will appear in the header of the table:
![organization-remove-members.png]({{base}}/docs/assets/imgs/codenvy/organization-remove-members.png)

The members that are removed from the organization will receive an email notification.
