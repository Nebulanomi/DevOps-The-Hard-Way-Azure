#bin/bash

rg_name="rg-devopsthehardway"
vnet_name="rg-devopsthehardway-vnet"

# List VNET details
echo "Listing VNET details..."
az network vnet list --resource-group $rg_name --output table
echo ""

# Check subnets
echo "Checking subnets..."
az network vnet subnet list --vnet-name $vnet_name --resource-group $rg_name --output table
echo ""

# Verify NSG associations
echo "Verifying NSG associations..."
az network nsg list --resource-group $rg_name --output table
echo ""