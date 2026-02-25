#!/usr/bin/env bash
# Same helm-docs steps as .github/workflows/update-docs.yaml (except no automatic git commit).
set -e

helm-docs --chart-search-root=charts --template-files=README.md.gotmpl

helm-docs --chart-to-generate=charts/nautobot \
  --template-files=./docs/configuration/reference.md.gotmpl \
  --output-file=../../docs/configuration/reference.md
