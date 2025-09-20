#/bin/bash

name="acrdevopsthehardwayazurecr"

# Check ACR exists and is accessible
echo "Verifying ACR instance '$name' exists..."
az acr list --query "[?name=='$name']" --output table
echo ""

# Verify login capability
echo "Verifying login to ACR instance '$name'..."
az acr login --name $name
echo ""