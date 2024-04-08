#!/bin/bash

# Ensure script exits on first error
set -e

SCRIPT_DIR=$(dirname "$0")
cd "${SCRIPT_DIR}/../../application"

name=$(cat Chart.yaml | yq '.name')
version=$(cat Chart.yaml | yq '.version')

# Prompt user to specify if the version is internal
echo "Is the version internal? (yes/no)"
read answer
internal=false
if [ "${answer}" == "yes" ]; then
    internal=true
fi

# Backup the original Chart.yaml
cp Chart.yaml Chart.yaml.backup

# The version in Chart.yaml remains unchanged
new_version=${version}

if $internal; then
    # Fetch all versions from ECR starting with the specified version prefix and ending with -sb.x
    # Note: Adjust the following command to match your AWS CLI version and query capabilities
    versions=$(aws --profile shared ecr-public describe-images --region us-east-1 --repository-name ${name} --query 'sort_by(imageDetails,& imagePushedAt)[*].imageTags' --output text | grep "^${version}-sb" | sort -V)
    if [ -z "${versions}" ]; then
        # If no versions found, start with -sb.1
        ecr_version="${version}-sb.1"
    else
        # If versions found, pick the last one and increment
        last_version=$(echo "${versions}" | tail -n 1)
        num=$(echo "$last_version" | grep -o -E '[0-9]+$')
        new_num=$((num + 1))
        ecr_version="${version}-sb.${new_num}"
    fi
    # For internal use, we will use ecr_version to tag the ECR image
    yq eval -i ".version = \"${ecr_version}\"" Chart.yaml
else
    # For non-internal use, we keep the ECR tag same as the Chart version
    ecr_version=$version
fi

# Proceed with packaging using the original version in Chart.yaml
output=$(helm package .)
chart_tgz_path=$(echo "$output" | awk '{print $NF}')

# Restore the original Chart.yaml from the backup
mv Chart.yaml.backup Chart.yaml

# Temporarily disable exit on error for AWS CLI operations
set +e

create_output=$(aws --profile shared ecr-public create-repository --region us-east-1 --repository-name ${name} 2>&1)
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

# Temporarily disable exit on error for AWS CLI operations
set +e

registry_uri=$(aws --profile shared ecr-public describe-registries --region us-east-1 --query "registries[0].registryUri" --output text)
# Check if the image version (for internal use, the ecr_version) already exists in the repository
image_exists=$(aws --profile shared ecr-public describe-images --region us-east-1 --repository-name ${name} --image-ids imageTag=${ecr_version} 2>&1)
image_exists_status=$?

# Re-enable exit on error
set -e

if [[ $image_exists_status -eq 0 ]]; then
    echo "Error: The version ${ecr_version} already exists in the repository."
    rm ${chart_tgz_path}
    exit 1
fi

# Login to ECR and push the image
aws --profile shared ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin public.ecr.aws
echo "chart tgz path: ${chart_tgz_path}"
echo "registry: oci://${registry_uri}"
echo "version: ${ecr_version}"
helm push ${chart_tgz_path} oci://${registry_uri}

rm ${chart_tgz_path}

echo "Completed successfully"