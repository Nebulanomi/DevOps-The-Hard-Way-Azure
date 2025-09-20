# List all nodes in the cluster
kubectl get nodes -o wide

# Display cluster information
kubectl cluster-info

# List system pods to verify cluster health
kubectl get pods --all-namespaces --output wide

# Test your permissions in the cluster
kubectl auth can-i get pods
kubectl auth can-i create deployments