# Remove specific resources if deployment fails partially
echo "Cleaning up specific resources..."
cd ..
terraform destroy -target=azurerm_application_load_balancer.alb
terraform destroy -target=azurerm_network_security_group.nsg
echo ""

# Complete cleanup
echo "Performing complete cleanup..."
terraform destroy
echo ""