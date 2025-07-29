# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the DevOps The Hard Way - Azure tutorial.

## 📋 Workflow Files

### 🔧 `main.yml` - Tutorial Example Workflow
**Purpose**: Educational content demonstrating CI/CD pipeline setup
**Status**: ⚠️ **DISABLED** - Tutorial content only

This workflow is provided as an example for learning purposes and is **not intended to run** in this tutorial repository.

**Features:**
- Terraform deployment automation
- Azure OIDC authentication
- Static code analysis hooks (commented)
- Terraform documentation generation hooks (commented)

**To Use This Workflow:**
1. Fork or copy this repository to your own GitHub account
2. Set up Azure OIDC authentication (see tutorial)
3. Enable the workflow by modifying the `on:` triggers
4. Customize the configuration for your environment

### 🚀 `deploy-full.yml` - Complete Deployment Pipeline
**Purpose**: Full infrastructure and application deployment
**Status**: ✅ **ACTIVE** - Manual trigger only

This workflow provides complete deployment automation including:
- Infrastructure provisioning (ACR, VNET, Log Analytics, AKS)
- Docker image building and pushing
- Kubernetes application deployment
- ALB Controller and Gateway setup
- Optional resource cleanup

**Triggers:**
- Manual execution only (`workflow_dispatch`)
- Environment selection (dev/staging/prod)
- Optional cleanup after deployment

## 🎓 Educational Notes

### Why Two Workflows?

1. **`main.yml`**: Demonstrates traditional CI/CD patterns
   - Shows basic Terraform automation
   - Includes hooks for advanced features
   - Focuses on single component (AKS)
   - Educational and reference material

2. **`deploy-full.yml`**: Complete solution approach
   - Deploys entire infrastructure stack
   - Production-ready patterns
   - Multi-environment support
   - Practical automation tool

### Security Considerations

Both workflows use:
- ✅ Azure OIDC authentication (no stored secrets)
- ✅ Least privilege access patterns
- ✅ Environment-specific configurations
- ✅ Manual approval workflows for production

### Best Practices Demonstrated

- **Infrastructure as Code**: All resources defined in Terraform
- **GitOps**: Infrastructure changes through Git workflows
- **Immutable Infrastructure**: Complete rebuilds vs. updates
- **Environment Isolation**: Separate state files and configurations
- **Automated Testing**: Built-in validation and testing steps

## 🔧 Setup Instructions

### For Tutorial Learning:
1. Study the workflow files as examples
2. Understand the patterns and practices
3. Follow the tutorial documentation

### For Practical Use:
1. Copy/fork this repository
2. Set up Azure service principal or OIDC
3. Configure GitHub secrets
4. Customize for your environment
5. Enable and run workflows

## 📚 Related Documentation

- [CI/CD Tutorial](../2-Terraform-AZURE-Services-Creation/5-Run-CICD-For-AKS-Cluster.md)
- [Deployment Scripts](../scripts/README.md)
- [Azure OIDC Setup](../2-Terraform-AZURE-Services-Creation/scripts/5-create-github-oidc.sh)

## 🤝 Contributing

These workflows are part of the tutorial content. If you find improvements or issues:
- Open an issue for discussion
- Submit a pull request with improvements
- Update related documentation
