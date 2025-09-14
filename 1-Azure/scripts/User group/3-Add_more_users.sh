# Example: Add another user to the admin group
USER_EMAIL="colleague@yourdomain.com"

# Get the object ID of the user
echo "Getting object ID for user: $USER_EMAIL:"
USER_OBJECT_ID=$(az ad user show --id $USER_EMAIL --query id -o tsv)
echo ""

# Add user to the group
echo "Adding user $USER_EMAIL to group devopsthehardway-aks-group:"
az ad group member add --group "devopsthehardway-aks-group" --member-id $USER_OBJECT_ID
echo ""

# Verify addition
echo "Verifying members of group devopsthehardway-aks-group after addition:"
az ad group member list --group "devopsthehardway-aks-group" --query "[].{DisplayName:displayName,UserPrincipalName:userPrincipalName}" --output table
echo ""