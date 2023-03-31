"""Tasks for use with Invoke.
(c) 2022 Network To Code
"""

from invoke import task


@task
def docs(context):
    """Build and serve docs locally for development."""
    command = "poetry run mkdocs serve -v"
    print("Serving Documentation...")
    context.run(command)
