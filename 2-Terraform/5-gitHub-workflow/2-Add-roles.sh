# Store the app ID in a variable

name="sp-DevOps-The-Hardway-Azure-GitHub-OIDC"
subscriptionId="0048e322-32a4-4cea-9722-71bb5918a734"

echo "Retrieving Azure AD application ID..."
APP_ID=$(az ad app list --display-name $name --query "[].appId" -o tsv)
echo ""

# Get the service principal ID
echo "Retrieving service principal ID..."
SP_ID=$(az ad sp list --filter "appId eq '$APP_ID'" --query "[].id" -o tsv)
echo ""

# Assign Contributor role to the subscription
echo "Assigning Contributor role to the service principal..."
az role assignment create --assignee $SP_ID --role "Contributor" --scope "/subscriptions/$subscriptionId"
echo ""

# Assign Storage Blob Data Contributor role to the storage account
echo "Assigning Contributor role to the service principal..."
az role assignment create --assignee $SP_ID --role "Storage Blob Data Contributor" --scope "/subscriptions/$subscriptionId"
echo ""