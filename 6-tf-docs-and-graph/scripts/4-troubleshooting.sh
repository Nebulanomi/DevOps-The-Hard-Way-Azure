# Common Workflow Issues:

# Problem: terraform-docs action fails
# Solution: Check workflow syntax and permissions
# Verify the workflow file syntax
cat .github/workflows/main.yml | grep -A 10 "terraform-docs"

# Problem: No changes pushed back to PR
# Solution: Verify git-push permissions and settings
# Check if workflow has write permissions to repository

# Problem: Documentation not generated
# Solution: Verify markers exist in README files
grep -r "BEGIN_TF_DOCS" --include="*.md" .

# ---
# Configuration Issues:

# Problem: Wrong working directories specified
# Solution: Verify module paths exist
for dir in 2-Terraform/1-acr 2-Terraform/2-vnet; do
    if [ -d "$dir" ]; then
        echo "✅ $dir exists"
    else
        echo "❌ $dir not found"
    fi
done

# Problem: Malformed YAML configuration
# Solution: Validate YAML syntax
if command -v yamllint &> /dev/null; then
    yamllint .terraform-docs.yml
else
    python3 -c "import yaml; yaml.safe_load(open('.terraform-docs.yml'))"
fi

# ---
# Documentation Issues:

# Problem: Poor variable descriptions
# Solution: Add meaningful descriptions to all variables
grep -r "description.*=" --include="*.tf" . | grep -v "TODO\|FIXME"

# Problem: Missing outputs documentation  
# Solution: Add descriptions to all outputs
find . -name "outputs.tf" -exec grep -L "description" {} \;