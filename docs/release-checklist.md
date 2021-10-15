# Release Checklist

This document is intended for Nautobot Helm Chart maintainers and covers the steps to perform when releasing new versions.

## Versioning

### Path Version Bumps (0.0.x)

Minor version bumps are intended for minor bug fixes or documentation changes which will not impact the method of deployment (deployed values).

### Minor Version Bumps (0.x.0)

App version changes (assuming there are no significant upstream changes) and new features should come with a minor version bump, these changes can add to values.yaml but should not change the current method of deployment.

### Major Version Bumps (x.0.0)

Major version bumps are intended for breaking changes, and changes which will impact the current method of deployment.  Major upstream version changes should also come in a major version.

### Update Requirements

## All Releases

### Verify CI Build Status

Ensure that continuous integration testing on the `develop` branch is completing successfully.

### Bump the Version

Update the `version` and `appVersion` in the corresponding `Chart.yaml` file.  Be sure to set the annotation `artifacthub.io/prerelease: "true"` if the chart is a pre-release version.

### Check the dependencies

Check the chart dependencies in `Chart.yaml` to ensure we are using the latest.

### Update the README

If necessary add to the *Upgrading* section to provide instructions on migrating to the new version.

### Update the annotations

Artifact hub provides several [annotations](https://artifacthub.io/docs/topics/annotations/helm/) which can be added to the `Chart.yaml`.  Annotations which may change per release are:

* `artifacthub.io/containsSecurityUpdates`
* `artifacthub.io/prerelease`
* `artifacthub.io/changes`

### Update the Changelog

Update the release notes for the new version and commit these changes to the `develop` branch.

!!! important
    The changelog must adhere to the [Keep a Changelog](https://keepachangelog.com/) style guide.

### Submit a Pull Request

Submit a pull request title **"Release vX.Y.Z"** to merge the `develop` branch into `main`. Copy the documented release notes into the pull request's body.

Once CI has completed on the PR, merge it.

### Create a New Release

Draft a [new release](https://github.com/nautobot/nautobot/releases/new) with the following parameters.

* **Tag:** Current version (e.g. `v1.0.0`)
* **Target:** `main`
* **Title:** Version and date (e.g. `v1.0.0 - 2021-06-01`)

Copy the description from the pull request to the release.

### Publish

Once the release has been created the GitHub Action defined in [release-chart.yaml](../.github/workflows/release-chart.yaml) will run.  This will generate the correct packaging and publish the chart via GitHub pages in the `gh-pages` branch.
