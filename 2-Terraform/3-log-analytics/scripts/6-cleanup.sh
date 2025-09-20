#/bin/bash

# Remove specific solution if deployment fails
cd ..
echo "Cleaning up specific Log Analytics solution..."
terraform destroy -target=azurerm_log_analytics_solution.container_insights
echo ""

# Remove workspace
echo "Cleaning up Log Analytics workspace..."
terraform destroy -target=azurerm_log_analytics_workspace.law
echo ""

# Complete cleanup
echo "Performing complete cleanup..."
terraform destroy
echo ""