#!/usr/bin/env bash
set -euo pipefail

version="${1:?Usage: set-version.sh <new_version>}"

sed -i "s/^version: [0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}/version: ${version}/" application/Chart.yaml
