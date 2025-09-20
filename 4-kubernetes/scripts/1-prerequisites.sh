# Verify you're logged into Azure
az account show --output table

# Check kubectl version
kubectl version --client --output=yaml

# List AKS clusters in your subscription
az aks list --output table