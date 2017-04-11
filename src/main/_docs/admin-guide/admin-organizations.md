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

On Codenvy.io, all users are granted 3 free GB of RAM which can be used either for personal workspaces or team workspaces. Additional RAM can be purchased to provide more resources for personal or team use, learn more [here]({{base}}{{site.links["user-subscriptions"]}}).
