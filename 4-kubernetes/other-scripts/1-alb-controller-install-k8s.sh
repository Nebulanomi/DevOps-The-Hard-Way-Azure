#!/bin/bash

RESOURCE_GROUP="rg-devopsthehardway"
helm_resource_namespace="azure-alb-system"
ALB_CONTROLLER_VERSION="1.7.9"

#create namespace
kubectl create namespace $helm_resource_namespace

# Install ALB controller and assign it to the managed identity
helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller \
    --namespace $helm_resource_namespace \
    --version $ALB_CONTROLLER_VERSION \
    --set albController.namespace=$helm_resource_namespace \
    --set albController.podIdentity.clientID=$(az identity show -g $RESOURCE_GROUP -n azure-alb-identity --query clientId -o tsv) \
    --skip-schema-validation