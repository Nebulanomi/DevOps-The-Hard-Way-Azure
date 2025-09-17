# Check cluster info
echo "Cluster Info:"
kubectl cluster-info
echo ""

# List nodes
echo "Cluster Nodes:"
kubectl get nodes -o wide
echo ""

# Check system pods
echo "Kube-system Pods:"
kubectl get pods -n kube-system
echo ""

# Verify RBAC is working
echo "RBAC Test - Can the default service account get pods?"
kubectl auth can-i get pods --as=system:serviceaccount:default:default
echo ""

# Check if network policies are supported
echo "Network Policies:"
kubectl get networkpolicies --all-namespaces
echo ""

# Verify CNI plugin
echo "CNI Plugin:"
kubectl get daemonset -n kube-system
echo ""