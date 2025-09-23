#!/bin/bash

# Install terraform-docs locally for testing
curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.20.0/terraform-docs-v0.20.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs

# Test documentation generation
cd 2-Terraform/1-acr
terraform-docs markdown table --output-file README.md --output-mode inject .

# Review generated content
cat 2-Terraform/1-acr/README.md

# Create a test change and push to trigger workflow
git add .
git commit -m "feat: add terraform-docs configuration"
git push origin Updates-July-2025

# Create pull request to trigger documentation generation
# (This can be done via GitHub UI or GitHub CLI)