output "resource_group_name" {
  description = "Name of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.name
}

output "resource_group_id" {
  description = "Azure resource ID of the CloudHelp resource group."
  value       = azurerm_resource_group.cloudhelp.id
}

output "virtual_network_name" {
  description = "Name of the CloudHelp virtual network."
  value       = azurerm_virtual_network.cloudhelp.name
}

output "virtual_network_id" {
  description = "Resource ID of the CloudHelp virtual network."
  value       = azurerm_virtual_network.cloudhelp.id
}

output "app_subnet_id" {
  description = "Resource ID of the application subnet."
  value       = azurerm_subnet.app.id
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the private endpoint subnet."
  value       = azurerm_subnet.private_endpoints.id
}

output "app_network_security_group_name" {
  description = "Name of the application subnet network security group."
  value       = azurerm_network_security_group.app.name
}

output "app_network_security_group_id" {
  description = "Resource ID of the application subnet network security group."
  value       = azurerm_network_security_group.app.id
}

output "storage_account_name" {
  description = "Name of the CloudHelp storage account."
  value       = azurerm_storage_account.cloudhelp.name
}

output "storage_account_id" {
  description = "Resource ID of the CloudHelp storage account."
  value       = azurerm_storage_account.cloudhelp.id
}

output "customer_files_container_name" {
  description = "Name of the customer files container."
  value       = azurerm_storage_container.customer_files.name
}

output "customer_files_container_id" {
  description = "Resource ID of the customer files container."
  value       = azurerm_storage_container.customer_files.id
}

output "key_vault_name" {
  description = "Name of the CloudHelp Key Vault."
  value       = azurerm_key_vault.cloudhelp.name
}

output "key_vault_id" {
  description = "Resource ID of the CloudHelp Key Vault."
  value       = azurerm_key_vault.cloudhelp.id
}

output "key_vault_uri" {
  description = "URI used to access the CloudHelp Key Vault."
  value       = azurerm_key_vault.cloudhelp.vault_uri
}

output "application_identity_id" {
  description = "Resource ID of the CloudHelp application managed identity."
  value       = azurerm_user_assigned_identity.application.id
}

output "application_identity_client_id" {
  description = "Client ID of the CloudHelp application managed identity."
  value       = azurerm_user_assigned_identity.application.client_id
}

output "application_identity_principal_id" {
  description = "Principal ID of the CloudHelp application managed identity."
  value       = azurerm_user_assigned_identity.application.principal_id
}

output "application_service_plan_name" {
  description = "Name of the CloudHelp App Service Plan."
  value       = azurerm_service_plan.application.name
}

output "application_service_plan_id" {
  description = "Resource ID of the CloudHelp App Service Plan."
  value       = azurerm_service_plan.application.id
}

output "application_web_app_name" {
  description = "Name of the CloudHelp Linux Web App."
  value       = azurerm_linux_web_app.application.name
}

output "application_web_app_id" {
  description = "Resource ID of the CloudHelp Linux Web App."
  value       = azurerm_linux_web_app.application.id
}

output "application_web_app_hostname" {
  description = "Default hostname of the CloudHelp Linux Web App."
  value       = azurerm_linux_web_app.application.default_hostname
}

output "application_web_app_url" {
  description = "HTTPS URL of the CloudHelp Linux Web App."
  value       = "https://${azurerm_linux_web_app.application.default_hostname}"
}