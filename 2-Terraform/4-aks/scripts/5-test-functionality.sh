# Test auto-scaling (optional)
echo "Testing Auto-scaling by creating multiple pods..."
kubectl create deployment test-scale --image=nginx --replicas=10
kubectl get pods -w
echo ""

# Test Azure integration
echo "Testing Azure integration by creating a secret..."
kubectl create secret generic test-secret --from-literal=key=value
kubectl get secrets
echo ""

# Clean up test resources
echo "Cleaning up test resources..."
kubectl delete deployment test-scale
kubectl delete secret test-secret
echo ""