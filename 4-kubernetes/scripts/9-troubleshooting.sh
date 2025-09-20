# Common Manifest Issues:

# Problem: YAML indentation errors
# Solution: Use proper YAML validator
cd ..
kubectl apply --dry-run=client -f deployment.yml

# Problem: Image pull errors
# Solution: Verify ACR integration and image existence
az acr repository list --name azurecrdevopsthehardway
az role assignment list \
  --assignee $(az aks show -g rg-devopsthehardway -n aks-devopsthehardway --query identityProfile.kubeletidentity.clientId -o tsv) \
  --scope $(az acr show --name azurecrdevopsthehardway --query id -o tsv) \
  --query "[].roleDefinitionName"

# Problem: Resource allocation issues
# Solution: Adjust resource requests/limits
kubectl describe nodes  # Check available resources

# ---
# Configuration Issues:

# Problem: Service not accessible
# Solution: Check service type and port configuration
kubectl get services -n nebulanomi-namespace
kubectl describe service nebulanomi-service -n nebulanomi-namespace

# Problem: Health check failures
# Solution: Verify application responds on correct path/port
curl http://localhost:5000/

# Problem: Namespace issues
# Solution: Ensure namespace is created before resources
kubectl get namespaces
kubectl create namespace nebulanomi-namespace --dry-run=client -o yaml