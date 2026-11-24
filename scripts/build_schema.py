#!/usr/bin/env python3
"""Build `charts/nautobot/values.schema.json` from `charts/nautobot/schema/values.schema.json`.

Helm downloads every remote `$ref` each time it validates values. The source schema
references the Kubernetes JSON schemas by URL, and this script inlines them into `$defs`
so the built schema works without network access.
"""

import functools
import json
import urllib.request
from pathlib import Path

CHART_DIR = Path(__file__).resolve().parent.parent / "charts" / "nautobot"
SOURCE = CHART_DIR / "schema" / "values.schema.json"
TARGET = CHART_DIR / "values.schema.json"
K8S_SCHEMA_URL = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/"
GENERATED_COMMENT = "Generated from schema/values.schema.json by scripts/build_schema.py. Do not edit."


@functools.lru_cache(maxsize=None)
def fetch(path):
    """Download and parse a JSON file from the yannh/kubernetes-json-schema repository."""
    url = K8S_SCHEMA_URL + path
    print(f"Downloading {url}")
    with urllib.request.urlopen(url, timeout=60) as response:
        return json.load(response)


def clean(node, folder):
    """Return a copy of `node` without descriptions and with `_definitions.json` refs resolved."""
    if isinstance(node, list):
        return [clean(item, folder) for item in node]
    if not isinstance(node, dict):
        return node
    ref = node.get("$ref")
    if isinstance(ref, str):
        name = ref.split("#/definitions/")[1]
        return clean(fetch(f"{folder}/_definitions.json")["definitions"][name], folder)
    return {
        key: clean(value, folder)
        for key, value in node.items()
        if not (key in ("$schema", "description") and isinstance(value, str))
    }


def build_def(path):
    """Return the Kubernetes schema at `path` as a self-contained def."""
    folder = path.split("/")[0]
    note = "" if "-standalone" in folder else ", _definitions.json refs resolved"
    comment = f"Source: yannh/kubernetes-json-schema {path}{note} (descriptions removed)"
    return {"$comment": comment, **clean(fetch(path), folder)}


def localize_refs(node, paths):
    """Point every Kubernetes `$ref` in `node` to a local def and record its path in `paths`."""
    if isinstance(node, list):
        for item in node:
            localize_refs(item, paths)
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
            localize_refs(value, paths)


def main():
    """Write the built schema."""
    schema = json.loads(SOURCE.read_text(encoding="utf-8"))
    paths = {}
    localize_refs(schema, paths)
    for name, path in sorted(paths.items()):
        schema["$defs"][name] = build_def(path)
    built = {"$schema": schema.pop("$schema"), "$comment": GENERATED_COMMENT, **schema}
    TARGET.write_text(json.dumps(built, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {TARGET}")


if __name__ == "__main__":
    main()
