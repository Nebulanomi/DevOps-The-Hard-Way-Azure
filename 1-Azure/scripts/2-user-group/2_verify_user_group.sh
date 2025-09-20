# Configuration
AZURE_AD_GROUP_NAME="devopsthehardway-aks-group"

# Check if group exists
echo "Verifying Azure AD group \"$AZURE_AD_GROUP_NAME\":"
az ad group show \
    --group $AZURE_AD_GROUP_NAME \
    --output table
echo ""

# List group members
echo "Listing members of Azure AD group \"$AZURE_AD_GROUP_NAME\":"
az ad group member list \
    --group $AZURE_AD_GROUP_NAME \
    --output table
echo ""

# Verify current user is a member
echo "Verifying current user is a member of Azure AD group: \"$AZURE_AD_GROUP_NAME\":"
az ad group member check \
    --group $AZURE_AD_GROUP_NAME \
    --member-id $(az ad signed-in-user show --query id -o tsv)
echo ""