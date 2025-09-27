data "azurerm_resource_group" "resource_group" {
  name     = "rg-tfstate-${var.name}"
}

data "azurerm_subnet" "akssubnet" {
  name                 = "aks"
  virtual_network_name = "${var.name}-vnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = "appgw"
  virtual_network_name = "${var.name}-vnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
}

data "azurerm_log_analytics_workspace" "workspace" {
  name                = "law-${var.name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_container_registry" "acr" {
  name                = "azuremetyisacr${var.name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_resource_group" "node_resource_group" {
  name = azurerm_kubernetes_cluster.k8s.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}
