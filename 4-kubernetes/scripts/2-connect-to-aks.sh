# Replace with your actual resource group and cluster names
az aks get-credentials --resource-group rg-devopsthehardway --name aks-devopsthehardway --overwrite-existing

# Check current kubectl context
kubectl config current-context

# Display current context configuration
kubectl config view --minify

# Convert kubeconfig to use Azure Entra ID authentication
kubelogin convert-kubeconfig -l azurecli