"""Tasks for use with Invoke.
(c) 2022 Network To Code
"""

import yaml
from pathlib import Path

from invoke import task


@task
def docs(context, strict=False):
    """Build and serve docs locally for development."""
    command = "poetry run mkdocs serve --verbose"
    if strict:
        command = f"{command} --strict"
    print("Serving Documentation...")
    context.run(command)


@task
def check_release_tag(context, tag):
    """Check that the provided tag matches the value in Chart.yaml."""

    print(f"Checking that provided tag '{tag}' matches Chart.yaml version.")

    if tag.startswith("v"):
        tag = tag[1:]
        print(f"Stripped leading 'v' from tag. New tag is '{tag}'.")

    print("Loading Chart.yaml.")
    chart_yaml_path = Path("charts/nautobot/Chart.yaml")
    with open(chart_yaml_path, "r", encoding="utf-8") as chart_file:
        chart_yaml_data = yaml.safe_load(chart_file)
        version = chart_yaml_data.get("version")
        print(f"Found version '{version}' in Chart.yaml.")

    if tag != version:
        print(f"ERROR: Provided tag '{tag}' does not match Chart.yaml version '{version}'.")
        exit(1)

    print(f"Provided tag '{tag}' matches Chart.yaml version '{version}'.")
