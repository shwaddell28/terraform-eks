#!/bin/sh

export TF_IN_AUTOMATION=1

terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan

cd kubernetes-config
terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan