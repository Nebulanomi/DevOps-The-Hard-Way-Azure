#bin/bash

rg_name="rg-devopsthehardway"
aks_name="aks-devopsthehardway"

# Download cluster credentials
echo "Downloading AKS cluster credentials..."
# az aks get-credentials --resource-group $rg_name --name $aks_name <-- For AD access
az aks get-credentials \
  --resource-group rg-devopsthehardway \
  --name aks-devopsthehardway \
  --admin # <-- For admin access
echo ""

# Verify kubectl context
echo "Current kubectl context:"
kubectl config current-context
echo ""