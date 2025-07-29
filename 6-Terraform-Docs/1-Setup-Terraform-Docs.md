# 📖 Set Up Terraform-docs with GitHub Actions

> **Difficulty Level:** 🟢 **Beginner** | **Estimated Time:** ⏱️ **20-25 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Understand terraform-docs** utility and its benefits
- [ ] **Configure GitHub Actions** for automated documentation generation
- [ ] **Set up README templates** with proper injection markers
- [ ] **Customize documentation output** for different modules
- [ ] **Implement automated documentation** workflow in your repository

## 📋 **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of GitHub Actions workflows
- [ ] Familiarity with Terraform module structure
- [ ] Markdown syntax and formatting
- [ ] Git pull request workflow

**🔧 Required Tools:**
- [ ] GitHub repository with Terraform code
- [ ] Permissions to modify GitHub Actions workflows
- [ ] Access to create/modify README.md files
- [ ] Completed: Terraform modules from previous tutorials

**🏗️ Infrastructure Dependencies:**
- [ ] Terraform modules with variables and outputs defined
- [ ] GitHub repository with Actions enabled
- [ ] Existing or new workflow file structure

## 🚀 **Step-by-Step Implementation**

### **Step 1: Understand Terraform-docs** ⏱️ *5 minutes*

1. **📚 Learn What Terraform-docs Does**
   
   **🎯 Purpose:** Automatically generates documentation from Terraform modules
   
   **📊 Extracts Information:**
   - [ ] **Inputs** - Module variables and their descriptions
   - [ ] **Outputs** - Module outputs and descriptions  
   - [ ] **Providers** - Required Terraform providers
   - [ ] **Requirements** - Terraform version constraints
   - [ ] **Resources** - AWS/Azure/GCP resources created
   - [ ] **Modules** - Child modules referenced

2. **🔍 Review Module Structure for Documentation**
   ```bash
   # Example: Check ACR module structure
   cd 2-Terraform-AZURE-Services-Creation/1-acr
   ls -la
   ```
   **✅ Required Files for Good Documentation:**
   - `variables.tf` - Input parameters with descriptions
   - `outputs.tf` - Module outputs with descriptions  
   - `versions.tf` - Provider requirements
   - `README.md` - Module documentation (to be auto-generated)

3. **📝 Example of Well-Documented Variables**
   ```hcl
   # variables.tf
   variable "acr_name" {
     description = "Name of the Azure Container Registry"
     type        = string
     validation {
       condition     = can(regex("^[a-zA-Z0-9]+$", var.acr_name))
       error_message = "ACR name must contain only alphanumeric characters."
     }
   }
   
   variable "location" {
     description = "Azure region where resources will be created"
     type        = string
     default     = "uksouth"
   }
   ```

### **Step 2: Configure GitHub Actions Workflow** ⏱️ *8 minutes*

4. **📂 Navigate to Workflow Directory**
   ```bash
   # Create .github/workflows directory if it doesn't exist
   mkdir -p .github/workflows
   cd .github/workflows
   ```

5. **📄 Update Existing Workflow or Create New One**
   
   **Option A: Add to Existing Workflow (recommended)**
   ```bash
   # Edit your existing main.yml workflow
   nano main.yml  # or code main.yml
   ```
   
   **Option B: Create Dedicated Documentation Workflow**
   ```bash
   # Create terraform-docs.yml workflow
   touch terraform-docs.yml
   ```

6. **⚙️ Add Terraform-docs Step to Workflow**
   ```yaml
   # Add this step to your existing workflow or create new one
   - name: Render terraform docs and push changes back to PR
     uses: terraform-docs/gh-actions@v1.3.0
     with:
       working-dir: |
         2-Terraform-AZURE-Services-Creation/1-acr
         2-Terraform-AZURE-Services-Creation/2-vnet
         2-Terraform-AZURE-Services-Creation/3-log-analytics
         2-Terraform-AZURE-Services-Creation/4-aks
       output-file: README.md
       output-method: inject
       git-push: "true"
       git-commit-message: "docs: update Terraform documentation"
   ```

   **🎯 Configuration Breakdown:**
   - `working-dir` - Directories containing Terraform modules
   - `output-file` - Target file for documentation (README.md)
   - `output-method` - How to insert docs (inject between markers)
   - `git-push` - Automatically commit changes back to PR
   - `git-commit-message` - Custom commit message for documentation updates

### **Step 3: Prepare README Templates** ⏱️ *8 minutes*

7. **📝 Create README.md Files for Each Module**
   ```bash
   # Example: Create README for ACR module
   cd ../../2-Terraform-AZURE-Services-Creation/1-acr
   
   cat > README.md << 'EOF'
   # Azure Container Registry (ACR) Module
   
   This Terraform module creates an Azure Container Registry with security best practices.
   
   ## Usage
   
   ```hcl
   module "acr" {
     source              = "./1-acr"
     acr_name           = "myregistry"
     resource_group_name = "my-rg"
     location           = "uksouth"
   }
   ```
   
   ## Documentation
   
   <!-- BEGIN_TF_DOCS -->
   <!-- END_TF_DOCS -->
   
   ## Security Features
   
   - Admin account disabled by default
   - Premium SKU for production workloads
   - Network access restrictions
   - Vulnerability scanning enabled
   EOF
   ```

8. **🔄 Repeat for Other Modules**
   ```bash
   # Create README for VNET module
   cd ../2-vnet
   cat > README.md << 'EOF'
   # Azure Virtual Network (VNET) Module
   
   Creates Azure Virtual Network with subnets, NSGs, and Application Load Balancer.
   
   ## Architecture
   
   This module provisions:
   - Virtual Network with custom address space
   - Multiple subnets for different workloads
   - Network Security Groups with proper associations
   - Application Load Balancer for container workloads
   
   <!-- BEGIN_TF_DOCS -->
   <!-- END_TF_DOCS -->
   EOF
   ```

9. **✅ Validate Marker Placement**
   ```bash
   # Check all README files have proper markers
   find ../.. -name "README.md" -exec grep -l "BEGIN_TF_DOCS" {} \;
   ```

### **Step 4: Test and Customize Documentation** ⏱️ *6 minutes*

10. **🎯 Create Custom Configuration (Optional)**
    ```bash
    # Create .terraform-docs.yml in repository root
    cd ../../
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
    ```

11. **🧪 Test Workflow Locally (Optional)**
    ```bash
    # Install terraform-docs locally for testing
    # macOS
    brew install terraform-docs
    
    # Test documentation generation
    cd 2-Terraform-AZURE-Services-Creation/1-acr
    terraform-docs markdown table --output-file README.md --output-mode inject .
    
    # Review generated content
    cat README.md
    ```

12. **🚀 Trigger Workflow**
    ```bash
    # Create a test change and push to trigger workflow
    git add .
    git commit -m "feat: add terraform-docs configuration"
    git push origin Updates-July-2025
    
    # Create pull request to trigger documentation generation
    # (This can be done via GitHub UI or GitHub CLI)
    ```

## ✅ **Validation Steps**

**🔍 Workflow Validation:**
- [ ] GitHub Actions workflow includes terraform-docs step
- [ ] All Terraform modules have README.md files with markers
- [ ] Configuration file properly formatted and placed
- [ ] Workflow permissions allow pushing changes

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "📖 Validating terraform-docs setup..."

# Check for workflow file
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
```

**📊 Documentation Quality Checklist:**
- [ ] **Variables** - All inputs documented with descriptions
- [ ] **Outputs** - All outputs documented with descriptions
- [ ] **Examples** - Usage examples provided in README
- [ ] **Architecture** - High-level module purpose explained
- [ ] **Security** - Security considerations documented

## 🚨 **Troubleshooting Guide**

**❌ Common Workflow Issues:**
```bash
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
```

**🔧 Configuration Issues:**
```bash
# Problem: Wrong working directories specified
# Solution: Verify module paths exist
for dir in 2-Terraform-AZURE-Services-Creation/1-acr 2-Terraform-AZURE-Services-Creation/2-vnet; do
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
```

**📝 Documentation Issues:**
```bash
# Problem: Poor variable descriptions
# Solution: Add meaningful descriptions to all variables
grep -r "description.*=" --include="*.tf" . | grep -v "TODO\|FIXME"

# Problem: Missing outputs documentation  
# Solution: Add descriptions to all outputs
find . -name "outputs.tf" -exec grep -L "description" {} \;
```

## 💡 **Knowledge Check**

**🎯 Documentation Best Practices:**
1. Why is automated documentation important for Infrastructure as Code?
2. How does terraform-docs determine what information to include?
3. What are the benefits of injecting documentation vs maintaining separate files?
4. How can automated documentation improve team collaboration?

**📝 Answers:**
1. **Automated documentation** ensures consistency, reduces maintenance burden, and keeps docs synchronized with code changes
2. **terraform-docs** parses Terraform files for variables, outputs, providers, and resources with their metadata
3. **Injection** keeps documentation close to code, ensures synchronization, and reduces duplication
4. **Team collaboration** improves through consistent formatting, up-to-date information, and reduced onboarding time

**🔍 Advanced Applications:**
- **Compliance:** How could terraform-docs help with compliance documentation?
- **Multi-environment:** How would you handle documentation for different environments?
- **Integration:** What other tools could complement terraform-docs?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] terraform-docs GitHub Actions workflow configured
- [ ] README templates created for all modules
- [ ] Documentation generation tested and validated
- [ ] Custom configuration applied for consistent formatting
- [ ] Automated documentation integrated into development workflow

**🚀 **Future Enhancements:**
- [ ] Add architecture diagrams using terraform-graph
- [ ] Implement pre-commit hooks for local development
- [ ] Create module-specific documentation standards
- [ ] Set up documentation validation in CI/CD pipeline

---

## 📚 **Additional Resources**

- 🔗 [Terraform-docs Documentation](https://terraform-docs.io/)
- 🔗 [GitHub Actions Marketplace](https://github.com/marketplace/actions/terraform-docs)
- 🔗 [Terraform Module Best Practices](https://www.terraform.io/docs/language/modules/develop/index.html)
- 🔗 [Documentation as Code](https://docs.github.com/en/communities/documenting-your-project-with-wikis)

**🎯 Pro Tips:**
- **Consistent formatting** across all modules improves readability
- **Rich descriptions** in variables and outputs enhance generated documentation
- **Examples in README** templates provide context for module usage
- **Regular updates** ensure documentation stays current with code changes

2. **Add terraform-docs GitHub Action**

   - Open your GitHub Actions workflow file (`.github/workflows/main.yml`) 
   ```yaml
   - name: Render terraform docs and push changes back to PR
     uses: terraform-docs/gh-actions@v1.3.0
     with:
       working-dir: .
       output-file: README.md
       output-method: inject
       git-push: "true"
   ```

3. **Prepare Your README.md Files**

   - For each Terraform module where you want documentation generated, open or create a README.md file
   - Add the terraform-docs markers where you want the documentation inserted:

   ```markdown
   <!-- BEGIN_TF_DOCS -->
   <!-- END_TF_DOCS -->
   ```

   These markers tell terraform-docs where to inject the generated documentation.

4. **Test the Workflow**

   - Make a change to your Terraform code
   - Create a pull request
   - The GitHub Action will automatically run and update your README.md files with generated documentation
   - The changes will be pushed back to the same PR

## 🔍 Verification

To ensure terraform-docs is working correctly:
1. Create a pull request with a change to Terraform code
2. Wait for the GitHub Action to complete
3. Check that the README.md files have been updated with documentation between the markers
4. Verify that the documentation accurately reflects your Terraform code

Example of generated documentation:

```
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region for resources | `string` | `"uksouth"` | no |

## Outputs

| Name | Description |
|------|-------------|
| acr_id | ID of the Azure Container Registry |
```

## 🧠 Knowledge Check

After setting up terraform-docs, consider these questions:
1. Why is automated documentation important for infrastructure as code?
2. How does terraform-docs determine what to include in the documentation?
3. What are the benefits of injecting documentation into README files versus maintaining separate docs?
4. How can terraform-docs improve collaboration in a team environment?

## 💡 Pro Tips

1. **Customising Output Format**

   You can customise the output format using a `.terraform-docs.yml` file in your repository root:

   ```yaml
   formatter: "markdown table"
   
   sections:
     show:
       - requirements
       - providers
       - inputs
       - outputs
       - resources
   
   output:
     file: README.md
     mode: inject
     template: |-
       <!-- BEGIN_TF_DOCS -->
       {{ .Content }}
       <!-- END_TF_DOCS -->
   ```

2. **Module-Specific Configuration**

   For different documentation in different modules, create module-specific configuration files:

   ```
   my-terraform-project/
   ├── .terraform-docs.yml  # Default config
   ├── module1/
   │   ├── .terraform-docs.yml  # Module-specific config
   │   └── README.md
   └── module2/
       └── README.md
   ```

3. **Configure Which Files to Document**

   In your GitHub workflow, specify which directories to document:

   ```yaml
   with:
     working-dir: |
       terraform/module1
       terraform/module2
     output-file: README.md
     output-method: inject
     git-push: "true"
   ```

4. **Pre-Commit Hook for Local Development**

   Install terraform-docs locally and set up a pre-commit hook to maintain documentation during development:

   ```bash
   # Install terraform-docs (macOS)
   brew install terraform-docs
   
   # Run manually
   terraform-docs markdown table --output-file README.md --output-mode inject ./my-module
   ```

5. **Adding Diagrams**

   Consider enhancing your documentation with architecture diagrams using tools like [Terraform Graph](https://github.com/offu/terraform-graph):

   ```bash
   terraform graph | dot -Tsvg > graph.svg
   ```

   Then include the SVG in your README.md outside the terraform-docs markers.
