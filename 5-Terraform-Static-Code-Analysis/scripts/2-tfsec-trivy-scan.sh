# Install tfsec Locally
#  Bash
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Run tfsec Locally
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks --tfvars-file=/workspaces/devops_the_hard_way/2-Terraform/4-aks/terraform.tfvars

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.66.0

# Run Trivy IaC Scan
trivy config .