# Common Connection Issues:

rg_name="rg-devopsthehardway"
cluster_name="aks-devopsthehardway"

# Problem: "Unable to connect to the server"
# Solution: Check Azure CLI authentication and network connectivity

az account show
az aks show --resource-group $rg_name --name $cluster_name --query "fqdn"

# Problem: "Forbidden" or "Unauthorized" errors
# Solution: Verify RBAC permissions
az aks show --resource-group $rg_name --name $cluster_name --query "aadProfile"
az role assignment list --assignee $(az account show --query user.name -o tsv) -o table

# Problem: "No current context" error
# Solution: Reconfigure kubectl context
kubectl config get-contexts
az aks get-credentials --resource-group $rg_name --name $cluster_name --overwrite-existing

# ---
# Configuration Issues:

# Problem: Wrong cluster context
# Solution: Switch to correct context
kubectl config get-contexts
kubectl config use-context <context-name>

# Problem: Kubeconfig corruption
# Solution: Regenerate kubeconfig
mv ~/.kube/config ~/.kube/config.backup
az aks get-credentials --resource-group $rg_name --name $cluster_name

# Problem: kubectl not found
# Solution: Install or update kubectl
az aks install-cli  # Azure CLI method
# or use package manager (brew, apt, etc.)

# ---
# Network Troubleshooting:

# Test cluster API server connectivity
CLUSTER_FQDN=$(az aks show --resource-group $rg_name --name $cluster_name --query "fqdn" -o tsv)
nslookup $CLUSTER_FQDN
curl -k https://$CLUSTER_FQDN/version

# Check firewall/proxy settings
kubectl get nodes -v=6  # Verbose output for debugging