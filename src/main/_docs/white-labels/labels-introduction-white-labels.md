---
tag: [ "codenvy" ]
title: Introduction
excerpt: "White labeling is for embedding, distributing, or hosting Codenvy as part of another brand."
layout: docs
permalink: /:categories/introduction-white-labels/
---
{% include base.html %}
A Codenvy white label is the ability to embed Codenvy within another product, or to customize Codenvy with your own extensions or brand identity. You may add extensions for the IDE or workspaces, remove default extensions (such as the Node.JS debugger), modify the user interface and create custom integrations to other tools.

# OEM License
**White labelling requires an OEM license.** The free Fair Source 3 license that ships with Codenvy and our enterprise license do not provide redistribution rights. Please [contact sales@codenvy.com](https://codenvy.com/contact/sales/) to obtain an OEM license.

# Extending Codenvy 
White label licensees often wish to add new features to Codenvy. This can be done by creating Eclipse Che extensions and plugins which will work with Codenvy or Eclipse Che. Eclipse Che docs include an extensive section on [building extensions and plugins](https://www.eclipse.org/che/docs).

## Creating Custom Assemblies  
If you create custom Eclipse Che extensions that you want to deploy within Codenvy, you will need to create a custom assembly {%assign docs_todo="need location or add"%}. A custom assembly is a new Codenvy binary that is runnable by our Docker infrastructure. It's simple and easy to build one.

# Modifying the User Interface  
It's possible to customize nearly any portion of the user interface, however there are several customizations that are commonly requested.

## Changing the Codenvy Logo
All branding is located in `dashboard/src/assets/branding`:
- `codenvy-logo.svg` is used in loading screens.
- `codenvy-logo-text.svg` is displayed in the left navbar's menu at the top.

To change the logo replace those two files with your organization's logo (match the size of the existing codenvy.svg files to avoid resizing issues). Then set the links to them in product.json {%assign docs_todo="need location or add"%} file:

```json  
"logoFile": "my-corp-logo.svg\n"logoTextFile": "my-corp-logo-text.svg"
```
The `product.json` file is also where you can change the Codenvy title and Favicon files.

## Changing the Help Links
The Help menu button in the footer can be changed in the `dashboard/src/assets/branding/product.json` file:

```json  
"helpPath": "https://codenvy.com/support/\n"helpTitle": "Help"
```

## Removing the Codenvy Loader
To remove the loader from the splash screen, delete the appropriate lines in:
- [index html, line 64](https://github.com/codenvy/codenvy/blob/master/dashboard/src/index.html#L64)
- [load-factory.html, line 66](https://github.com/codenvy/codenvy/blob/master/dashboard/src/app/factories/load-factory/load-factory.html#L66)

## Changing the Left Navbar
The colors of the navigation menu are configured in [navbar-theme.styl](https://github.com/codenvy/codenvy/blob/master/dashboard/src/app/navbar/navbar-theme.styl):

```json  
$onprem-navbar-backgroud-color #background color of the menu
$onprem-navbar-active-menu-background-color #background color of selected menu item
$onprem-navbar-border-right-color #color of the right border of selected item
$onprem-navbar-menu-icon-color #menu icon’s color
$onprem-navbar-active-menu-icon-color #selected menu item's color
$onprem-navbar-menu-text-color - #text color of menu item
$onprem-navbar-active-menu-text-color - #text color of selected menu item
$onprem-navbar-menu-number-color #color of number in brackets
$onprem-navbar-recent-workspaces-stopped-color - #recent workspaces items color in stopped state\
```

## Removing the "Make a Wish" Widget
This widget is configured to send emails to Codenvy with the comments written by users. To remove this widget in the footer, remove the `che-support-email` attribute in the `che-footer element` in the index.html:

```html  
#remove this section
<che-footer id="codenvyfooter" che-support-help-path="{{branding.helpPath}}" che-support-help-title="{{branding.helpTitle}}" che-support-email="{{branding.supportEmail}}" che-product-name="Codenvy" ng-show="waitingLoaded && !showIDE"></che-footer>
```
Alternatively you can leave the widget but change the link to point to your own organization's email by changing the `helpPath` and `supportEmail` attributes in the product.json {%assign docs_todo="need location or add"%} file.
