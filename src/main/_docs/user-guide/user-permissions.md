---
tag: [ "codenvy" ]
title: Permissions
excerpt: ""
layout: docs
permalink: /:categories/permissions/
---
{% include base.html %}

# Permissions in Codenvy
In Codenvy, we define a permission as statement that defines an action or a behaviour which can be applied to resources. Permissions define "what" can be done on certain resources. For example there is a permission to read workspace and there is another permission to use it. The permissions are the low-grained level of security policies.

Codenvy also provides a mechanisms and layers which allow to define "who" is allowed to do "what". Any user and administrator can control resources managed by Codenvy and allow certain actions or behaviors for other users or group of users.

For example:
- As owner of a workspace, you can grant other users to see and/or use your workspace.

Permissions are applicable on certain type of resources:
- Workspace
- Organization
- Stack
- Recipe
- System

Permissions can be assigned to:
- Users
- Group of Users (see Teams)


# Permissions for Workspaces

Owner of a workspace is getting full permissions on the workspace.
User who creates the workspace is the owner of the workspace and getting full permissions on it.
Workspace's owner can invite other users to the workspace and grant them certain permissions.
The following permissions are applicable to workspaces:

| Permission      | Description                                             |
| --------------- | ------------------------------------------------------- |
| read            | Allows to read a workspace's configuration.             |
| use             | Allows to use a workspace and interact with it.         |
| run             | Allows to start and stop a workspace.                   |
| configure       | Allows to define workspace configuration and change it. |
| setPermissions  | Allows to update permissions of other users.            |
| delete          | Allows to delete the workspace.                         |


# Permissions for Organizations

An organization is a named set of users.
Organizations are the underlying layer for Teams in Codenvy.
The following permissions are applicable to organizations:

| Permission                    | Description                                                           |
| ----------------------------- | --------------------------------------------------------------------- |
| update                        | Allows to edit organization settings and information.                 |
| delete                        | Allows to delete an organization.                                     |
| manageSuborganizations        | Allows to create and manage sub-organizations.                        |
| manageResources               | Allows to redistribute organization’s resources and define CAPs.      |
| manageWorkspaces              | Allows to create new and manage all team's workspaces.                |
| setPermissions                | Allows user to invite/remove members to team , update permissions.    |



# Permissions for System

System represent the Codenvy installation.
The following permissions are applicable to organizations:

| Permission                    | Description                                                           |
| ----------------------------- | --------------------------------------------------------------------- |
| manageSystem                  | Allows to control system, workspaces and organizations.               |
| setPermissions                | Allows to update permissions of users on the system.                  |
| manageUsers                   | Allows to create and manage users.                                    |


## Super priviliged mode

The permission "manageSystem" can be extended to provide super privileged mode.
The super privileged mode allows any user with "manageSystem" permission to perform advanced actions on any resources managed by the system. The user with "manageSystem" permission is able read and stop any workspaces. To perform other actions on workspaces and organizations, the user will need to assign himself the permissions needed.


By default, this mode is disable.
It is possible to activate this option by configuring the `CODENVY_SYSTEM_SUPER_PRIVILEGED_MODE` in the `codenvy.env` file.


# Permissions for Stacks

Stack are defined [TODO: link]
The following permissions are applicable to a stack:

| Permission                    | Description                                                           |
| ----------------------------- | --------------------------------------------------------------------- |
| search                        | Allows the stack to be returned from search requests.                 |
| read                          | Allows to get the stack configuration.                                |
| update                        | Allows to update stack's configuration.                               |
| delete                        | Allows to delete the stack.                                           |
| setPermissions                | Allows manage permissions on the stack.                               |

# Permissions for Recipe

Recipe are defined [TODO: link]
The following permissions are applicable to a recipe:

| Permission                    | Description                                                           |
| ----------------------------- | --------------------------------------------------------------------- |
| search                        | Allows the recipe to be returned from search requests.                |
| read                          | Allows to get the recipe.                                             |
| update                        | Allows to update the recipe.                                          |
| delete                        | Allows to delete the recipe.                                          |
| setPermissions                | Allows manage permissions on the recipe.                              |


# Permissions API

All permissions can be managed by using the provided Rest API. The APIs are documented using Swagger, as explained here [TODO: link].
The permissions API list can be visible here: [{host}/swagger/#!/permissions]().

## Get the list of applicable permissions per resources

You can get the list of permissions which can be applied to a specific resources, by using the following API:
GET /permissions : [{host}/swagger/#!/permissions/getSupportedDomains]()

Applicable `domain` values are the following:

| Domain                     |
| -------------------------- |
| system                     |
| organization               |
| workspace                  |
| stack                      |
| recipe                     |

Note: `domain` is optional, in this case the API will return all possible permissions for all domains.

## Get applied permissions list

The Rest API allow to request what are the permissions that you have on a specific resource.
You can use the following API for that:
GET /permissions/{domain} : [{host}/swagger/#!/permissions/getCurrentUsersPermissions]()

Applicable `domain` values are the following:

| Domain                     |
| -------------------------- |
| system                     |
| organization               |
| workspace                  |
| stack                      |
| recipe                     |

`instance` parameter corresponds to the ID of the resource you want to get the applied permissions.

## Get all permissions applied to a specific resources

It is possible to get the list of all permissions applied for all users on a specific resource. If you are granted enough privileges on the resource you are looking for, you can use the following API:
GET /permissions/{domain}/all : [{host}/swagger/#!/permissions/getUsersPermissions]()

Applicable `domain` values are the following:

| Domain                     |
| -------------------------- |
| system                     |
| organization               |
| workspace                  |
| stack                      |
| recipe                     |

`instance` parameter corresponds to the ID of the resource you want to get the applied permissions for all users.

## Assign permissions

Assigning permissions to a resource can be done by using the following API:
POST /permissions : [{host}/swagger/#!/permissions/storePermissions]()

Applicable `domain` values are the following:

| Domain                     |
| -------------------------- |
| system                     |
| organization               |
| workspace                  |
| stack                      |
| recipe                     |

`instance` parameter corresponds to the ID of the resource you want to get the applied permissions for all users.

`userId` parameter corresponds to the ID of the user who want to grant certain permissions.

Sample `body` to grant user `userID` permissions to a workspace `workspaceID`:

```json
{
  "actions": [
    "read",
    "use",
    "run",
    "configure",
    "setPermissions"
  ],
  "userId": "userID",
  "domainId": "workspace",
  "instanceId": "workspaceID"
}
```
