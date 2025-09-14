#/bin/bash

RESOURCE_GROUP_NAME="rg-devopsthehardway"
STORAGE_ACCOUNT_NAME="sadevopshardwaysa"
VNET="rg-devopsthehardway-vnet"
SUBNET="appgw"

# Problem: Backend initialization fails
# Solution: Verify storage account and container exist
echo "Checking storage account and container..."
az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME -o table
echo ""

# Problem: Address space conflicts
# Solution: Check for overlapping CIDR blocks
echo "Checking VNET address space for overlaps..."
terraform plan | grep "address_prefixes"
echo ""

# Problem: Permission errors
# Solution: Verify Azure CLI authentication and permissions
echo "Checking Azure CLI authentication and permissions..."
az account show
az role assignment list --assignee $(az account show --query user.name -o tsv) -o table
echo ""

# Problem: Subnet creation fails
# Solution: Verify address space doesn't overlap
echo "Checking VNET address space..."
az network vnet show --name $VNET --resource-group $RESOURCE_GROUP_NAME --query "addressSpace"
echo ""

# Problem: NSG association fails
# Solution: Check if subnet is already associated with another NSG
echo "Checking NSG association for subnet $SUBNET..."
az network vnet subnet show --name $SUBNET --vnet-name $VNET --resource-group $RESOURCE_GROUP_NAME --query "networkSecurityGroup" -o table
echo ""

# Problem: ALB deployment fails
# Solution: Verify subnet has sufficient address space
echo "Checking subnet details for ALB deployment..."
az network vnet subnet list --vnet-name $VNET --resource-group $RESOURCE_GROUP_NAME --query "[].{Name:name,AddressPrefix:addressPrefix,AvailableIPs:availableIpAddressCount}" -o table
echo ""