---
tag: [ "codenvy" ]
title: Troubleshooting
excerpt: "Diagnose and fix issues with your Codenvy install."
layout: docs
permalink: /:categories/troubleshoot/
---
{% include base.html %}

|Error |Action&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|---|---|
|`Error response from docker API, status: 500, message: No healthy node available in the cluster`|Check that port 23750 is open on all your nodes (master and workspace nodes).|
