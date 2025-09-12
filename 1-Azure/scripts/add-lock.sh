RESOURCE_GROUP_NAME="rg-devopsthehardway"
STORAGE_ACCOUNT_NAME="sadevopshardwaysa"
RETAINED_DAYS=7

# Add resource lock to prevent accidental deletion
az lock create \
  --name "TerraformStorageLock" \
  --lock-type CanNotDelete \
  --resource-group $RESOURCE_GROUP_NAME \
  --resource-name $STORAGE_ACCOUNT_NAME \
  --resource-type Microsoft.Storage/storageAccounts

# Enable soft delete for blobs
az storage blob service-properties delete-policy update \
  --account-name $STORAGE_ACCOUNT_NAME \
  --enable true \
  --days-retained $RETAINED_DAYS