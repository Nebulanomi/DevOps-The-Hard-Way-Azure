# Validate YAML syntax using kubectl
cd ..
kubectl apply --dry-run=client -f deployment.yml

# Test if you can pull the image from ACR
az acr repository show --name azurecrdevopsthehardway --image nebulanomi:latest

# Verify AKS can pull from ACR
az role assignment list \
  --assignee $(az aks show -g rg-devopsthehardway -n aks-devopsthehardway --query identityProfile.kubeletidentity.clientId -o tsv) \
  --scope $(az acr show --name azurecrdevopsthehardway --query id -o tsv) \
  --query "[].roleDefinitionName"