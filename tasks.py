"""Tasks for use with Invoke.
(c) 2022 Network To Code
"""

from invoke import task


@task
def docs(context, strict=False):
    """Build and serve docs locally for development."""
    command = "poetry run mkdocs serve --verbose"
    if strict:
        command = f"{command} --strict"
    print("Serving Documentation...")
    context.run(command)
