#!/bin/bash

AZURE_AD_GROUP_NAME="devopsthehardway-aks-group"
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)

# Remove user from group
echo "🔍 Removing user from group 'devopsthehardway-aks-group'..."
az ad group member remove --group $AZURE_AD_GROUP_NAME --member-id $CURRENT_USER_ID
echo ""

# Delete the group (careful!)
echo "🔍 Deleting group 'devopsthehardway-aks-group'..."
az ad group delete --group $AZURE_AD_GROUP_NAME
echo ""