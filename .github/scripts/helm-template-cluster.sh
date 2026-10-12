#!/usr/bin/env bash
# Render the chart against the API surface of the current kubectl context.
#
# helm template only knows the built-in Kubernetes APIs, so templates gated on
# .Capabilities.APIVersions.Has would skip every CRD-backed resource. Feeding
# `kubectl api-versions` and `kubectl api-resources` back in as --api-versions
# makes the render match what the cluster actually serves, including CRDs
# installed before this script runs.
#
# Usage: helm-template-cluster.sh <output-file> <values-file>...
# Requires CHART_PATH, RELEASE_NAME and TEST_NAMESPACE in the environment.
set -euo pipefail

output="$1"
shift

args=()
# group/version entries (e.g. batch/v1)
for v in $(kubectl api-versions); do
  args+=("--api-versions" "$v")
done
# group/version/Kind entries (e.g. batch/v1/CronJob)
while IFS= read -r gvk; do
  args+=("--api-versions" "$gvk")
done < <(
  kubectl api-resources --no-headers \
    | awk '{ print $(NF-2) "/" $NF }' \
    | sort -u
)
for f in "$@"; do
  args+=("-f" "$CHART_PATH/$f")
done

set -x
helm template "$RELEASE_NAME" "$CHART_PATH" \
  "${args[@]}" \
  --namespace "$TEST_NAMESPACE" \
  --debug > "$output"
set +x

cat "$output"
