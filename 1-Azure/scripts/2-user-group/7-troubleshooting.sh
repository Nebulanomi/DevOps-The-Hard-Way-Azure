#!/bin/bash

AZURE_AD_GROUP_NAME="devopsthehardway-aks-group"
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)
USER_EMAIL="user@domain.com"

# Problem: User Administrator role needed
# Solution: Request User Administrator or Global Administrator role
echo "🔍 Checking for User Administrator or Global Administrator roles..."
az rest --method GET \
    --url "https://graph.microsoft.com/v1.0/users/$CURRENT_USER_ID/transitiveMemberOf/microsoft.graph.directoryRole" \
    --query "value[?displayName=='User Administrator' || displayName=='Global Administrator' || displayName=='Groups Administrator'].displayName" -o table
echo ""

# Problem: Cannot add users to group
# Solution: Verify you have appropriate permissions
echo "🔍 Verifying permissions to add users to groups..."
az ad group member add --group "$AZURE_AD_GROUP_NAME" --member-id $CURRENT_USER_ID --debug
echo ""

# Problem: Group already exists
# Solution: Check existing group or use different name
echo "🔍 Checking if group '$AZURE_AD_GROUP_NAME' already exists..."
az ad group list --filter "displayName eq 'devopsthehardway-aks-group'" --output table
echo ""

# Problem: User not found
# Solution: Verify user exists and check email address
echo "🔍 Verifying user existence..."
az ad user show --id $USER_EMAIL
echo ""

# Problem: Group ID not captured
# Solution: Retrieve group ID manually
echo "🔍 Retrieving Group ID for '$AZURE_AD_GROUP_NAME'..."
GROUP_ID=$(az ad group show --group "devopsthehardway-aks-group" --query id -o tsv)
echo "Group ID: $GROUP_ID"
echo ""