#/bin/bash

echo "Checking if the ACR name 'acrdevopsthehardway' is available..."
az acr check-name --name "acrdevopsthehardway"
echo ""