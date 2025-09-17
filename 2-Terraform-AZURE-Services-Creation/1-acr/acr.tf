data "azurerm_resource_group" "acr_resource_group" {
  name     = "rg-${var.name}"
}

resource "azurerm_container_registry" "acr" {
  name                = "azurecr${var.name}"
  resource_group_name = data.azurerm_resource_group.acr_resource_group.name
  location            = data.azurerm_resource_group.acr_resource_group.location
  sku                 = "Standard"
  admin_enabled       = false
  tags = var.tags
}