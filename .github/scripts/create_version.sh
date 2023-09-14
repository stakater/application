#!/bin/bash

# Ensure script exits on first error
set -e

cd application
name=$(cat Chart.yaml | yq '.name')
output=$(helm package .)
app_name=$(echo "$output" | awk '{print $NF}')


create_output=$(aws --profile shared ecr-public create-repository --repository-name ${name} --region us-east-1 2>&1)

if [[ $create_output == *"RepositoryAlreadyExistsException"* ]]; then
    # If the repository already exists, describe the registry and get the registryUri
    registry_uri=$(aws --profile shared ecr-public describe-registries --region us-east-1 --query "registries[0].registryUri" --output text)
else
    # If the repository was created successfully, extract the registryUri from the creation output
    registry_uri=$(echo $create_output | jq -r '.repository.registryUri')
fi

aws --profile shared ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin ${registry_uri}
helm push ${app_name} oci://${registry_uri}