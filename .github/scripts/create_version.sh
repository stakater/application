#!/bin/bash

# Ensure script exits on first error
set -e

SCRIPT_DIR=$(dirname "$0")
cd "${SCRIPT_DIR}/../../application"

name=$(cat Chart.yaml | yq '.name')
version=$(cat Chart.yaml | yq '.version')

# Define the internal variable (set it to true if it's sendblocks changes and not official changes by the author)
internal=false

# Backup the original Chart.yaml
cp Chart.yaml Chart.yaml.backup

# Check if internal is true and append "_sb" to the version if it is
if $internal; then
    new_version="${version}-sb"
    yq eval -i ".version = \"$new_version\"" Chart.yaml
else
    new_version=$version
fi

output=$(helm package .)
app_name=$(echo "$output" | awk '{print $NF}')

# Restore the original Chart.yaml from the backup
mv Chart.yaml.backup Chart.yaml

# Temporarily disable exit on error
set +e

create_output=$(aws --profile shared ecr-public create-repository --repository-name ${name} --region us-east-1 2>&1)
create_status=$?

# Re-enable exit on error
set -e

if [[ $create_status -ne 0 && $create_output == *"RepositoryAlreadyExistsException"* ]]; then
    echo "Repository '${name}' already exists in AWS ECR. Proceeding with existing repository."
elif [[ $create_status -eq 0 ]]; then
    echo "Repository '${name}' successfully created in AWS ECR."
else
    echo "Failed to create repository '${name}' due to an unexpected error: $create_output"
    exit 1
fi

registry_uri=$(aws --profile shared ecr-public describe-registries --region us-east-1 --query "registries[0].registryUri" --output text)

# Temporarily disable exit on error
set +e

image_exists=$(aws --profile shared ecr-public describe-images --repository-name ${name} --image-ids imageTag=${new_version} --region us-east-1 2>&1)
image_exists_status=$?

# Re-enable exit on error
set -e

if [[ $image_exists_status -eq 0 ]]; then
    echo "Error: The version ${new_version} already exists in the repository."
    exit 1
fi

aws --profile shared ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin public.ecr.aws
helm push ${app_name} oci://${registry_uri}
