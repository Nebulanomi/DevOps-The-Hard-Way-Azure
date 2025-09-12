RESOURCE_GROUP_NAME="rg-devopsthehardway"
STORAGE_ACCOUNT_NAME="sadevopshardwaysa"

# Check resource group
echo "Resource group \"$RESOURCE_GROUP_NAME\" details:"
echo ""
az group show \
    --name $RESOURCE_GROUP_NAME \
    --query "{Name:name, Location:location}" \
    --output table
echo ""

# Verify storage account
echo "Storage account \"$STORAGE_ACCOUNT_NAME\" details:"
echo ""
az storage account show \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --query "{Name:name, Kind:kind, SKU:sku.name, Location:location, Status:provisioningState}" \
    --output table
echo ""

# List containers
echo "Containers in storage account \"$STORAGE_ACCOUNT_NAME\":"
echo ""
az storage container list \
    --account-name $STORAGE_ACCOUNT_NAME \
    --auth-mode login \
    --query "[].{Name:name, LastModified:properties.lastModified}" \
    --output table
echo ""