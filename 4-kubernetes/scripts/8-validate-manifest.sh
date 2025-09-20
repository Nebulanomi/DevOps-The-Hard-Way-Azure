# Comprehensive validation script
echo "📄 Validating Kubernetes manifest..."

# Check if manifest file exists
cd ..
if [ -f "deployment.yml" ]; then
    echo "✅ Manifest file found"
    
    # Validate YAML syntax
    if kubectl apply --dry-run=client -f deployment.yml &>/dev/null; then
        echo "✅ YAML syntax valid"
        
        # Check if image URL is updated
        if grep -q "azurecr.io" deployment.yml; then
            echo "✅ ACR image URL configured"
        else
            echo "❌ ACR image URL needs to be updated"
        fi
        
        # Count manifest objects
        OBJECT_COUNT=$(kubectl apply --dry-run=client -f deployment.yml | wc -l)
        echo "📊 Manifest objects: $OBJECT_COUNT"
        
        echo "✅ Manifest validation complete!"
    else
        echo "❌ YAML syntax validation failed"
        kubectl apply --dry-run=client -f deployment.yml
        exit 1
    fi
else
    echo "❌ deployment.yml file not found"
    exit 1
fi