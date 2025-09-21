# Add the start and end of the Terraform docs section in README.md files
cat > README.md << 'EOF'
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF

# Verify if README.md files contain the string "BEGIN_TF_DOCS"
sudo find /../workspaces/ -name "README.md" -exec grep -l "BEGIN_TF_DOCS" {} \;

# Create .terraform-docs.yml in repository root
cd ..
cat > .terraform-docs.yml << 'EOF'
formatter: "markdown table"

sections:
  show:
    - requirements
    - providers
    - inputs
    - outputs
    - resources
  hide: []

output:
  file: README.md
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
    {{ .Content }}
    <!-- END_TF_DOCS -->

sort:
  enabled: true
  by: name

settings:
  anchor: true
  color: true
  default: true
  description: true
  escape: true
  hide-empty: false
  html: true
  indent: 2
  lockfile: true
  read-comments: true
  required: true
  sensitive: true
  type: true
EOF

# Install terraform-docs locally for testing
curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.20.0/terraform-docs-v0.20.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs

# Test documentation generation
cd 2-Terraform/1-acr
terraform-docs markdown table --output-file README.md --output-mode inject .

# Review generated content
cat 2-Terraform/1-acr/README.md

# Update main
git add .
git commit -m "feat: add terraform-docs configuration"
git push

# Create a new repository branch
git branch add-terraform-docs && git switch add-terraform-docs
# Create pull request to trigger documentation generation
# (This can be done via GitHub UI or GitHub CLI)
#wow