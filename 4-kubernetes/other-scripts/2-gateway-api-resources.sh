RESOURCE_GROUP='rg-devopsthehardway'
ALB_RESOURCE_NAME='devopsthehardway-alb'
ALB_FRONTEND_NAME='alb-frontend'

RESOURCE_ID=$(az network alb show --resource-group $RESOURCE_GROUP --name $ALB_RESOURCE_NAME --query id -o tsv)

# Create a Gateway
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nebulanomi-gateway-01
  namespace: nebulanomi-namespace
  annotations:
    alb.networking.azure.io/alb-id: $RESOURCE_ID
spec:
  gatewayClassName: azure-alb-external
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: Same
  addresses:
  - type: alb.networking.azure.io/alb-frontend
    value: $ALB_FRONTEND_NAME
EOF

#Create HTTP Route
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: nebulanomi-traffic
  namespace: nebulanomi-namespace
spec:
  parentRefs:
  - name: nebulanomi-gateway-01
  rules:
  - backendRefs:
    - name: nebulanomi-service
      port: 80
EOF
