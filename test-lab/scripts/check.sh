#!/bin/bash
echo "🔍 DevOps Learning Platform - System Validation"
echo "=============================================="

# Check Azure CLI
if command -v az &> /dev/null; then
    echo "✅ Azure CLI: $(az --version | head -n1)"
    if az account show &> /dev/null; then
        echo "✅ Azure Authentication: Active"
    else
        echo "❌ Azure Authentication: Please run 'az login'"
    fi
else
    echo "❌ Azure CLI: Not installed"
fi

# Check Terraform
if command -v terraform &> /dev/null; then
    echo "✅ Terraform: $(terraform --version | head -n1)"
else
    echo "❌ Terraform: Not installed"
fi

# Check Docker
if command -v docker &> /dev/null; then
    echo "✅ Docker: $(docker --version)"
    if docker ps &> /dev/null; then
        echo "✅ Docker Service: Running"
    else
        echo "⚠️ Docker Service: Not running"
    fi
else
    echo "❌ Docker: Not installed"
fi

# Check kubectl
if command -v kubectl &> /dev/null; then
    echo "✅ kubectl: $(kubectl version --client)"
else
    echo "❌ kubectl: Not installed"
fi

# Check Python
if command -v python3 &> /dev/null; then
    echo "✅ Python: $(python3 --version)"
else
    echo "❌ Python3: Not installed"
fi

# Check Checkov
if command -v checkov &> /dev/null; then
    echo "✅ Checkov: $(checkov --version)"
else
    echo "⚠️ Checkov: Not installed (recommended for security tutorials)"
fi

echo ""
echo "🎯 Validation complete! Review any ❌ items before starting tutorials."