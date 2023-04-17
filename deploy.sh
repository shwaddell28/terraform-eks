#!/bin/sh

export TF_IN_AUTOMATION=1

terraform init -input=false
terraform apply -input=false -auto-approve

cd kubernetes-config
terraform init -input=false
terraform apply -input=false -auto-approve