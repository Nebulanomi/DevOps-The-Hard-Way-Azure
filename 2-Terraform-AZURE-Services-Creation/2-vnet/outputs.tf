output "vnet_name" {
    value = azurerm_virtual_network.virtual_network.name
    description = "The name of the Virtual Network"
}

output "resource_group_name" {
    value = data.azurerm_resource_group.resource_group.name
    description = "The name of the Resource Group"
}
