# Problem: Storage account name already exists globally
# Solution: Storage account names must be globally unique
az storage account check-name --name $STORAGE_ACCOUNT_NAME

# Problem: Insufficient permissions
# Solution: Verify your Azure CLI permissions
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Problem: Region not available
# Solution: Check available locations
az account list-locations --output table

## 🔧 Configuration Issues:

# Problem: Container creation fails
# Solution: Verify storage account exists and permissions
az storage account show --name $SA_NAME --resource-group $RG_NAME

# Problem: Script execution fails
# Solution: Check script permissions and syntax
chmod +x 1-create-terraform-storage.sh
bash -n 1-create-terraform-storage.sh  # Syntax check

# Problem: Backend configuration not working
# Solution: Verify storage account key access
az storage account keys list --resource-group $RG_NAME --account-name $SA_NAME

## 🧹 Cleanup Commands:

# Remove resource lock before deletion
az lock delete --name "TerraformStorageLock" --resource-group $RG_NAME

# Delete storage account (careful!)
az storage account delete --name $SA_NAME --resource-group $RG_NAME --yes

# Delete resource group (removes everything)
az group delete --name $RG_NAME --yes --no-wait