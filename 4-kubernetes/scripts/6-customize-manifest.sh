# List your container registries
az acr list --output table

# Get specific ACR login server
az acr show --name azurecrdevopsthehardway --query "loginServer" --output tsv

# Add ACR URI to your deployment manifest