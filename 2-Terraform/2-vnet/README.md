# Azure Virtual Network (VNET) Module

Creates Azure Virtual Network with subnets, NSGs, and Application Load Balancer.

## Architecture

This module provisions:
- Virtual Network with custom address space
- Multiple subnets for different workloads
- Network Security Groups with proper associations
- Application Load Balancer for container workloads

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.28.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_load_balancer.alb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_load_balancer) | resource |
| [azurerm_application_load_balancer_frontend.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_load_balancer_frontend) | resource |
| [azurerm_application_load_balancer_subnet_association.alb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_load_balancer_subnet_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app_gwsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.app_gwsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_subnet_address_name"></a> [aks\_subnet\_address\_name](#input\_aks\_subnet\_address\_name) | AKS Subnet Address Name | `string` | n/a | yes |
| <a name="input_aks_subnet_address_prefix"></a> [aks\_subnet\_address\_prefix](#input\_aks\_subnet\_address\_prefix) | AKS Subnet Address Space | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure Location of resources | `string` | `"uksouth"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources | `string` | `"rg-acrdevopsthehardway"` | no |
| <a name="input_network_address_space"></a> [network\_address\_space](#input\_network\_address\_space) | Azure VNET Address Space | `string` | n/a | yes |
| <a name="input_subnet_address_name"></a> [subnet\_address\_name](#input\_subnet\_address\_name) | Subnet Address Name | `string` | n/a | yes |
| <a name="input_subnet_address_prefix"></a> [subnet\_address\_prefix](#input\_subnet\_address\_prefix) | Subnet Address Space | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the Virtual Network |
<!-- END_TF_DOCS -->