# 📊 Create an Azure Log Analytics Workspace

> **Difficulty Level:** 🟢 **Beginner** | **Estimated Time:** ⏱️ **15-20 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Deploy Log Analytics Workspace** for centralized logging
- [ ] **Enable Container Insights** for AKS monitoring
- [ ] **Configure monitoring solutions** for comprehensive observability
- [ ] **Understand logging architecture** and data retention policies
- [ ] **Validate workspace deployment** through Azure Portal

## 📋 **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of Azure monitoring concepts
- [ ] Familiarity with logging and observability principles
- [ ] Terraform configuration fundamentals

**🔧 Required Tools:**
- [ ] Terraform CLI installed and configured
- [ ] Azure CLI with active subscription
- [ ] Access to Azure subscription with Contributor permissions
- [ ] Completed: [Create Azure VNET](./2-Create-VNET.md)

**🏗️ Infrastructure Dependencies:**
- [ ] Azure Storage Account for Terraform state
- [ ] Resource group for Log Analytics resources
- [ ] VNET infrastructure (for future AKS integration)

## 🚀 **Step-by-Step Implementation**

### **Step 1: Review Configuration and Setup** ⏱️ *5 minutes*

1. **📂 Navigate to Log Analytics Directory**
   ```bash
   cd 2-Terraform-AZURE-Services-Creation/3-log-analytics
   ```

2. **📋 Review terraform.tfvars Configuration**
   ```bash
   cat terraform.tfvars
   ```
   **🔍 Key Variables to Verify:**
   - [ ] `location` - Azure region (should match VNET)
   - [ ] `resource_group_name` - Target resource group
   - [ ] `log_analytics_workspace_name` - Unique workspace name
   - [ ] `sku` - Pricing tier (typically "PerGB2018")
   - [ ] `retention_in_days` - Data retention period (30-730 days)

3. **🏗️ Understand Infrastructure Components**

   **📄 la.tf - Log Analytics Workspace:**
   ```hcl
   # Creates Log Analytics Workspace
   resource "azurerm_log_analytics_workspace" "law" {
     name                = var.log_analytics_workspace_name
     location            = var.location
     resource_group_name = var.resource_group_name
     sku                 = var.sku
     retention_in_days   = var.retention_in_days
     
     tags = var.tags
   }
   
   # Enables Container Insights solution
   resource "azurerm_log_analytics_solution" "container_insights" {
     solution_name         = "ContainerInsights"
     location              = var.location
     resource_group_name   = var.resource_group_name
     workspace_resource_id = azurerm_log_analytics_workspace.law.id
     workspace_name        = azurerm_log_analytics_workspace.law.name
     
     plan {
       publisher = "Microsoft"
       product   = "OMSGallery/ContainerInsights"
     }
   }
   ```

   **🎯 Configuration Highlights:**
   - [ ] **PerGB2018 SKU** - Pay-per-GB ingestion model
   - [ ] **Flexible retention** - Configurable data retention (30-730 days)
   - [ ] **Container Insights** - Specialized monitoring for Kubernetes
   - [ ] **Resource tagging** - Consistent labeling for management

### **Step 2: Deploy Log Analytics Infrastructure** ⏱️ *8 minutes*

4. **🔧 Initialize Terraform Backend**
   ```bash
   terraform init
   ```
   **✅ Expected Output:**
   ```
   Initializing the backend...
   Successfully configured the backend "azurerm"!
   Terraform has been successfully initialized!
   ```

5. **📋 Validate Configuration**
   ```bash
   terraform validate
   ```
   **✅ Expected:** "Success! The configuration is valid."

6. **📊 Review Deployment Plan**
   ```bash
   terraform plan
   ```
   **⏱️ Planning Time:** 30-60 seconds
   **🔍 Review Output:** Look for 2 resources to be created:
   - `azurerm_log_analytics_workspace.law`
   - `azurerm_log_analytics_solution.container_insights`

7. **🚀 Deploy Infrastructure**
   ```bash
   terraform apply
   ```
   **⏱️ Deployment Time:** 3-5 minutes
   **� Tip:** Type `yes` when prompted to confirm deployment

   **✅ Expected Completion Message:**
   ```
   Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
   
   Outputs:
   workspace_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/..."
   workspace_key = "<sensitive>"
   ```

### **Step 3: Verify and Test Deployment** ⏱️ *5 minutes*

8. **🌐 Check Azure Portal**
   - Navigate to [Azure Portal](https://portal.azure.com)
   - Go to your resource group
   - Verify these resources are created:
     - [ ] Log Analytics workspace with correct name
     - [ ] Container Insights solution enabled
     - [ ] Workspace in "Running" state

9. **📋 Verify Using Azure CLI**
   ```bash
   # List Log Analytics workspaces
   az monitor log-analytics workspace list --resource-group <your-resource-group> --output table
   
   # Check workspace details
   az monitor log-analytics workspace show --workspace-name <workspace-name> --resource-group <your-resource-group>
   
   # Verify Container Insights solution
   az monitor log-analytics solution list --resource-group <your-resource-group> --output table
   ```

10. **🔍 Test Workspace Connectivity**
    ```bash
    # Get workspace details from Terraform output
    WORKSPACE_ID=$(terraform output -raw workspace_id)
    echo "Workspace ID: $WORKSPACE_ID"
    
    # Test workspace is accessible
    az monitor log-analytics workspace show --ids $WORKSPACE_ID --query "{Name:name,State:provisioningState,Sku:sku.name}"
    ```

## ✅ **Validation Steps**

**🔍 Infrastructure Validation:**
- [ ] Log Analytics workspace created with correct configuration
- [ ] Container Insights solution deployed and active
- [ ] Workspace in "Succeeded" provisioning state
- [ ] Correct SKU and retention settings applied
- [ ] Resource tags properly applied

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "📊 Validating Log Analytics deployment..."

# Get workspace details from Terraform
WORKSPACE_NAME=$(terraform output -raw workspace_name 2>/dev/null || echo "devops-law")
RG_NAME=$(terraform output -raw resource_group_name 2>/dev/null || echo "devops-rg")

# Check if workspace exists and is running
WORKSPACE_STATE=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "provisioningState" -o tsv 2>/dev/null)

if [ "$WORKSPACE_STATE" = "Succeeded" ]; then
    echo "✅ Log Analytics workspace is running"
    
    # Check retention settings
    RETENTION=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "retentionInDays" -o tsv)
    echo "📅 Data retention: $RETENTION days"
    
    # Check SKU
    SKU=$(az monitor log-analytics workspace show --workspace-name $WORKSPACE_NAME --resource-group $RG_NAME --query "sku.name" -o tsv)
    echo "💰 Pricing tier: $SKU"
    
    # Check Container Insights solution
    SOLUTION_COUNT=$(az monitor log-analytics solution list --resource-group $RG_NAME --query "length(@)")
    echo "🔧 Solutions installed: $SOLUTION_COUNT"
    
    echo "✅ Log Analytics validation complete!"
else
    echo "❌ Log Analytics validation failed - State: $WORKSPACE_STATE"
    exit 1
fi
```

**📊 Monitoring Readiness:**
- [ ] **Data Collection** - Workspace ready to receive logs
- [ ] **Query Interface** - KQL queries can be executed
- [ ] **Container Insights** - AKS monitoring solution active
- [ ] **Alerting Capability** - Ready for alert rule creation
- [ ] **Dashboard Integration** - Compatible with Azure dashboards

## 🚨 **Troubleshooting Guide**

**❌ Common Deployment Issues:**
```bash
# Problem: Workspace name already exists globally
# Solution: Log Analytics workspace names must be globally unique
terraform plan | grep "already exists"

# Problem: Insufficient permissions
# Solution: Verify contributor access to subscription
az role assignment list --assignee $(az account show --query user.name -o tsv) --query "[?roleDefinitionName=='Contributor']"

# Problem: Solution deployment fails
# Solution: Check if ContainerInsights is supported in region
az provider show --namespace Microsoft.OperationsManagement --query "resourceTypes[?resourceType=='solutions'].locations"
```

**🔧 Configuration Issues:**
```bash
# Problem: Retention period invalid
# Solution: Verify retention is between 30-730 days
terraform plan | grep "retention_in_days"

# Problem: SKU not supported
# Solution: Check available SKUs for your region
az monitor log-analytics workspace list-usages --workspace-name <workspace-name> --resource-group <rg-name>

# Problem: Resource group not found
# Solution: Verify resource group exists
az group show --name <resource-group-name>
```

**🧹 Cleanup Commands:**
```bash
# Remove specific solution if deployment fails
terraform destroy -target=azurerm_log_analytics_solution.container_insights

# Remove workspace
terraform destroy -target=azurerm_log_analytics_workspace.law

# Complete cleanup
terraform destroy
```

## 💡 **Knowledge Check**

**🎯 Monitoring Questions:**
1. What's the difference between Log Analytics and Application Insights?
2. Why is Container Insights specifically important for AKS?
3. How does data retention impact costs in Log Analytics?
4. What types of queries can you run in Log Analytics?

**📝 Answers:**
1. **Log Analytics** provides infrastructure and application logs; **Application Insights** focuses on application performance monitoring
2. **Container Insights** provides Kubernetes-specific metrics, logs, and visualizations for pod, node, and cluster health
3. **Longer retention** increases storage costs; typical retention is 30-90 days for cost optimization
4. **KQL queries** can analyze logs, metrics, performance data, and create custom alerts and dashboards

**🔍 Technical Deep Dive:**
- **Query Language:** How would you write a KQL query to find failed pods?
- **Alerting:** What metrics would you monitor for AKS cluster health?
- **Cost Management:** How can you optimize Log Analytics costs?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Log Analytics workspace successfully deployed
- [ ] Container Insights solution enabled
- [ ] Monitoring infrastructure ready for AKS
- [ ] Understanding of Azure monitoring concepts
- [ ] Ready for AKS cluster creation

**➡️ Continue to:** [Create AKS Cluster & IAM Roles](./4-Create-AKS-Cluster-IAM-Roles.md)

---

## 📚 **Additional Resources**

- 🔗 [Azure Log Analytics Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/)
- 🔗 [Container Insights Overview](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- 🔗 [KQL Query Language](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- 🔗 [Log Analytics Pricing](https://azure.microsoft.com/en-us/pricing/details/monitor/)

**🎯 Pro Tips:**
- Set up **data retention policies** based on compliance requirements
- Use **workspace-based pricing** for predictable costs
- Create **custom dashboards** for real-time monitoring
- Implement **automated alerts** for proactive issue detection
