# Comprehensive validation script
echo "👥 Validating Azure AD group setup..."

GROUP_NAME="devopsthehardway-aks-group"
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)

# Check if group exists
if az ad group show --group "$GROUP_NAME" &>/dev/null; then
    echo "✅ Azure AD group exists"
    
    # Get group details
    GROUP_ID=$(az ad group show --group "$GROUP_NAME" --query id -o tsv)
    echo "📊 Group ID: $GROUP_ID"
    
    # Check if current user is a member
    if az ad group member check --group "$GROUP_NAME" --member-id $CURRENT_USER_ID --query value -o tsv | grep -q "true"; then
        echo "✅ Current user is group member"
    else
        echo "❌ Current user is not a group member"
    fi
    
    # Count group members
    MEMBER_COUNT=$(az ad group member list --group "$GROUP_NAME" --query "length(@)")
    echo "👥 Group members: $MEMBER_COUNT"
    
    echo "✅ Azure AD group validation complete!"
else
    echo "❌ Azure AD group not found"
    exit 1
fi