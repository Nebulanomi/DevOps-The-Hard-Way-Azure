#Install tfsec Locally
# Homebrew (macOS/Linux):
brew install tfsec

# Docker:
docker run --rm -it -v "$(pwd):/src" aquasec/tfsec /src

# Go:
go install github.com/aquasecurity/tfsec/cmd/tfsec@latest

# Chocolatey (Windows):
choco install tfsec

# Run tfsec Locally
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks
tfsec /workspaces/devops_the_hard_way/2-Terraform/4-aks --tfvars-file=/workspaces/devops_the_hard_way/2-Terraform/4-aks/terraform.tfvars