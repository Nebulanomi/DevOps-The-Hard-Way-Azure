# !/bin/bash

# View the ACR
echo "Show the ACR.."
az acr show --name azurecrdevopsthehardway --query name
echo ""

# Log in to ACR
echo "Logging in to ACR..."
az acr login --name azurecrdevopsthehardway
echo ""

# Format: docker tag SOURCE_IMAGE TARGET_REGISTRY/TARGET_IMAGE:TAG
echo "Tagging the image..."
docker tag nebulanomi:latest azurecrdevopsthehardway.azurecr.io/nebulanomi:v1
echo ""

# Push the image to ACR
echo "Pushing the image to ACR..."
docker push azurecrdevopsthehardway.azurecr.io/nebulanomi:v1
echo ""

# View the repo
echo "View the repo in ACR..."
az acr repository list --name azurecrdevopsthehardway --output table
echo ""

# View the image in ACR
echo "View the image in ACR..."
az acr repository show-tags --name azurecrdevopsthehardway --repository nebulanomi
echo ""