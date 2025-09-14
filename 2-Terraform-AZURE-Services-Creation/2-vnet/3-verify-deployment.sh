# Comprehensive validation script
echo "🔍 Validating VNET deployment..."

rg_name="rg-devopsthehardway"
vnet_name="rg-devopsthehardway-vnet"

# Check if VNET exists
RG_NAME=$(terraform output -raw resource_group_name 2>/dev/null || echo "$rg_name")
VNET_NAME=$(terraform output -raw vnet_name 2>/dev/null || echo "$vnet_name")

if az network vnet show --name $VNET_NAME --resource-group $RG_NAME &>/dev/null; then
    echo "✅ VNET exists"
    
    # Check subnet count
    SUBNET_COUNT=$(az network vnet subnet list --vnet-name $VNET_NAME --resource-group $RG_NAME --query "length(@)" 2>/dev/null)
    echo "📊 Subnets created: $SUBNET_COUNT"
    
    # Check NSG associations
    NSG_COUNT=$(az network nsg list --resource-group $RG_NAME --query "length(@)" 2>/dev/null)
    echo "🛡️ NSGs created: $NSG_COUNT"
    
    # Check ALB
    ALB_COUNT=$(az network alb list --resource-group $RG_NAME --query "length(@)" 2>/dev/null)
    echo "⚖️ Load Balancers: $ALB_COUNT"
    
    echo "✅ VNET validation complete!"
else
    echo "❌ VNET validation failed"
    exit 1
fi