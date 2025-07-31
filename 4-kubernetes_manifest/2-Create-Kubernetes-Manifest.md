# 📄 Create The Kubernetes Manifest

> **Estimated Time:** ⏱️ **20-25 minutes**

## 🎯 **Learning Objectives**

By the end of this tutorial, you will:
- [ ] **Understand Kubernetes manifest structure** and components
- [ ] **Configure deployment specifications** with proper resource management
- [ ] **Set up service definitions** for application exposure
- [ ] **Implement health checks** for application reliability
- [ ] **Customize manifest** for your specific ACR image

## � **Prerequisites**

**✅ Required Knowledge:**
- [ ] Basic understanding of Kubernetes concepts (pods, deployments, services)
- [ ] Familiarity with YAML syntax and structure
- [ ] Container registry concepts (ACR, image tagging)

**🔧 Required Tools:**
- [ ] Text editor or IDE for YAML editing
- [ ] Access to Azure Container Registry (ACR)
- [ ] kubectl CLI configured for AKS cluster
- [ ] Completed: [Create Docker Image](../3-Docker/1-Create-Docker-Image.md)
- [ ] Completed: [Push Image to ACR](../3-Docker/2-Push%20Image%20To%20ACR.md)

**🏗️ Infrastructure Dependencies:**
- [ ] AKS cluster connected and accessible
- [ ] Docker image built and pushed to ACR
- [ ] ACR integration with AKS cluster configured

## 🚀 **Step-by-Step Implementation**

### **Step 1: Understand Manifest Architecture** ⏱️ *8 minutes*

1. **📂 Navigate to Kubernetes Manifest Directory**
   ```bash
   cd 4-kubernetes_manifest
   ls -la
   ```
   **✅ Expected Files:**
   - `deployment.yml` - Main Kubernetes manifest
   - `1-Connect-To-AKS.md` - Connection guide
   - `2-Create-Kubernetes-Manifest.md` - This tutorial

2. **📋 Review Manifest Structure**
   ```bash
   cat deployment.yml
   ```

3. **🏗️ Understand Manifest Components**

   **📄 Namespace Definition:**
   ```yaml
   apiVersion: v1
   kind: Namespace
   metadata:
     name: thomasthorntoncloud
   ---
   ```
   - **Purpose:** Isolates resources and provides organization
   - **Benefits:** Resource separation, RBAC scoping, easier management

   **🚀 Deployment Configuration:**
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: thomasthorntoncloud-deployment
     namespace: thomasthorntoncloud
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: thomasthorntoncloud
     template:
       metadata:
         labels:
           app: thomasthorntoncloud
       spec:
         containers:
         - name: thomasthorntoncloud
           image: <YOUR_ACR_URL>/thomasthorntoncloud:latest
           ports:
           - containerPort: 5000
   ```

   **🌐 Service Definition:**
   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: thomasthorntoncloud-service
     namespace: thomasthorntoncloud
   spec:
     selector:
       app: thomasthorntoncloud
     ports:
     - protocol: TCP
       port: 80
       targetPort: 5000
     type: LoadBalancer
   ```

### **Step 2: Customize Manifest Configuration** ⏱️ *8 minutes*

4. **🔍 Get Your ACR URL**
   ```bash
   # List your container registries
   az acr list --output table
   
   # Get specific ACR login server
   az acr show --name <your-acr-name> --query "loginServer" --output tsv
   ```
   **✅ Expected Format:** `<registry-name>.azurecr.io`

5. **📝 Update Image URL in Manifest**
   ```bash
   # Open deployment.yml in your preferred editor
   nano deployment.yml
   # or
   code deployment.yml
   ```
   
   **🎯 Find and Replace:**
   ```yaml
   # Find this line (around line 24):
   image: <YOUR_ACR_URL>/thomasthorntoncloud:latest
   
   # Replace with your actual ACR URL:
   image: yourregistryname.azurecr.io/thomasthorntoncloud:latest
   ```

6. **⚙️ Review Enhanced Configuration Features**

   **🏥 Health Checks (Liveness & Readiness Probes):**
   ```yaml
   livenessProbe:
     httpGet:
       path: /
       port: 5000
     initialDelaySeconds: 30
     periodSeconds: 10
   readinessProbe:
     httpGet:
       path: /
       port: 5000
     initialDelaySeconds: 5
     periodSeconds: 5
   ```

   **📊 Resource Management:**
   ```yaml
   resources:
     requests:
       memory: "128Mi"
       cpu: "250m"
     limits:
       memory: "256Mi"
       cpu: "500m"
   ```

   **🔒 Security Context:**
   ```yaml
   securityContext:
     runAsNonRoot: true
     runAsUser: 1000
     allowPrivilegeEscalation: false
   ```

### **Step 3: Validate Manifest Configuration** ⏱️ *6 minutes*

7. **🔍 Syntax Validation**
   ```bash
   # Validate YAML syntax using kubectl
   kubectl apply --dry-run=client -f deployment.yml
   ```
   **✅ Expected:** No syntax errors reported

8. **📋 Verify Image Accessibility**
   ```bash
   # Test if you can pull the image from ACR
   az acr repository show --name <your-acr-name> --image thomasthorntoncloud:latest
   ```
   **✅ Expected:** Image details and manifest information

9. **🔧 Check AKS Integration with ACR**
   ```bash
   # Verify AKS can pull from ACR
   az aks check-acr --name <aks-cluster-name> --resource-group <resource-group> --acr <acr-name>
   ```
   **✅ Expected:** "ACR integration is working correctly"

## ✅ **Validation Steps**

**🔍 Manifest Validation:**
- [ ] YAML syntax is valid (no indentation errors)
- [ ] Image URL updated with correct ACR reference
- [ ] Resource requests and limits properly configured
- [ ] Health checks configured for application reliability
- [ ] Service type and port mapping correct

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "📄 Validating Kubernetes manifest..."

# Check if manifest file exists
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
```

**📊 Configuration Checklist:**
- [ ] **Namespace** - Creates isolated environment
- [ ] **Deployment** - Manages pod replicas and updates
- [ ] **Service** - Exposes application with LoadBalancer
- [ ] **Health Checks** - Ensures application reliability
- [ ] **Resource Limits** - Prevents resource exhaustion
- [ ] **Security Context** - Runs with minimal privileges

## 🚨 **Troubleshooting Guide**

**❌ Common Manifest Issues:**
```bash
# Problem: YAML indentation errors
# Solution: Use proper YAML validator
kubectl apply --dry-run=client -f deployment.yml

# Problem: Image pull errors
# Solution: Verify ACR integration and image existence
az acr repository list --name <acr-name>
az aks check-acr --name <aks-name> --resource-group <rg> --acr <acr-name>

# Problem: Resource allocation issues
# Solution: Adjust resource requests/limits
kubectl describe nodes  # Check available resources
```

**🔧 Configuration Issues:**
```bash
# Problem: Service not accessible
# Solution: Check service type and port configuration
kubectl get services -n thomasthorntoncloud
kubectl describe service thomasthorntoncloud-service -n thomasthorntoncloud

# Problem: Health check failures
# Solution: Verify application responds on correct path/port
curl http://localhost:5000/  # Test locally first

# Problem: Namespace issues
# Solution: Ensure namespace is created before resources
kubectl get namespaces
kubectl create namespace thomasthorntoncloud --dry-run=client -o yaml
```

**🧹 Manifest Cleanup:**
```bash
# Remove deployed resources if needed
kubectl delete -f deployment.yml

# Force removal if stuck
kubectl delete namespace thomasthorntoncloud --force --grace-period=0
```

## 💡 **Knowledge Check**

**🎯 Kubernetes Fundamentals:**
1. What's the difference between a Deployment and a Pod?
2. Why do we use Namespaces in Kubernetes?
3. How do liveness and readiness probes differ?
4. What's the purpose of resource requests vs limits?

**📝 Answers:**
1. **Deployment** manages multiple pods with rollout capabilities; **Pod** is a single application instance
2. **Namespaces** provide resource isolation, RBAC scoping, and organizational boundaries
3. **Liveness** restarts unhealthy containers; **Readiness** controls traffic routing to ready containers
4. **Requests** guarantee minimum resources; **Limits** prevent resource overconsumption

**🔍 Advanced Concepts:**
- **Rolling Updates:** How would you update the application without downtime?
- **Scaling:** How could you automatically scale based on CPU usage?
- **Security:** What additional security measures could be implemented?

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Kubernetes manifest properly configured and validated
- [ ] ACR image URL updated in deployment
- [ ] Health checks and resource limits configured
- [ ] Understanding of Kubernetes manifest structure
- [ ] Ready to deploy application to AKS

**➡️ Continue to:** [Deploy Thomasthorntoncloud App](./3-Deploy-Thomasthorntoncloud-App.md)

---

## 📚 **Additional Resources**

- 🔗 [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- 🔗 [Services and Load Balancing](https://kubernetes.io/docs/concepts/services-networking/service/)
- � [Configure Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- 🔗 [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

**🎯 Pro Tips:**
- Use **kubectl explain** to understand resource specifications
- Implement **horizontal pod autoscaling** for production workloads
- Consider **Helm charts** for complex application packaging
- Set up **monitoring and alerting** for deployed applications


