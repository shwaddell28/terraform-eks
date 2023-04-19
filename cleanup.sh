#!/bin/sh
set -e

export TF_IN_AUTOMATION=1

cd kubernetes-config
terraform destroy -auto-approve

cd -
terraform destroy -auto-approve
