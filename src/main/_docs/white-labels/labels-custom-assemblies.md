---
tag: [ "codenvy" ]
title: Custom Assemblies
excerpt: "Build your own Codenvy binaries"
layout: docs
permalink: /:categories/custom-assemblies/
---
{% include base.html %}

You can create new assemblies (binaries) for Codenvy. An assembly can contain Eclipse Che extensions, custom stacks, and templates that appear in the dashboard and IDE.  You create the binary from Codenvy source code and then use the embedded Puppet system to update Codenvy with your new binary. Your binary can optionally include Eclipse Che extensions. [Eclipse Che extensions](http://www.eclipse.org/che/docs) can be created as part of your Codenvy project, or previously compiled and uploaded to maven. 

Codenvy runs as a set of distributed Docker containers. The core runtime is a Codenvy server that runs on a Tomcat instance in the Docker container. This process shows you how to build a new set of binaries for deployment into Tomcat and then how to restart Codenvy's distributed services to make use of your new binary.

You will need to have a valid Eclipse Che development environment setup, which requires Java and Maven installed in order to build assemblies.

# Clone Codenvy Repository
Get the Codenvy source code repository and checkout the proper version that you would like to base your assembly off of.

```shell
git clone https://github.com/codenvy/codenvy
```

Select the version on which perform the change. For example for a custom 5.0.0 version
```shell
$ git checkout -b custom-assembly 5.0.0
```

# Customize the Assembly
You can now make source code changes to resource files to change the branding. Or, if you want to add or remove different Eclipse Che plugins, you will modify Codenvy's dependency and assembly files.

For example, let's remove the Node.JS GDB debugger from Codenvy.

```
$ cd assembly/onpremises-ide-compiling-war-ide/
```

In this folder, you will add or remove dependencies from the `<plugins>` section of `pom.xml` and edit ` src/main/resources/com/codenvy/ide/IDE.gwt.xml `to add or remove plug-ins from the IDE itself.

In the example, let remove nodejs gdb debugger dependenvy from `pom.xml` and remove NodeJS debugger from `IDE.gwt.xml` file. Here is diff output of both files:

```
diff --git a/assembly/onpremises-ide-compiling-war-ide/pom.xml b/assembly/onpremises-ide-compiling-war-ide/pom.xml
index 7a6c713..87be61e 100644
--- a/assembly/onpremises-ide-compiling-war-ide/pom.xml
+++ b/assembly/onpremises-ide-compiling-war-ide/pom.xml
@@ -250,10 +250,6 @@
         </dependency>
         <dependency>
             <groupId>org.eclipse.che.plugin</groupId>
-            <artifactId>che-plugin-nodejs-debugger-ide</artifactId>
-        </dependency>
-        <dependency>
-            <groupId>org.eclipse.che.plugin</groupId>
             <artifactId>che-plugin-nodejs-lang-ide</artifactId>
         </dependency>
         <dependency>
	 
diff --git a/assembly/onpremises-ide-compiling-war-ide/src/main/resources/com/codenvy/ide/IDE.gwt.xml b/assembly/onpremises-ide-compiling-war-ide/src/main/resources/com/codenvy/ide/IDE.gwt.xml
index bed45eb..c97119a 100644
--- a/assembly/onpremises-ide-compiling-war-ide/src/main/resources/com/codenvy/ide/IDE.gwt.xml
+++ b/assembly/onpremises-ide-compiling-war-ide/src/main/resources/com/codenvy/ide/IDE.gwt.xml
@@ -47,7 +47,6 @@
     <inherits name='org.eclipse.che.ide.ext.web.Web'/>
     <inherits name='org.eclipse.che.plugin.debugger.Debugger'/>
     <inherits name='org.eclipse.che.plugin.gdb.Gdb'/>
-    <inherits name='org.eclipse.che.plugin.nodejsdbg.NodeJsDebugger'/>
     <inherits name='org.eclipse.che.plugin.jdb.JavaDebugger'/>
     <inherits name='org.eclipse.che.plugin.zdb.ZendDebugger'/>
     <inherits name='org.eclipse.che.ide.extension.machine.Machine'/>
```

#### Migration
  5.3 => 5.4 :
  1. Replace in assembly-ide-war/pom.xml
  ```
          <dependency>
              <groupId>com.codenvy.onpremises</groupId>
              <artifactId>compiling-ide-war</artifactId>
              <classifier>classes</classifier>
              <scope>provided</scope>
          </dependency>
  ```
  with
  ```
          <dependency>
              <groupId>com.codenvy.onpremises</groupId>
              <artifactId>assembly-ide-war</artifactId>
              <classifier>classes</classifier>
              <scope>provided</scope>
          </dependency>
  ```

# Build Your Assembly

```shell  
cd assembly
mvn clean install
```

# Run Codenvy With Your Assembly
You will use the Codenvy CLI as you normally would with a single additional. Add a single volume mount to `:/repo` that contains the path to where the Codenvy git repo resides. When you start Codenvy with this extra volume mount, the CLI will look inside the repo for a built assembly and use its binaries instead of those included within the Docker image.

```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
           -v <local-path>:/data \
	   -v $(pwd):/repo codenvy/cli:5.0.0 start
```

# Add Custom Eclipse Che Extensions  
You can create bundles that include your own Eclipse Che extensions, stacks and templates. You will need to have build those extensions and compiled them into JAR and ZIP files. Eclipse Che has docs for [writing extensions and customizing stacks](https://www.eclipse.org/che/docs/plugins/introduction/index.html).

Maven's default enforcement rules require that every extension that you add be listed as a dependency in Codenvy's parent `pom.xml`. You can skip enforcement by using `-Denforcer.skip=true` argument when performing a `mvn clean install`.

Beyond this mandatory requirement, you may have to add your dependencies to additional locations depending upon the type of extension that you are adding (server-side, workspace extension, IDE extensions). 

First, add the dependency in the `<dependencyManagement>` section of Codenvy's parent `pom.xml` located in the root of the repostiory:

```xml  
<dependency>
  <groupId>{groupid-of-extension}</groupId>
  <artifactId>{artifactid-of-extension}</artifactId>
  <version>${project.version}</version>
</dependency>
```
After adding a dependency, you need to sort maven with `mvn sortpom:sort`. You do not have to provide the `<version>` tag. Maven will pull the version of your extension that matches the version of Codenvy.

Second, if your extension is an IDE extension, add your extension as a dependency to the IDE:

```xml  
<dependency>
  <groupId>{groupid-of-extension}</groupId>
  <artifactId>{artifactid-of-extension}</artifactId>
  <version>${project.version}</version>
</dependency>
```

```xml  
<inherits name='{package-name-of-your-ide-extension}'/>
```
Third, if your extension is a server-side workspace extension, add your extension as a dependency to the workspace master:

```xml  
<dependency>
  <groupId>{groupid-of-extension}</groupId>
  <artifactId>{artifactid-of-extension}</artifactId>
  <version>${project.version}</version>
</dependency>
```
If you deployed your server-side extension as a REST service, it will then be available at `/api/{your-custom-path}`

Fourth, if your extension is a server-side workspace agent extension, which is designed to run inside workspaces, then add your extension as a dependency to the workspace agent:

```xml  
<dependency>
	<groupId>{groupid-of-extension}</groupId>
	<artifactId>{artifactid-of-extension}</artifactId>
  <version>${project.version}</version>
</dependency>
```
