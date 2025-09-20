#/bin/bash

# Deploy the Nebulanomi app
cd ..
kubectl create -f deployment.yml

# Install ALB Controller:
./other-scripts/1-alb-controller-install-k8s.sh

# Install Gateway API resources:
./other-scripts/2-gateway-api-resources.sh

# Verify Deployment
kubectl get deployments -n nebulanomi-namespace
kubectl get pods -n nebulanomi-namespace
kubectl get services -n nebulanomi-namespace
kubectl get gateway -n nebulanomi-namespace
kubectl get httproute -n nebulanomi-namespace

# Get the FQDN of the ALB and access the application
fqdn=$(kubectl get gateway nebulanomi-gateway-01 -n nebulanomi-namespace -o jsonpath='{.status.addresses[0].value}')
echo "http://$fqdn"