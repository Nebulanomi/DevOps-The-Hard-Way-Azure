# 🗄️ Configure Storage Account for Terraform State File

> **Estimated Time:** ⏱️ **10-15 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Understand Terraform state management** and remote storage benefits
- [ ] **Create Azure Storage Account** with security best practices
- [ ] **Configure blob container** for Terraform state files
- [ ] **Implement security measures** for production-ready storage
- [ ] **Validate storage setup** through Azure Portal and CLI

## 📋 **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of Terraform fundamentals
- [ ] Familiarity with Azure Resource Groups and Storage Accounts
- [ ] Command-line interface operations

**🔧 Required Tools:**
- [ ] Azure CLI installed and configured
- [ ] Azure subscription with Contributor permissions
- [ ] Terminal/command line access
- [ ] Text editor for script customization

**🏗️ Infrastructure Dependencies:**
- [ ] Active Azure subscription
- [ ] Azure CLI authenticated (`az login` completed)
- [ ] Sufficient permissions to create resources

## � **Step-by-Step Implementation**

### **Step 1: Understand Remote State Benefits** ⏱️ *3 minutes*

1. **📚 Why Remote State Storage?**
   
   **🎯 Benefits of Remote State:**
   - [ ] **Team Collaboration** - Multiple developers can share state
   - [ ] **State Locking** - Prevents concurrent modifications
   - [ ] **Security** - Centralized, encrypted storage
   - [ ] **Backup & Recovery** - Automatic versioning and backup
   - [ ] **Consistency** - Single source of truth for infrastructure state

2. **🔒 Azure Blob Storage Advantages**
   - [ ] **Encryption at rest** - Data automatically encrypted
   - [ ] **Access control** - Fine-grained permissions with Azure RBAC
   - [ ] **Versioning** - Built-in state file versioning
   - [ ] **Geo-redundancy** - High availability across regions
   - [ ] **Cost-effective** - Pay-as-you-use storage model

### **Step 2: Customize Configuration Script** ⏱️ *5 minutes*

3. **📂 Navigate to Azure Scripts Directory**
   ```bash
   cd 1-Azure/scripts
   ls -la
   ```
   **✅ Expected Files:**
   - `1-create-terraform-storage.sh`
   - `2-create-azure-ad-group.sh`

4. **📝 Review and Customize Storage Script**
   ```bash
   # View the script content
   cat 1-create-terraform-storage.sh
   ```

5. **⚙️ Update Configuration Variables**
   ```bash
   # Edit the script with your preferred editor
   nano 1-create-terraform-storage.sh
   # or
   code 1-create-terraform-storage.sh
   ```
   
   **🎯 Key Variables to Customize:**
   ```bash
   # Find and update these lines:
   RESOURCE_GROUP_NAME="devopsthehardway-rg"
   STORAGE_ACCOUNT_NAME="devopsthehardwaysa"
   CONTAINER_NAME="tfstate"
   LOCATION="uksouth"
   ```
   
   **💡 Naming Guidelines:**
   - **Storage Account:** 3-24 characters, lowercase letters and numbers only
   - **Resource Group:** Descriptive name for your project
   - **Location:** Choose region closest to your development team

6. **🔍 Understand Script Operations**
   
   **📋 Script Workflow:**
   ```bash
   # The script will:
   # 1. Create Resource Group
   az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
   
   # 2. Create Storage Account with security settings
   az storage account create \
     --name $STORAGE_ACCOUNT_NAME \
     --resource-group $RESOURCE_GROUP_NAME \
     --location $LOCATION \
     --sku Standard_LRS \
     --encryption-services blob \
     --https-only true \
     --allow-blob-public-access false
   
   # 3. Create Blob Container
   az storage container create \
     --name $CONTAINER_NAME \
     --account-name $STORAGE_ACCOUNT_NAME
   ```

### **Step 3: Execute Storage Setup** ⏱️ *5 minutes*

7. **🚀 Run the Storage Creation Script**
   ```bash
   # Make script executable
   chmod +x 1-create-terraform-storage.sh
   
   # Execute the script
   ./1-create-terraform-storage.sh
   ```
   **⏱️ Execution Time:** 2-3 minutes
   
   **✅ Expected Output:**
   ```json
   {
     "id": "/subscriptions/.../resourceGroups/devopsthehardway-rg",
     "location": "uksouth",
     "name": "devopsthehardway-rg",
     "properties": {
       "provisioningState": "Succeeded"
     }
   }
   ```

8. **📋 Capture Backend Configuration**
   ```bash
   # The script should output Terraform backend configuration
   # Save this for use in your Terraform configurations:
   
   # Example output:
   # terraform {
   #   backend "azurerm" {
   #     resource_group_name  = "devopsthehardway-rg"
   #     storage_account_name = "devopsthehardwaysa"
   #     container_name       = "tfstate"
   #     key                  = "terraform.tfstate"
   #   }
   # }
   ```

### **Step 4: Verify and Secure Setup** ⏱️ *4 minutes*

9. **🔍 Verify Through Azure Portal**
   - Navigate to [Azure Portal](https://portal.azure.com)
   - Search for your resource group
   - Verify storage account creation
   - Check blob container exists

10. **📋 Verify Using Azure CLI**
    ```bash
    # Check resource group
    az group show --name devopsthehardway-rg --output table
    
    # Verify storage account
    az storage account show --name devopsthehardwaysa --resource-group devopsthehardway-rg --output table
    
    # List containers
    az storage container list --account-name devopsthehardwaysa --output table
    ```

11. **🔒 Implement Additional Security (Recommended)**
    ```bash
    # Add resource lock to prevent accidental deletion
    az lock create \
      --name "TerraformStorageLock" \
      --lock-type CanNotDelete \
      --resource-group devopsthehardway-rg \
      --resource-name devopsthehardwaysa \
      --resource-type Microsoft.Storage/storageAccounts
    
    # Enable soft delete for blobs
    az storage blob service-properties delete-policy update \
      --account-name devopsthehardwaysa \
      --enable true \
      --days-retained 7
    ```

## ✅ **Validation Steps**

**🔍 Infrastructure Validation:**
- [ ] Resource group created successfully
- [ ] Storage account deployed with correct configuration
- [ ] Blob container accessible and properly configured
- [ ] Security settings applied (HTTPS-only, encryption enabled)
- [ ] Access permissions properly configured

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "🗄️ Validating Terraform storage setup..."

# Check if resource group exists
RG_NAME="devopsthehardway-rg"
SA_NAME="devopsthehardwaysa"

if az group show --name $RG_NAME &>/dev/null; then
    echo "✅ Resource group exists"
    
    # Check storage account
    if az storage account show --name $SA_NAME --resource-group $RG_NAME &>/dev/null; then
        echo "✅ Storage account exists"
        
        # Check encryption settings
        ENCRYPTION=$(az storage account show --name $SA_NAME --resource-group $RG_NAME --query "encryption.services.blob.enabled" -o tsv)
        echo "🔒 Blob encryption enabled: $ENCRYPTION"
        
        # Check HTTPS enforcement
        HTTPS_ONLY=$(az storage account show --name $SA_NAME --resource-group $RG_NAME --query "enableHttpsTrafficOnly" -o tsv)
        echo "🔐 HTTPS-only enabled: $HTTPS_ONLY"
        
        # Check container
        CONTAINER_COUNT=$(az storage container list --account-name $SA_NAME --output tsv | wc -l)
        echo "📦 Containers created: $CONTAINER_COUNT"
        
        echo "✅ Terraform storage validation complete!"
    else
        echo "❌ Storage account not found"
        exit 1
    fi
else
    echo "❌ Resource group not found"
    exit 1
fi
```

**📊 Security Checklist:**
- [ ] **Encryption** - Blob storage encryption enabled
- [ ] **HTTPS** - Secure transport enforced
- [ ] **Public Access** - Blob public access disabled
- [ ] **Access Control** - Proper RBAC permissions
- [ ] **Resource Lock** - Protection against accidental deletion

## 🚨 **Troubleshooting Guide**

**❌ Common Setup Issues:**
```bash
# Problem: Storage account name already exists globally
# Solution: Storage account names must be globally unique
az storage account check-name --name $STORAGE_ACCOUNT_NAME

# Problem: Insufficient permissions
# Solution: Verify your Azure CLI permissions
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Problem: Region not available
# Solution: Check available locations
az account list-locations --output table
```

**🔧 Configuration Issues:**
```bash
# Problem: Container creation fails
# Solution: Verify storage account exists and permissions
az storage account show --name $SA_NAME --resource-group $RG_NAME

# Problem: Script execution fails
# Solution: Check script permissions and syntax
chmod +x 1-create-terraform-storage.sh
bash -n 1-create-terraform-storage.sh  # Syntax check

# Problem: Backend configuration not working
# Solution: Verify storage account key access
az storage account keys list --resource-group $RG_NAME --account-name $SA_NAME
```

**🧹 Cleanup Commands:**
```bash
# Remove resource lock before deletion
az lock delete --name "TerraformStorageLock" --resource-group $RG_NAME

# Delete storage account (careful!)
az storage account delete --name $SA_NAME --resource-group $RG_NAME --yes

# Delete resource group (removes everything)
az group delete --name $RG_NAME --yes --no-wait
```

## 💡 **Knowledge Check**

**🎯 Terraform State Concepts:**
1. What happens if multiple people run Terraform simultaneously without remote state?
2. How does Terraform state locking prevent conflicts?
3. What information is stored in the Terraform state file?
4. How does remote state improve team collaboration?

**📝 Answers:**
1. **Concurrent execution** can cause state corruption and conflicting infrastructure changes
2. **State locking** uses blob leases to ensure only one Terraform operation runs at a time
3. **State file** contains resource mappings, metadata, dependencies, and current configuration
4. **Remote state** provides shared access, consistency, security, and automated backup

**🔍 Advanced Concepts:**
- **State Encryption:** How is sensitive data protected in state files?
- **Versioning:** How can you roll back to previous state versions?
- **Migration:** How would you migrate from local to remote state?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Secure Azure Storage Account created for Terraform state
- [ ] Blob container configured with proper permissions
- [ ] Security best practices implemented
- [ ] Backend configuration ready for Terraform projects
- [ ] Understanding of remote state management benefits

**➡️ Continue to:** [Create Azure AD Group for AKS Admins](./2-Create-Azure-AD-Group-AKS-Admins.md)

---

## 📚 **Additional Resources**

- 🔗 [Terraform Backend Configuration](https://www.terraform.io/language/settings/backends/azurerm)
- 🔗 [Azure Storage Security Guide](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide)
- 🔗 [Terraform State Best Practices](https://www.terraform.io/language/state)
- 🔗 [Azure CLI Storage Commands](https://docs.microsoft.com/en-us/cli/azure/storage)

**🎯 Pro Tips:**
- Use **separate storage accounts** for different environments (dev/staging/prod)
- Enable **soft delete and versioning** for production workloads
- Implement **network restrictions** to limit storage account access
- Consider **customer-managed keys** for additional encryption control

## 🔍 Verification
To ensure everything was set up correctly:

1. Log into the [Azure Portal](https://portal.azure.com).
2. Navigate to your newly created Resource Group.
3. Verify the presence of the Storage Account.
4. Within the Storage Account, check for the Blob container.
5. It should look similar to this:

![](images/storage-account.png)

## 🧠 Knowledge Check
After running the script, try to answer these questions:
1. Why is it important to use remote state storage for Terraform?
2. What are the benefits of using Azure Blob Storage for this purpose?
3. How would you access this state file in your Terraform configurations?

## 💡 Pro Tip
Consider implementing these additional security measures for production environments:
1. Enable soft delete and versioning for your blob storage to protect against accidental deletion
2. Set up a resource lock to prevent accidental deletion of the storage account
3. Use Managed Identities instead of storage account keys for authentication
4. Configure network rules to restrict access to specific networks
5. Set up Azure Key Vault to store sensitive backend configuration

Example of adding a resource lock:
```bash
az lock create --name LockTerraformStorage --lock-type CanNotDelete \
  --resource-group devopshardway-rg \
  --resource-name devopshardwaysa \
  --resource-type Microsoft.Storage/storageAccounts
```