# Create An AKS Cluster and IAM Roles

## 🎯 Purpose
In this lab, you'll create an Azure Kubernetes Service (AKS) cluster and set up the necessary Identity and Access Management (IAM) roles.

## 🛠️ Create the AKS Terraform Configuration

### Prerequisites
- [ ] Basic understanding of AKS and Azure IAM concepts
- [ ] Completed previous labs (VNET, Log Analytics)

### Steps 

1. **Review and Change Terraform .tfvars**
   - Open the [terraform.tfvars](https://github.com/thomast1906/DevOps-The-Hard-Way-Azure/tree/main/2-Terraform-AZURE-Services-Creation/4-aks/terraform.tfvars) file.
   - Ensure all values are accurate for your environment.

2. **Understand the Terraform Configuration**
   Review the [AKS Terraform configuration](https://github.com/thomast1906/DevOps-The-Hard-Way-Azure/tree/main/2-Terraform-AZURE-Services-Creation/4-aks). The configuration includes:

   **aks.tf:**
   - [ ] Creates AKS Cluster using `azurerm_kubernetes_cluster` with Kubernetes 1.33
   - [ ] Enables auto-scaling (min: 1, max: 5 nodes) for cost optimization
   - [ ] Configures availability zones for high availability
   - [ ] Sets up Azure RBAC and managed identity integration
   - [ ] Enables automatic patch upgrade channel
   - [ ] Configures network policies for enhanced security
   - [ ] Uses the `uksouth` region (can change if desired)

   **managed_identity.tf:**
   - [ ] Creates user assigned identity using `azurerm_user_assigned_identity`
   - [ ] Sets up federated identity credential using `azurerm_federated_identity_credential`

   **rbac.tf:**
   - [ ] Creates role assignments using `azurerm_role_assignment`
   - [ ] Defines role definitions using `azurerm_role_definition`

3. **Update Azure AD Group ID**
   - In `terraform.tfvars`, replace line 8 with the Azure AD Group ID you noted down [earlier](https://github.com/thomast1906/DevOps-The-Hard-Way-Azure/blob/main/1-Azure/2-Create-Azure-AD-Group-AKS-Admins.md).

4. **Create the AKS Cluster and IAM Roles**
   Run the following commands in your terminal:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 🔍 Verification

To ensure the resources were created successfully:
1. Log into the [Azure Portal](https://portal.azure.com)
2. Navigate to the Resource Group
3. Verify the presence of the AKS cluster
4. Verify the cluster properties and node pool configuration
5. Check the IAM settings to confirm the role assignments

Example screenshot of created resources:

![](images/4-aks.png)

## 🧠 Knowledge Check

After creating the AKS cluster and IAM roles, consider these questions:
1. Why is it important to use managed identities with AKS?
2. How does Azure RBAC enhance the security of your AKS cluster compared to basic RBAC?
3. What are the benefits of using federated identity credentials?
4. How does auto-scaling help with cost optimization and performance?
5. Why are availability zones important for production workloads?
6. What security benefits do network policies provide?

## 💡 Pro Tips

1. **Migration from Existing Clusters**: If upgrading from a previous version of this tutorial:
   - Kubernetes 1.33 requires a cluster upgrade procedure
   - Azure RBAC is now enabled by default for enhanced security
   - Auto-scaling may affect your cost structure but improves efficiency
   - Network policies may require reviewing existing pod communication patterns

2. **Security Best Practices**: 
   - Enable Azure Policy for Kubernetes to enforce organisational standards and assess compliance at scale
   - Regularly review and audit RBAC permissions
   - Monitor cluster logs through the integrated Log Analytics workspace

3. **Cost Optimization**:
   - Auto-scaling will automatically adjust node count based on demand
   - Use spot instances for non-critical workloads to reduce costs
   - Monitor resource usage through Azure Monitor