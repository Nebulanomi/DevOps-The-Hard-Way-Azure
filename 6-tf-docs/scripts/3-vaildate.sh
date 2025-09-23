# Comprehensive validation script
echo "📖 Validating terraform-docs setup..."

# Check for workflow file
cd ../..
if [ -f ".github/workflows/main.yml" ]; then
    echo "✅ GitHub Actions workflow found"
    
    # Check if terraform-docs is configured
    if grep -q "terraform-docs" .github/workflows/main.yml; then
        echo "✅ terraform-docs step configured"
    else
        echo "❌ terraform-docs step not found in workflow"
    fi
else
    echo "❌ GitHub Actions workflow not found"
fi

# Check README files with markers
README_COUNT=$(find . -name "README.md" -exec grep -l "BEGIN_TF_DOCS" {} \; | wc -l)
echo "📊 README files with terraform-docs markers: $README_COUNT"

# Check terraform modules
MODULE_COUNT=$(find . -name "*.tf" -exec dirname {} \; | sort -u | wc -l)
echo "📊 Terraform modules found: $MODULE_COUNT"

if [ -f ".terraform-docs.yml" ]; then
    echo "✅ Custom terraform-docs configuration found"
else
    echo "ℹ️ Using default terraform-docs configuration"
fi

echo "✅ terraform-docs validation complete!"