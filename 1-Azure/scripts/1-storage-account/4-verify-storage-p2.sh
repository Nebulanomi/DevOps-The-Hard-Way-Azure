# Comprehensive validation script
echo "🗄️ Validating Terraform storage setup..."

# Check if resource group exists
RG_NAME="rg-devopsthehardway"
SA_NAME="sadevopshardwaysa"

if az group show --name $RG_NAME &>/dev/null; then
    echo "✅ Resource group exists"
    
    # Check storage account
    if az storage account show --name $SA_NAME --resource-group $RG_NAME &>/dev/null; then
        echo "✅ Storage account exists"
        
        # Check encryption settings
        ENCRYPTION=$(az storage account show --name $SA_NAME --resource-group $RG_NAME --query "encryption.services.blob.enabled" -o tsv)
        echo "🔒 Blob encryption enabled: $ENCRYPTION"
        
        # Check HTTPS enforcement
        HTTPS_ONLY=$(az storage account show --name $SA_NAME --resource-group $RG_NAME --query "enableHttpsTrafficOnly" -o tsv)
        echo "🔐 HTTPS-only enabled: $HTTPS_ONLY"
        
        # Check container
        CONTAINER_COUNT=$(az storage container list --account-name $SA_NAME --auth-mode login --output tsv | wc -l)
        echo "📦 Containers created: $CONTAINER_COUNT"
        
        echo "✅ Terraform storage validation complete!"
    else
        echo "❌ Storage account not found"
        exit 1
    fi
else
    echo "❌ Resource group not found"
    exit 1
fi