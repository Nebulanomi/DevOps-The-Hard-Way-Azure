#/bin/bash

rg_name="rg-devopsthehardway"
workspace_name="law-devopsthehardway"
subscription_id=$(az account show --query id -o tsv)

# Problem: Workspace name already exists globally
# Solution: Log Analytics workspace names must be globally unique
terraform plan | grep "already exists"

# Problem: Insufficient permissions
# Solution: Verify contributor/owner access to subscription
az role assignment list --assignee $(az account show --query user.name -o tsv) --query "[?roleDefinitionName=='Contributor' || roleDefinitionName=='Owner']"

# Problem: Solution deployment fails
# Solution: Check if ContainerInsights is supported in region
az provider show --namespace Microsoft.OperationsManagement --query "resourceTypes[?resourceType=='solutions'].locations"

# Problem: Retention period invalid
# Solution: Verify retention is between 30-730 days
terraform plan | grep "retention_in_days"

# Problem: Resource group not found
# Solution: Verify resource group exists
az group show --name $rg_name -o table