#!/bin/bash
export $(grep -v '^#' .env | xargs)
export TF_VAR_github_pat=$GITHUB_PAT
export TF_VAR_github_uri=$GITHUB_URI
export TF_VAR_github_path=$GITHUB_PATH
cd terraform

if [ -d ".terraform" ]; then
  echo "Terraform already initialized."
else
  terraform init
fi
terraform fmt
terraform plan
# If the terraform plan succeeds without error, then run terraform apply -auto-approve, otherwise echo that there is an error
if terraform apply -auto-approve; then
  echo "Terraform apply succeeded."
else
  echo "Terraform apply failed."
fi
cd ../