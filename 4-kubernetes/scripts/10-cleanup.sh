# Remove deployed resources if needed
kubectl delete -f deployment.yml

# Force removal if stuck
kubectl delete namespace thomasthorntoncloud --force --grace-period=0