output "resource_group_name" {
  description = "Name of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.name
}

output "resource_group_id" {
  description = "Azure resource ID of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.id
}

output "virtual_network_name" {
  description = "Name of the CloudHelp virtual network"
  value       = azurerm_virtual_network.cloudhelp.name
}

output "virtual_network_id" {
  description = "Resource ID of the CloudHelp virtual network"
  value       = azurerm_virtual_network.cloudhelp.id
}

output "app_subnet_id" {
  description = "Resource ID of the application subnet"
  value       = azurerm_subnet.app.id
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoints.id
}