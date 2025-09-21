# Install tfsec Locally

#  Bash
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Run tfsec Locally
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks --tfvars-file=/workspaces/devops_the_hard_way/2-Terraform/4-aks/terraform.tfvars

# ---
# tfsec supports multiple output formats for CI/CD integration

# JSON output
tfsec --format=json /workspaces/devops_the_hard_way/2-Terraform/4-aks

# SARIF format (for GitHub Code Scanning)
tfsec --format=sarif /workspaces/devops_the_hard_way/2-Terraform/4-aks

# JUnit format (for test reporting)
tfsec --format=junit /workspaces/devops_the_hard_way/2-Terraform/4-aks

# ---
# Generate a Baseline to Ignore Existing Issues

# If you have existing issues that you want to ignore temporarily
tfsec --soft-fail --out=/workspaces/devops_the_hard_way/5-tf-static-code-scan/tfsec.baseline /workspaces/devops_the_hard_way/2-Terraform/4-aks

# Then use the baseline in future scans
tfsec --baseline /workspaces/devops_the_hard_way/5-tf-static-code-scan/tfsec.baseline /workspaces/devops_the_hard_way/2-Terraform/4-aks