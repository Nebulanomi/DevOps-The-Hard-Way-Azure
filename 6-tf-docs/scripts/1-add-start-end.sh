# Add the start and end of the Terraform docs section in README.md files for each module
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