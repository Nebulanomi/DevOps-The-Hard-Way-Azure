#/bin/bash

curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.20.0/terraform-docs-v0.20.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs

# Test documentation generation
cd 2-Terraform/1-acr
terraform-docs markdown table --output-file README.md --output-mode inject .

# Review generated content
cat 2-Terraform/1-acr/README.md