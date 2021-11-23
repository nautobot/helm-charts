#!/bin/bash

# This script is intended to be run by renovate on a detected version update

echo "Installing Python Dependencies"
pip install yq

NEW_VER=$(yq -r .nautobot.image.tag charts/nautobot/values.yaml)
echo "Updating Version to ${NEW_VER}"
sed -i "s@appVersion: \".*\"@appVersion: \"${NEW_VER}\"@" charts/nautobot/Chart.yaml
sed -i "s@nautobot/nautobot:.*@nautobot/nautobot:${NEW_VER}@" charts/nautobot/Chart.yaml

echo "Installing helm-docs"
GO111MODULE=on
go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

echo "Updating helm-docs"
$HOME/go/bin/helm-docs

echo "Updating CHANGELOG"
PR_TITLE=$1
sed -i "s@artifacthub.io/changes: |@artifacthub.io/changes: |\n    - kind: changed\n      description: ${PR_TITLE}@" charts/nautobot/Chart.yaml
sed -i "s@<!--- Renovate --->@<!--- Renovate --->\n- ${PR_TITLE}@" CHANGELOG.md
