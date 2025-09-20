# Comprehensive validation script
echo "📊 Validating Log Analytics deployment..."

rg_name="rg-devopsthehardway"
workspace_name="law-devopsthehardway"

# Get workspace details from Terraform
WORKSPACE_NAME=$(terraform output -raw workspace_name 2>/dev/null || echo $workspace_name)
RG_NAME=$(terraform output -raw resource_group_name 2>/dev/null || echo $rg_name)

# Check if workspace exists and is running
WORKSPACE_STATE=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "provisioningState" -o tsv 2>/dev/null)

if [ "$WORKSPACE_STATE" = "Succeeded" ]; then
    echo "✅ Log Analytics workspace is running"
    
    # Check retention settings
    RETENTION=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "retentionInDays" -o tsv)
    echo "📅 Data retention: $RETENTION days"
    
    # Check SKU
    SKU=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "sku.name" -o tsv)
    echo "💰 Pricing tier: $SKU"
    
    # Check Container Insights solution
    SOLUTION_COUNT=$(az monitor log-analytics solution list --resource-group $RG_NAME --query "length(@)")
    echo "🔧 Solutions installed: $SOLUTION_COUNT"
    
    echo "✅ Log Analytics validation complete!"
else
    echo "❌ Log Analytics validation failed - State: $WORKSPACE_STATE"
    exit 1
fi