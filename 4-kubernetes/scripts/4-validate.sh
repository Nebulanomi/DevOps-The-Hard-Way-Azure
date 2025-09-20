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