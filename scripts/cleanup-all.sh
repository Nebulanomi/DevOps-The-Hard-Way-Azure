#!/bin/bash

# DevOps The Hard Way - Azure - Cleanup Script
# This script destroys all resources created by the deployment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="${PROJECT_NAME:-devopsthehardwayjuly25}"
LOCATION="${LOCATION:-uksouth}"
RESOURCE_GROUP="${PROJECT_NAME}-rg"
TERRAFORM_RG="${PROJECT_NAME}-terraform-rg"

echo -e "${RED}🗑️  DevOps The Hard Way - Azure - CLEANUP${NC}"
echo -e "${RED}⚠️  WARNING: This will DELETE ALL resources created by this project!${NC}"
echo -e "${YELLOW}Project: ${PROJECT_NAME}${NC}"
echo -e "${YELLOW}Location: ${LOCATION}${NC}"
echo ""

# Confirmation prompt
read -p "Are you sure you want to delete all resources? Type 'DELETE' to confirm: " confirmation
if [ "$confirmation" != "DELETE" ]; then
    echo -e "${GREEN}✅ Cleanup cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${RED}🗑️  Starting cleanup process...${NC}"

# Function to print step headers
print_step() {
    echo -e "${YELLOW}📋 Step $1: $2${NC}"
    echo "----------------------------------------"
}

# Check if logged into Azure
if ! az account show &> /dev/null; then
    echo -e "${RED}❌ Not logged into Azure. Please login first.${NC}"
    az login
fi

print_step "1" "Cleaning up Kubernetes resources"
if kubectl config current-context &> /dev/null; then
    echo -e "${YELLOW}📋 Deleting application deployment...${NC}"
    kubectl delete -f ../4-kubernetes_manifest/deployment.yml --ignore-not-found=true
    
    echo -e "${YELLOW}📋 Deleting gateway resources...${NC}"
    kubectl delete gateway gateway-01 -n thomasthorntoncloud --ignore-not-found=true
    kubectl delete httproute traffic-thomasthorntoncloud -n thomasthorntoncloud --ignore-not-found=true
    
    echo -e "${YELLOW}📋 Deleting ALB Controller...${NC}"
    helm uninstall alb-controller -n azure-alb-system --ignore-not-found
    kubectl delete namespace azure-alb-system --ignore-not-found=true
    kubectl delete namespace thomasthorntoncloud --ignore-not-found=true
    
    echo -e "${GREEN}✅ Kubernetes resources cleaned up${NC}"
else
    echo -e "${YELLOW}⚠️  No Kubernetes context found, skipping Kubernetes cleanup${NC}"
fi
echo ""

print_step "2" "Destroying Terraform Infrastructure"

# Destroy AKS cluster first (longest running)
if [ -d "../2-Terraform-AZURE-Services-Creation/4-aks" ]; then
    echo -e "${YELLOW}📋 Destroying AKS cluster...${NC}"
    cd "../2-Terraform-AZURE-Services-Creation/4-aks"
    terraform destroy -auto-approve || echo -e "${YELLOW}⚠️  AKS destroy completed with warnings${NC}"
    cd ../../scripts
fi

# Destroy Log Analytics
if [ -d "../2-Terraform-AZURE-Services-Creation/3-log-analytics" ]; then
    echo -e "${YELLOW}📋 Destroying Log Analytics...${NC}"
    cd "../2-Terraform-AZURE-Services-Creation/3-log-analytics"
    terraform destroy -auto-approve || echo -e "${YELLOW}⚠️  Log Analytics destroy completed with warnings${NC}"
    cd ../../scripts
fi

# Destroy VNET
if [ -d "../2-Terraform-AZURE-Services-Creation/2-vnet" ]; then
    echo -e "${YELLOW}📋 Destroying Virtual Network...${NC}"
    cd "../2-Terraform-AZURE-Services-Creation/2-vnet"
    terraform destroy -auto-approve || echo -e "${YELLOW}⚠️  VNET destroy completed with warnings${NC}"
    cd ../../scripts
fi

# Destroy ACR
if [ -d "../2-Terraform-AZURE-Services-Creation/1-acr" ]; then
    echo -e "${YELLOW}📋 Destroying Container Registry...${NC}"
    cd "../2-Terraform-AZURE-Services-Creation/1-acr"
    terraform destroy -auto-approve || echo -e "${YELLOW}⚠️  ACR destroy completed with warnings${NC}"
    cd ../../scripts
fi

echo -e "${GREEN}✅ Terraform infrastructure destroyed${NC}"
echo ""

print_step "3" "Cleaning up Resource Groups"
echo -e "${YELLOW}📋 Deleting main resource group...${NC}"
az group delete --name "$RESOURCE_GROUP" --yes --no-wait 2>/dev/null || echo -e "${YELLOW}⚠️  Resource group may not exist${NC}"

echo -e "${YELLOW}📋 Deleting AKS node resource group...${NC}"
az group delete --name "${PROJECT_NAME}-node-rg" --yes --no-wait 2>/dev/null || echo -e "${YELLOW}⚠️  Node resource group may not exist${NC}"

echo ""

print_step "4" "Cleaning up Terraform State (Optional)"
echo -e "${YELLOW}⚠️  Do you want to delete the Terraform state storage as well?${NC}"
echo -e "${YELLOW}This will remove: ${TERRAFORM_RG} resource group and ${PROJECT_NAME}tfstate storage account${NC}"
read -p "Delete Terraform state storage? (y/N): " delete_state

if [[ "$delete_state" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📋 Deleting Terraform state storage...${NC}"
    az group delete --name "$TERRAFORM_RG" --yes --no-wait 2>/dev/null || echo -e "${YELLOW}⚠️  Terraform state resource group may not exist${NC}"
    echo -e "${GREEN}✅ Terraform state storage cleanup initiated${NC}"
else
    echo -e "${BLUE}ℹ️  Terraform state storage preserved${NC}"
fi

echo ""

print_step "5" "Cleaning up Local Docker Images (Optional)"
echo -e "${YELLOW}⚠️  Do you want to clean up local Docker images?${NC}"
read -p "Remove local Docker images for this project? (y/N): " clean_docker

if [[ "$clean_docker" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📋 Removing local Docker images...${NC}"
    docker rmi "${PROJECT_NAME}azurecr.azurecr.io/thomasthorntoncloud:v2" 2>/dev/null || echo -e "${YELLOW}⚠️  Image may not exist locally${NC}"
    docker rmi "${PROJECT_NAME}azurecr.azurecr.io/thomasthorntoncloud:v1" 2>/dev/null || echo -e "${YELLOW}⚠️  Image may not exist locally${NC}"
    echo -e "${GREEN}✅ Local Docker images cleaned up${NC}"
else
    echo -e "${BLUE}ℹ️  Local Docker images preserved${NC}"
fi

echo ""

print_step "6" "Cleanup Summary"
echo -e "${GREEN}✅ Cleanup process completed!${NC}"
echo ""
echo -e "${BLUE}📋 What was cleaned up:${NC}"
echo "• Kubernetes deployments, services, and namespaces"
echo "• ALB Controller and Gateway resources"
echo "• AKS cluster and all associated resources"
echo "• Virtual Network and subnets"
echo "• Log Analytics workspace"
echo "• Azure Container Registry"
echo "• Resource groups (deletion in progress)"
if [[ "$delete_state" =~ ^[Yy]$ ]]; then
    echo "• Terraform state storage (deletion in progress)"
fi
if [[ "$clean_docker" =~ ^[Yy]$ ]]; then
    echo "• Local Docker images"
fi

echo ""
echo -e "${BLUE}📋 Notes:${NC}"
echo "• Resource group deletions are running in the background"
echo "• It may take 10-15 minutes for all resources to be fully removed"
echo "• Check Azure Portal to confirm all resources are deleted"
echo "• Azure AD groups and service principals may need manual cleanup"

echo ""
echo -e "${GREEN}🎉 DevOps The Hard Way - Azure cleanup completed!${NC}"
