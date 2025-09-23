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
| [azurerm_log_analytics_solution.Log_Analytics_Solution_ContainerInsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.Log_Analytics_WorkSpace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure Location of resources | `string` | `"uksouth"` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Log Analytics Workspace Name | `string` | `"law-devopsthehardway"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources | `string` | `"devopsthehardway"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Log Analytics Workspace Retention in days | `number` | `30` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Log Analytics Workspace SKU | `string` | `"PerGB2018"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of the Log Analytics Workspace |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | The name of the Log Analytics Workspace |
<!-- END_TF_DOCS -->