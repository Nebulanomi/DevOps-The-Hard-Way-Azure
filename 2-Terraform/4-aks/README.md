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
| [azurerm_federated_identity_credential.alb_federated_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_kubernetes_cluster.k8s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_role_assignment.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.node_infrastructure_update_scale_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.alb_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_count"></a> [agent\_count](#input\_agent\_count) | n/a | `any` | n/a | yes |
| <a name="input_aks_admins_group_object_id"></a> [aks\_admins\_group\_object\_id](#input\_aks\_admins\_group\_object\_id) | n/a | `any` | n/a | yes |
| <a name="input_kubernetes_cluster_rbac_enabled"></a> [kubernetes\_cluster\_rbac\_enabled](#input\_kubernetes\_cluster\_rbac\_enabled) | n/a | `string` | `"true"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure Location of resources | `string` | `"uksouth"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources | `string` | `"devopsthehardway"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->