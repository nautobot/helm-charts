"""Tasks for use with Invoke.
(c) 2022 Network To Code
"""

import functools
import json
import urllib.request
from pathlib import Path

import yaml
from invoke import task

SCHEMA_SOURCE = Path("charts/nautobot/schema/values.schema.json")
SCHEMA_TARGET = Path("charts/nautobot/values.schema.json")
K8S_SCHEMA_URL = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/"
SCHEMA_GENERATED_COMMENT = "Generated from schema/values.schema.json by 'invoke build-schema'. Do not edit."


@task
def update_docs(context, local=False):
    """Run helm-docs to update README.md and reference.md.

    Mimics the Update Docs CI job without committing. By default runs
    via Docker from development/; set local=True to run helm-docs
    locally (must be installed).
    """
    if not local:
        print("Running helm-docs via Docker...")
        context.run(
            "docker compose -f development/docker-compose.yml run --build --rm update-docs",
            pty=True,
        )
    else:
        print("Running helm-docs locally...")
        context.run("helm-docs --chart-search-root=charts --template-files=README.md.gotmpl")
        context.run(
            "helm-docs --chart-to-generate=charts/nautobot "
            "--template-files=./docs/configuration/reference.md.gotmpl "
            "--output-file=../../docs/configuration/reference.md"
        )
    print("Docs updated.")


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


@functools.lru_cache(maxsize=None)
def _fetch_k8s_schema(path):
    """Download and parse a JSON file from the yannh/kubernetes-json-schema repository."""
    url = K8S_SCHEMA_URL + path
    print(f"Downloading {url}")
    with urllib.request.urlopen(url, timeout=60) as response:
        return json.load(response)


def _clean_k8s_schema(node, folder):
    """Return a copy of `node` without descriptions and with `_definitions.json` refs resolved."""
    if isinstance(node, list):
        return [_clean_k8s_schema(item, folder) for item in node]
    if not isinstance(node, dict):
        return node
    ref = node.get("$ref")
    if isinstance(ref, str):
        name = ref.split("#/definitions/")[1]
        return _clean_k8s_schema(_fetch_k8s_schema(f"{folder}/_definitions.json")["definitions"][name], folder)
    return {
        key: _clean_k8s_schema(value, folder)
        for key, value in node.items()
        if not (key in ("$schema", "description") and isinstance(value, str))
    }


def _build_k8s_def(path):
    """Return the Kubernetes schema at `path` as a self-contained def."""
    folder = path.split("/")[0]
    note = "" if "-standalone" in folder else ", _definitions.json refs resolved"
    comment = f"Source: yannh/kubernetes-json-schema {path}{note} (descriptions removed)"
    return {"$comment": comment, **_clean_k8s_schema(_fetch_k8s_schema(path), folder)}


def _localize_k8s_refs(node, paths):
    """Point every Kubernetes `$ref` in `node` to a local def and record its path in `paths`."""
    if isinstance(node, list):
        for item in node:
            _localize_k8s_refs(item, paths)
    elif isinstance(node, dict):
        ref = node.get("$ref")
        if isinstance(ref, str) and not ref.startswith("#"):
            if not ref.startswith(K8S_SCHEMA_URL):
                raise SystemExit(f"Unsupported $ref, only {K8S_SCHEMA_URL} can be inlined: {ref}")
            path = ref[len(K8S_SCHEMA_URL) :]
            name = f"k8s-{Path(path).stem}"
            if paths.setdefault(name, path) != path:
                raise SystemExit(f"{name} is referenced from two folders: {paths[name]} and {path}")
            node["$ref"] = f"#/$defs/{name}"
        for value in node.values():
            _localize_k8s_refs(value, paths)


@task
def build_schema(context):
    """Build charts/nautobot/values.schema.json from charts/nautobot/schema/values.schema.json.

    Helm downloads every remote `$ref` each time it validates values. The source schema
    references the Kubernetes JSON schemas by URL, and this task inlines them into `$defs`
    so the built schema works without network access.
    """
    schema = json.loads(SCHEMA_SOURCE.read_text(encoding="utf-8"))
    paths = {}
    _localize_k8s_refs(schema, paths)
    for name, path in sorted(paths.items()):
        schema["$defs"][name] = _build_k8s_def(path)
    built = {"$schema": schema.pop("$schema"), "$comment": SCHEMA_GENERATED_COMMENT, **schema}
    SCHEMA_TARGET.write_text(json.dumps(built, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {SCHEMA_TARGET}")
