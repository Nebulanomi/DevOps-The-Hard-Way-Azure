# 🔗 Connecting To Azure Kubernetes Service (AKS)

> **Difficulty Level:** 🟢 **Beginner** | **Estimated Time:** ⏱️ **10-15 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Authenticate to AKS cluster** using Azure CLI
- [ ] **Configure kubectl context** for cluster management
- [ ] **Verify cluster connectivity** and node status
- [ ] **Understand kubeconfig** file structure and management
- [ ] **Execute basic kubectl commands** for cluster exploration

## 📋 **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of Kubernetes concepts (clusters, nodes, pods)
- [ ] Familiarity with command-line interfaces
- [ ] Azure CLI authentication basics

**🔧 Required Tools:**
- [ ] Azure CLI installed and authenticated
- [ ] kubectl CLI installed (latest version recommended)
- [ ] Access to Azure subscription with AKS Reader permissions
- [ ] Completed: [Create AKS Cluster & IAM Roles](../2-Terraform-AZURE-Services-Creation/4-Create-AKS-Cluster-IAM-Roles.md)

**🏗️ Infrastructure Dependencies:**
- [ ] AKS cluster successfully deployed and running
- [ ] Resource group containing AKS cluster
- [ ] Proper RBAC permissions configured

## 🚀 **Step-by-Step Implementation**

### **Step 1: Verify Prerequisites** ⏱️ *3 minutes*

1. **🔍 Check Azure CLI Authentication**
   ```bash
   # Verify you're logged into Azure
   az account show --output table
   ```
   **✅ Expected:** Your subscription details displayed

2. **🔧 Verify kubectl Installation**
   ```bash
   # Check kubectl version
   kubectl version --client --output=yaml
   ```
   **✅ Expected:** Client version information (server version will show after connection)

3. **📋 List Available AKS Clusters**
   ```bash
   # List AKS clusters in your subscription
   az aks list --output table
   ```
   **✅ Expected:** Your AKS cluster listed with "Succeeded" provisioning state

### **Step 2: Connect to AKS Cluster** ⏱️ *5 minutes*

4. **🔐 Get AKS Credentials**
   ```bash
   # Replace with your actual resource group and cluster names
   az aks get-credentials --resource-group devopsthehardway-rg --name devopsthehardwayaks --overwrite-existing
   ```
   
   **⚙️ Command Breakdown:**
   - `--resource-group` - Azure resource group containing your AKS cluster
   - `--name` - Name of your AKS cluster
   - `--overwrite-existing` - Replaces existing cluster entry in kubeconfig

   **✅ Expected Output:**
   ```
   Merged "devopsthehardwayaks" as current context in /Users/[username]/.kube/config
   ```

5. **📂 Verify Kubeconfig Update**
   ```bash
   # Check current kubectl context
   kubectl config current-context
   ```
   **✅ Expected:** Your AKS cluster name displayed

6. **📊 View Kubeconfig Details**
   ```bash
   # Display current context configuration
   kubectl config view --minify
   ```
   **✅ Expected:** Context details with cluster endpoint and user information

### **Step 3: Verify Cluster Connectivity** ⏱️ *5 minutes*

7. **🖥️ Check Cluster Nodes**
   ```bash
   # List all nodes in the cluster
   kubectl get nodes -o wide
   ```
   **✅ Expected Output:**
   ```
   NAME                       STATUS   ROLES   AGE   VERSION
   aks-default-12345678-0     Ready    agent   1h    v1.33.x
   aks-default-12345678-1     Ready    agent   1h    v1.33.x
   ```

8. **🔍 Get Cluster Information**
   ```bash
   # Display cluster information
   kubectl cluster-info
   ```
   **✅ Expected:** Kubernetes control plane and CoreDNS URLs

9. **📋 Check System Pods**
   ```bash
   # List system pods to verify cluster health
   kubectl get pods --all-namespaces --output wide
   ```
   **✅ Expected:** All system pods in "Running" status

10. **⚙️ Verify RBAC Permissions**
    ```bash
    # Test your permissions in the cluster
    kubectl auth can-i get pods
    kubectl auth can-i create deployments
    ```
    **✅ Expected:** "yes" for basic operations you have permissions for

## ✅ **Validation Steps**

**🔍 Connection Validation:**
- [ ] kubectl commands execute without authentication errors
- [ ] Cluster nodes are visible and in "Ready" state
- [ ] System pods are running successfully
- [ ] kubeconfig context is properly set

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "🔗 Validating AKS connection..."

# Check if kubectl can connect
if kubectl get nodes &>/dev/null; then
    echo "✅ kubectl can connect to cluster"
    
    # Check node status
    NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
    READY_NODES=$(kubectl get nodes --no-headers | grep -c "Ready")
    echo "📊 Nodes: $READY_NODES/$NODE_COUNT Ready"
    
    # Check system pods
    SYSTEM_PODS=$(kubectl get pods -n kube-system --no-headers | wc -l)
    RUNNING_PODS=$(kubectl get pods -n kube-system --no-headers | grep -c "Running")
    echo "🏃 System Pods: $RUNNING_PODS/$SYSTEM_PODS Running"
    
    # Check current context
    CURRENT_CONTEXT=$(kubectl config current-context)
    echo "🎯 Current Context: $CURRENT_CONTEXT"
    
    echo "✅ AKS connection validation complete!"
else
    echo "❌ Failed to connect to AKS cluster"
    exit 1
fi
```

**📊 Connectivity Checklist:**
- [ ] **Authentication** - Azure CLI session active
- [ ] **Authorization** - Proper RBAC permissions
- [ ] **Network** - Cluster API server accessible
- [ ] **Configuration** - kubeconfig properly merged
- [ ] **Functionality** - Basic kubectl operations working

## 🚨 **Troubleshooting Guide**

**❌ Common Connection Issues:**
```bash
# Problem: "Unable to connect to the server"
# Solution: Check Azure CLI authentication and network connectivity
az account show
az aks show --resource-group <rg-name> --name <cluster-name> --query "fqdn"

# Problem: "Forbidden" or "Unauthorized" errors
# Solution: Verify RBAC permissions
az aks show --resource-group <rg-name> --name <cluster-name> --query "aadProfile"
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Problem: "No current context" error
# Solution: Reconfigure kubectl context
kubectl config get-contexts
az aks get-credentials --resource-group <rg-name> --name <cluster-name> --overwrite-existing
```

**🔧 Configuration Issues:**
```bash
# Problem: Wrong cluster context
# Solution: Switch to correct context
kubectl config get-contexts
kubectl config use-context <context-name>

# Problem: Kubeconfig corruption
# Solution: Regenerate kubeconfig
mv ~/.kube/config ~/.kube/config.backup
az aks get-credentials --resource-group <rg-name> --name <cluster-name>

# Problem: kubectl not found
# Solution: Install or update kubectl
az aks install-cli  # Azure CLI method
# or use package manager (brew, apt, etc.)
```

**🌐 Network Troubleshooting:**
```bash
# Test cluster API server connectivity
CLUSTER_FQDN=$(az aks show --resource-group <rg-name> --name <cluster-name> --query "fqdn" -o tsv)
nslookup $CLUSTER_FQDN
curl -k https://$CLUSTER_FQDN/version

# Check firewall/proxy settings
kubectl get nodes -v=6  # Verbose output for debugging
```

## 💡 **Knowledge Check**

**🎯 Kubernetes Fundamentals:**
1. What is a kubeconfig file and where is it stored?
2. What does the `az aks get-credentials` command actually do?
3. How can you manage multiple Kubernetes clusters?
4. What's the difference between authentication and authorization in Kubernetes?

**📝 Answers:**
1. **kubeconfig** is stored at `~/.kube/config` and contains cluster connection details, user credentials, and contexts
2. **Downloads cluster certificates** and creates/updates kubeconfig entries for the specified AKS cluster
3. **Multiple contexts** in kubeconfig allow switching between clusters using `kubectl config use-context`
4. **Authentication** verifies identity; **authorization** (RBAC) determines what actions are permitted

**🔍 Advanced Concepts:**
- **Context Management:** How would you organize kubeconfig for multiple environments?
- **Security:** What are the implications of the `--overwrite-existing` flag?
- **Automation:** How could you script cluster connections for CI/CD pipelines?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Successfully connected to AKS cluster
- [ ] kubectl configured and operational
- [ ] Cluster health verified
- [ ] Understanding of kubeconfig management
- [ ] Ready to deploy Kubernetes manifests

**➡️ Continue to:** [Create Kubernetes Manifest](./2-Create-Kubernetes-Manifest.md)

---

## 📚 **Additional Resources**

- 🔗 [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- 🔗 [Organizing Cluster Access](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
- 🔗 [AKS Authentication](https://docs.microsoft.com/en-us/azure/aks/concepts-identity)
- 🔗 [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

**🎯 Pro Tips:**
- Use **multiple contexts** for different environments (dev, staging, prod)
- Set up **kubectl aliases** for common commands (`k` for `kubectl`)
- Consider **kubectx/kubens** tools for easier context switching
- Always verify your **current context** before making changes
