# Enable security features for the group (if available in your tenant)
# Note: Some features require Azure AD Premium

# Check group security settings
az ad group show \
    --group "devopsthehardway-aks-group" \
    --query "{securityEnabled:securityEnabled,mailEnabled:mailEnabled}"

# The group is automatically created as a security group
# Additional security configurations are typically done through Azure Portal