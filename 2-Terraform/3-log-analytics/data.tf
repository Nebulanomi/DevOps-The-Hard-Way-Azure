data "azurerm_resource_group" "resource_group" {
  name     = "rg-tfstate-${var.name}"
}