output "resource_group_name" {
  description = "Name of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.name
}

output "resource_group_id" {
  description = "Azure resource ID of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.id
}