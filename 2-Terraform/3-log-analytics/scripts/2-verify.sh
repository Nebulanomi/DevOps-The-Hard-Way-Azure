#/bin/bash

rg_name="rg-devopsthehardway"
workspace_name="law-devopsthehardway"

# List Log Analytics workspaces
echo "Listing Log Analytics Workspaces in the specified resource group..."
az monitor log-analytics workspace list --resource-group $rg_name --output table
echo ""

# Check workspace details
echo "Checking details of the Log Analytics Workspace..."
az monitor log-analytics workspace show --workspace-name $workspace_name --resource-group $rg_name
echo ""

# Verify Container Insights solution
echo "Verifying Container Insights solution in the Log Analytics Workspace..."
az monitor log-analytics solution list --resource-group $rg_name
echo ""