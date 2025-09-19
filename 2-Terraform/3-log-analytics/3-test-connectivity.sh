#/bin/bash

# Get workspace details from Terraform output
echo "Retrieving Log Analytics Workspace ID from Terraform output..."
WORKSPACE_ID=$(terraform output -raw workspace_id)
echo "Workspace ID: $WORKSPACE_ID"
echo ""

# Test workspace is accessible
echo "Testing connectivity to the Log Analytics Workspace..."
az monitor log-analytics workspace show --ids $WORKSPACE_ID --query "{Name:name,State:provisioningState,Sku:sku.name}" -o table
echo ""