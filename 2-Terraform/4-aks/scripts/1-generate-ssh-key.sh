#/bin/bash

echo "Generating SSH key for AKS..."
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aks_key -C "your-email@example.com"
echo ""

echo "Public key generated:"
cat ~/.ssh/aks_key.pub  # Copy this to terraform.tfvars
echo ""