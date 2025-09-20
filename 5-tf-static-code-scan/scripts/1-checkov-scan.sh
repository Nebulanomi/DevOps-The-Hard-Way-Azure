# Check Python version (3.6+ required)
python3 --version
# or
python --version

# Install latest compatible version
pip3 install checkov==3.2.4
# OR
pip install checkov==3.2.4

#Run checkov
checkov

# Scan Terraform Code
checkov --directory /workspaces/devops_the_hard_way/2-Terraform/1-acr
checkov --directory /workspaces/devops_the_hard_way/2-Terraform/1-acr --compact
checkov --directory /workspaces/devops_the_hard_way/2-Terraform/1-acr --quiet