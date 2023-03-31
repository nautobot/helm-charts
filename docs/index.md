---
hide:
  - navigation
---

# Documentation Overview

Here you will find some guidance on how to further customize this documentation project.

A separate [Examples](examples.md) page is provided as a quick reference for docs writing with mkdocs and the material theme. It's not a complete showcase, so make sure to [read the theme docs](https://squidfunk.github.io/mkdocs-material/reference/)!

## Automatic package documentation from docstrings

If you are adding docs to a Python project, you may want to generate API documentation from the package/module docstrings (you do have docstrings, right, RIGHT?).

To do that you will need to add the following packages to your project dependencies:

```no-highlight
mkdocstrings
mkdocstrings-python
```

Edit your `mkdocs.yml` file and add the following `mkdocstrings` subtree to the `plugins` section:

```yaml
plugins:
  - "mkdocstrings":
      default_handler: "python"
      handlers:
        python:
          paths: ["."]
          options:
            show_root_heading: true
```

The final step is to create new Markdown files which reference your modules and/or packages which you want documentation to be auto-generated for.

This example, which could be called `api.md`, generates documentation for the `package_name.api` module:

```no-highlight
::: package_name.api
    options:
        show_submodules: True
```

Should you want to include a whole package, you can simply add it by name:

```no-highlight
::: package_name
```

Finally, read the "usage" docs for `mkdocstrings` and its Python parser for further customization and examples:

- [mkdocstrings](https://mkdocstrings.github.io/usage/)
- [mkdocstrings-python](https://mkdocstrings.github.io/python/usage/)
