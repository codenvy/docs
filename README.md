# codenvy-docs

This repository houses documentation for Codenvy ([repo](https://github.com/codenvy/codenvy) / [site](https://codenvy.com/)). Content is held in markdown files in the `/src/main/_docs` directory. Images should be placed in `/src/main/_docs/assets/imgs`.

Docs are built using Jekyll and the output is static HTML that is hosted at [codenvy.com/docs](https://codenvy.com/docs) and in the product at `{codenvy-domain}/docs`.

# Linking to Docs and Images
Because the docs are generated into static HTML linking to docs and images is a bit unusual:
- Link to a Codenvy docs page: `[Codenvy Factories]({{base}}/docs/integration-guide/workspace-automation/index.html)`
  - `{{base}}/docs` is always required
  - `/integration-guide` is the directory where the .md file is in the repo
  - `/workspace-automation` is the name of the .md file without the .md extension
  - `/index.html` is always required at the end
- Link to a section in a docs page: `[Codenvy Factories]({{base}}/docs/integration-guide/workspace-automation/index.html#try-a-factory)`
  - `#try-a-factory` is the section heading name with spaces replaced by dashes
- Link to an image: `![mypic.png]({{base}}/docs/assets/imgs/mypic.png)`

# Building Docs
Docs are built using a Docker image with Jekyll inside it. You will need Docker running on your machine to build the Codenvy docs.


You can use codenvy.io factory to easily compile and view documentation. Just click [here](https://codenvy.io/f?name=che-codenvy-docs&user=jdrummond).

You can also use the following locally. Navigate to the repo on your filesystem and type:

`./docs.sh --run`

The Jekyll server will scan for changes to the .md files every 2 seconds and auto-update the generated HTML.

# Getting Help
If you have questions or problems, please create an issue in this repo.
