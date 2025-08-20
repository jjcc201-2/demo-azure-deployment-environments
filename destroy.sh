#!/bin/bash
export $(grep -v '^#' .env | xargs)
export TF_VAR_github_pat=$GITHUB_PAT
export TF_VAR_github_uri=$GITHUB_URI
cd terraform

if [ -d ".terraform" ]; then
  echo "Terraform already initialized."
else
  terraform init
fi
terraform destroy -auto-approve

cd ../