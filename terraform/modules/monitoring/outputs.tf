output "log_analytics_workspace_name" {
  description = "Name of the CloudHelp Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.cloudhelp.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the CloudHelp Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.cloudhelp.id
}

output "action_group_id" {
  description = "Resource ID of the CloudHelp Monitor Action Group."
  value       = azurerm_monitor_action_group.cloudhelp.id
}