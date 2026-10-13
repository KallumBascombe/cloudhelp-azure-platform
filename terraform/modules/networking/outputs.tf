output "app_subnet_id" {
  description = "Azure resource ID of the application subnet."
  value       = azurerm_subnet.app.id
}

output "vnet_id" {
  description = "Azure resource ID of the Virtual Network."
  value       = azurerm_virtual_network.cloudhelp.id
}

output "private_endpoints_subnet_id" {
  description = "Azure resource ID of the private endpoints subnet."
  value       = azurerm_subnet.private_endpoints.id
}

output "app_nsg_id" {
  description = "Azure resource ID of the application Network Security Group."
  value       = azurerm_network_security_group.app.id
}

output "vnet_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.cloudhelp.name
}

output "app_nsg_name" {
  description = "Name of the application Network Security Group."
  value       = azurerm_network_security_group.app.name
}