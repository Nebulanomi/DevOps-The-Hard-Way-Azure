#!/bin/bash

#Apply Terraform configuration for Azure VNet

echo "Applying Terraform configuration..."
cd ..
terraform init --reconfigure
echo ""

echo "Validating and applying Terraform configuration..."
terraform validate
echo ""

echo "Planning and applying changes..."
terraform plan -var-file="terraform.tfvars"
echo ""

echo "Executing Terraform apply..."
terraform apply -var-file="terraform.tfvars" -auto-approve