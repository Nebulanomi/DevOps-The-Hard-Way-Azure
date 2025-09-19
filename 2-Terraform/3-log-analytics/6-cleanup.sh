#/bin/bash

# Remove specific solution if deployment fails
terraform destroy -target=azurerm_log_analytics_solution.container_insights

# Remove workspace
terraform destroy -target=azurerm_log_analytics_workspace.law

# Complete cleanup
terraform destroy