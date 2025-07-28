# Automation Scripts Documentation

This directory contains automation scripts for deploying and managing the DevOps The Hard Way Azure infrastructure.

## 📁 Scripts Overview

### 🚀 `deploy-all.sh`
**Purpose:** Complete infrastructure and application deployment

**What it does:**
- ✅ Validates prerequisites (Azure CLI, Terraform, Docker, kubectl, Helm)
- ✅ Creates Terraform remote state storage
- ✅ Creates Azure AD group for AKS admins
- ✅ Deploys all Terraform infrastructure (ACR, VNET, Log Analytics, AKS)
- ✅ Builds and pushes Docker image to ACR
- ✅ Deploys application to Kubernetes
- ✅ Installs ALB Controller and Gateway resources
- ✅ Provides application URL for testing

**Usage:**
```bash
# Deploy with default settings
./scripts/deploy-all.sh

# Deploy with custom project name and location
PROJECT_NAME="myproject" LOCATION="westeurope" ./scripts/deploy-all.sh
```

**Environment Variables:**
- `PROJECT_NAME` (default: `devopsthehardway`) - Project name prefix
- `LOCATION` (default: `uksouth`) - Azure region

---

### 🗑️ `cleanup-all.sh`
**Purpose:** Complete resource cleanup and destruction

**What it does:**
- ⚠️ Prompts for confirmation (type 'DELETE')
- 🗑️ Removes Kubernetes resources (deployments, services, namespaces)
- 🗑️ Uninstalls ALB Controller and Gateway resources
- 🗑️ Destroys all Terraform infrastructure (in reverse order)
- 🗑️ Deletes Azure resource groups
- 🗑️ Optionally removes Terraform state storage
- 🗑️ Optionally cleans up local Docker images

**Usage:**
```bash
# Interactive cleanup (recommended)
./scripts/cleanup-all.sh

# Automated cleanup (for CI/CD)
echo "DELETE" | ./scripts/cleanup-all.sh
```

**Safety Features:**
- Requires typing 'DELETE' to confirm
- Optional Terraform state cleanup
- Optional local Docker image cleanup
- Progress indicators and error handling

---

### 🧪 `quick-test.sh`
**Purpose:** Full deployment cycle for testing

**What it does:**
- 🚀 Runs complete deployment with timestamped project name
- ⏸️ Pauses for manual testing and verification
- 🗑️ Automatically cleans up resources after confirmation

**Usage:**
```bash
# Run quick test with random project name
./scripts/quick-test.sh

# Run quick test with specific settings
PROJECT_NAME="test123" ./scripts/quick-test.sh
```

**Perfect for:**
- Testing changes before production
- Demonstrating the full solution
- CI/CD pipeline validation

---

## 🤖 GitHub Actions Workflows

### `.github/workflows/deploy-full.yml`
**Purpose:** Complete CI/CD pipeline for Azure deployment

**Triggers:**
- 📋 Push to `main` branch
- 📋 Pull requests to `main` branch
- 📋 Manual workflow dispatch with options

**Features:**
- 🔐 Azure OIDC authentication
- 🏗️ Multi-environment support (dev/staging/prod)
- 🧪 Optional post-deployment cleanup
- 📊 Deployment summaries and reports
- 🔍 Application health testing

**Environment Inputs:**
- `environment` - Target environment (dev/staging/prod)
- `destroy_after_deploy` - Auto-cleanup for testing

**Required Secrets:**
- `AZURE_AD_CLIENT_ID` - Azure service principal client ID
- `AZURE_AD_TENANT_ID` - Azure tenant ID
- `AZURE_SUBSCRIPTION_ID` - Azure subscription ID

---

## 🛠️ Prerequisites

Before running any scripts, ensure you have:

### Required Tools
- ✅ **Azure CLI** (2.0+) - `az --version`
- ✅ **Terraform** (1.9.8+) - `terraform version`
- ✅ **Docker** - `docker --version`
- ✅ **kubectl** - `kubectl version --client`
- ✅ **Helm** (3.0+) - `helm version`

### Azure Setup
- ✅ Azure subscription with appropriate permissions
- ✅ Logged into Azure CLI (`az login`)
- ✅ Service principal for GitHub Actions (if using CI/CD)

### Permissions Required
- ✅ Contributor role on subscription
- ✅ Azure AD permissions to create groups
- ✅ Ability to create resource groups
- ✅ Container Registry permissions

---

## 📋 Usage Patterns

### 🎓 Learning/Tutorial Mode
```bash
# Follow the manual labs step by step
# Use individual Terraform commands for each component
```

### 🧪 Development/Testing Mode
```bash
# Quick iteration testing
./scripts/quick-test.sh

# Keep environment for extended testing
./scripts/deploy-all.sh
# ... test your changes ...
./scripts/cleanup-all.sh
```

### 🚀 Production Deployment Mode
```bash
# Use GitHub Actions with proper environment controls
# Manual review and approval processes
# Environment-specific configurations
```

---

## 🔧 Customization

### Project Configuration
Edit the scripts to modify:
- Default project names and locations
- Resource sizing (VM sizes, node counts)
- Network configurations
- Tags and metadata

### Environment-Specific Settings
The scripts support environment variables for:
- `PROJECT_NAME` - Resource naming prefix
- `LOCATION` - Azure region
- Custom terraform.tfvars content

### Example Customizations
```bash
# Deploy to different region with custom name
PROJECT_NAME="mycompany-prod" LOCATION="westeurope" ./scripts/deploy-all.sh

# Use different Kubernetes version
export KUBERNETES_VERSION="1.32"
./scripts/deploy-all.sh
```

---

## 🚨 Important Notes

### Resource Cleanup
- Resource group deletions run in background (10-15 minutes)
- Some resources may have soft-delete policies
- Check Azure Portal to confirm complete cleanup

### Cost Management
- AKS clusters incur ongoing costs
- Use auto-scaling and spot instances for dev/test
- Always clean up test environments

### Security Considerations
- SSH keys are generated for each deployment
- Azure AD groups control AKS access
- Use RBAC and least-privilege principles
- Rotate secrets regularly

### Troubleshooting
- Check script output for detailed error messages
- Verify Azure CLI authentication
- Ensure required permissions
- Check Terraform state for conflicts

---

## 🎯 Best Practices

1. **Always test in dev environment first**
2. **Use version control for custom modifications**
3. **Monitor resource usage and costs**
4. **Keep secrets secure and rotated**
5. **Use descriptive project names for multiple environments**
6. **Document any customizations**
7. **Regularly update tool versions**

For more detailed information, see the individual lab documentation in the repository.
