#/bin/bash

# View created resources
echo "Current Terraform-managed resources:"
cd ..
terraform show
echo ""

# Check outputs
echo "Terraform outputs:"
terraform output
echo ""