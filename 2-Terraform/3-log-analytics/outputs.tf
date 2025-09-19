output "workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.Log_Analytics_WorkSpace.id
}

output "workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.Log_Analytics_WorkSpace.name
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = data.azurerm_resource_group.resource_group.name
}