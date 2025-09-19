# 🌐 Create an Azure VNET

> **Estimated Time:** ⏱️ **25-30 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Create Azure VNET** with properly segmented subnets
- [ ] **Configure Network Security Groups** for enhanced security
- [ ] **Deploy Application Gateway for Containers** for load balancing
- [ ] **Understand Azure networking** concepts and best practices
- [ ] **Validate network infrastructure** through Azure Portal

## 📋 **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of Azure networking concepts (VNETs, subnets, NSGs)
- [ ] Familiarity with Terraform configuration files
- [ ] Azure CLI authentication completed

**🔧 Required Tools:**
- [ ] Terraform CLI installed and configured
- [ ] Azure CLI with active subscription
- [ ] Access to Azure subscription with Contributor permissions
- [ ] Completed: [Configure Terraform Remote Storage](../1-Azure/1-Configure-Terraform-Remote-Storage.md)

**🏗️ Infrastructure Dependencies:**
- [ ] Azure Storage Account for Terraform state (from previous tutorial)
- [ ] Resource group for VNET resources

## 🚀 **Step-by-Step Implementation**

### **Step 1: Review Terraform Configuration** ⏱️ *8 minutes*

1. **📂 Navigate to VNET Directory**
   ```bash
   cd 2-Terraform-AZURE-Services-Creation/2-vnet
   ```

2. **📋 Review terraform.tfvars Configuration**
   ```bash
   cat terraform.tfvars
   ```
   **🔍 Key Variables to Verify:**
   - [ ] `location` - Azure region (default: uksouth)
   - [ ] `resource_group_name` - Target resource group
   - [ ] `vnet_address_space` - CIDR block for VNET
   - [ ] `subnet_configurations` - Subnet definitions

3. **🏗️ Understand Infrastructure Components**

   **📄 vnet.tf - Virtual Network:**
   ```hcl
   # Creates VNET with address space
   resource "azurerm_virtual_network" "vnet" {
     name                = var.vnet_name
     address_space       = [var.vnet_address_space]
     location            = var.location
     resource_group_name = var.resource_group_name
   }
   
   # Creates subnets for different workloads
   resource "azurerm_subnet" "subnets" {
     for_each             = var.subnet_configurations
     name                 = each.key
     resource_group_name  = var.resource_group_name
     virtual_network_name = azurerm_virtual_network.vnet.name
     address_prefixes     = [each.value.address_prefix]
   }
   ```

   **🛡️ nsg.tf - Network Security Groups:**
   ```hcl
   # Creates NSG with security rules
   resource "azurerm_network_security_group" "nsg" {
     name                = "${var.vnet_name}-nsg"
     location            = var.location
     resource_group_name = var.resource_group_name
   }
   
   # Associates NSG with subnets
   resource "azurerm_subnet_network_security_group_association" "nsg_association" {
     for_each                  = var.subnet_configurations
     subnet_id                 = azurerm_subnet.subnets[each.key].id
     network_security_group_id = azurerm_network_security_group.nsg.id
   }
   ```

   **⚖️ alb.tf - Application Load Balancer:**
   ```hcl
   # Creates Application Gateway for Containers
   resource "azurerm_application_load_balancer" "alb" {
     name                = "${var.vnet_name}-alb"
     location            = var.location
     resource_group_name = var.resource_group_name
   }
   ```

### **Step 2: Initialize Terraform** ⏱️ *3 minutes*

4. **🔧 Initialize Terraform Backend**
   ```bash
   terraform init
   ```
   **✅ Expected Output:**
   ```
   Initializing the backend...
   Successfully configured the backend "azurerm"!
   Initializing provider plugins...
   Terraform has been successfully initialized!
   ```

5. **📋 Validate Configuration**
   ```bash
   terraform validate
   ```
   **✅ Expected:** "Success! The configuration is valid."

### **Step 3: Plan and Deploy Infrastructure** ⏱️ *10 minutes*

6. **📊 Review Deployment Plan**
   ```bash
   terraform plan
   ```
   **⏱️ Planning Time:** 1-2 minutes
   **🔍 Review Output:** Look for resource creation count (typically 8-12 resources)

7. **🚀 Deploy Infrastructure**
   ```bash
   terraform apply
   ```
   **⏱️ Deployment Time:** 5-8 minutes
   **💡 Tip:** Type `yes` when prompted to confirm deployment

   **✅ Expected Completion Message:**
   ```
   Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
   ```

### **Step 4: Verify Deployment** ⏱️ *5 minutes*

8. **🌐 Check Azure Portal**
   - Navigate to [Azure Portal](https://portal.azure.com)
   - Go to your resource group
   - Verify these resources are created:
     - [ ] Virtual Network with correct address space
     - [ ] Subnets with proper CIDR blocks
     - [ ] Network Security Group with associations
     - [ ] Application Load Balancer

9. **📋 Verify Using Azure CLI**
   ```bash
   # List VNET details
   az network vnet list --resource-group <your-resource-group> --output table
   
   # Check subnets
   az network vnet subnet list --vnet-name <your-vnet-name> --resource-group <your-resource-group> --output table
   
   # Verify NSG associations
   az network nsg list --resource-group <your-resource-group> --output table
   ```

## ✅ **Validation Steps**

**🔍 Infrastructure Validation:**
- [ ] VNET created with correct address space (e.g., 10.0.0.0/16)
- [ ] Subnets properly segmented with non-overlapping CIDR blocks
- [ ] NSG created and associated with all subnets
- [ ] Application Load Balancer deployed successfully
- [ ] All resources in the specified region

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "🔍 Validating VNET deployment..."

# Check if VNET exists
VNET_NAME=$(terraform output -raw vnet_name 2>/dev/null || echo "devops-vnet")
RG_NAME=$(terraform output -raw resource_group_name 2>/dev/null || echo "devops-rg")

if az network vnet show --name $VNET_NAME --resource-group $RG_NAME &>/dev/null; then
    echo "✅ VNET exists"
    
    # Check subnet count
    SUBNET_COUNT=$(az network vnet subnet list --vnet-name $VNET_NAME --resource-group $RG_NAME --query "length(@)")
    echo "📊 Subnets created: $SUBNET_COUNT"
    
    # Check NSG associations
    NSG_COUNT=$(az network nsg list --resource-group $RG_NAME --query "length(@)")
    echo "🛡️ NSGs created: $NSG_COUNT"
    
    # Check ALB
    ALB_COUNT=$(az network application-gateway list --resource-group $RG_NAME --query "length(@)" 2>/dev/null || echo "0")
    echo "⚖️ Load Balancers: $ALB_COUNT"
    
    echo "✅ VNET validation complete!"
else
    echo "❌ VNET validation failed"
    exit 1
fi
```

**📊 Resource Inventory:**
- [ ] **Virtual Network** - Main network container
- [ ] **Subnets** - Network segments for different workloads
- [ ] **Network Security Groups** - Firewall rules for traffic control
- [ ] **ALB Subnet Association** - Load balancer network binding
- [ ] **ALB Frontend Configuration** - Load balancer front-end setup

## 🚨 **Troubleshooting Guide**

**❌ Common Terraform Issues:**
```bash
# Problem: Backend initialization fails
# Solution: Verify storage account and container exist
az storage account show --name <storage-account-name> --resource-group <rg-name>

# Problem: Address space conflicts
# Solution: Check for overlapping CIDR blocks
terraform plan | grep "address_prefixes"

# Problem: Permission errors
# Solution: Verify Azure CLI authentication and permissions
az account show
az role assignment list --assignee $(az account show --query user.name -o tsv)
```

**🔧 Network Configuration Issues:**
```bash
# Problem: Subnet creation fails
# Solution: Verify address space doesn't overlap
az network vnet show --name <vnet-name> --resource-group <rg-name> --query "addressSpace"

# Problem: NSG association fails
# Solution: Check if subnet is already associated with another NSG
az network vnet subnet show --name <subnet-name> --vnet-name <vnet-name> --resource-group <rg-name> --query "networkSecurityGroup"

# Problem: ALB deployment fails
# Solution: Verify subnet has sufficient address space
az network vnet subnet list --vnet-name <vnet-name> --resource-group <rg-name> --query "[].{Name:name,AddressPrefix:addressPrefix,AvailableIPs:availableIpAddressCount}"
```

**🧹 Cleanup Commands:**
```bash
# Remove specific resources if deployment fails partially
terraform destroy -target=azurerm_application_load_balancer.alb
terraform destroy -target=azurerm_network_security_group.nsg

# Complete cleanup
terraform destroy
```

## 💡 **Knowledge Check**

**🎯 Architecture Questions:**
1. What's the difference between a VNET and a subnet?
2. Why do we use Network Security Groups?
3. How does Application Gateway for Containers differ from traditional load balancers?
4. What are the benefits of subnet segmentation?

**📝 Answers:**
1. **VNET** is a logical network container; **subnets** are segments within the VNET for workload isolation
2. **NSGs** act as virtual firewalls, controlling inbound/outbound traffic at subnet and NIC levels
3. **AGfC** provides Layer 7 load balancing with advanced routing, SSL termination, and WAF capabilities
4. **Segmentation** improves security, simplifies management, and enables granular access control

**🔍 Technical Deep Dive:**
- **Address Planning:** How would you design subnets for a multi-tier application?
- **Security:** What NSG rules would you implement for a web application?
- **Scalability:** How does proper network design support future growth?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Azure VNET successfully created and validated
- [ ] Network Security Groups configured and associated
- [ ] Application Load Balancer deployed
- [ ] Understanding of Azure networking fundamentals
- [ ] Ready for Log Analytics workspace creation

**➡️ Continue to:** [Create Log Analytics](./3-Create-Log-Analytics.md)

---

## 📚 **Additional Resources**

- 🔗 [Azure VNET Documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)
- 🔗 [Network Security Groups Best Practices](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- 🔗 [Application Gateway for Containers](https://docs.microsoft.com/en-us/azure/application-gateway/)
- 🔗 [Azure Network Architecture](https://docs.microsoft.com/en-us/azure/architecture/networking/)

**🎯 Pro Tips:**
- Use **consistent naming conventions** for network resources
- Plan **address spaces** carefully to avoid conflicts with on-premises networks
- Implement **least privilege** principle in NSG rules
- Consider **Network Watcher** for monitoring and diagnostics
