#!/bin/sh
set -e

export TF_IN_AUTOMATION=1

terraform init -input=false
terraform apply -input=false -auto-approve

cd kubernetes-config
terraform init -input=false
terraform apply -input=false -auto-approve

set +e
url=$(terraform output -raw lb_ip)
timeout=180
interval=10
start_time=$(date +%s)

echo "Testing the app..."
while true; do
    http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))

    if [ "$http_status" = "200" ]; then
        echo "SUCCESS! Received a 200 response."
        exit 0
    elif [ "$elapsed_time" -ge "$timeout" ]; then
        echo "Test failed. The app was not ready within $timeout seconds."
        exit 1
    fi

    sleep "$interval"
done