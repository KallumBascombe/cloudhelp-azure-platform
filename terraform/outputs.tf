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
  value       = module.networking.vnet_name
}

output "virtual_network_id" {
  description = "Resource ID of the CloudHelp virtual network."
  value       = module.networking.vnet_id
}

output "app_subnet_id" {
  description = "Resource ID of the application subnet."
  value       = module.networking.app_subnet_id
}

output "private_endpoint_subnet_id" {
  description = "Resource ID of the private endpoint subnet."
  value       = module.networking.private_endpoints_subnet_id
}

output "app_network_security_group_name" {
  description = "Name of the application subnet network security group."
  value       = module.networking.app_nsg_name
}

output "app_network_security_group_id" {
  description = "Resource ID of the application subnet network security group."
  value       = module.networking.app_nsg_id
}

output "storage_account_name" {
  description = "Name of the CloudHelp storage account."
  value       = module.storage.storage_account_name
}

output "storage_account_id" {
  description = "Resource ID of the CloudHelp storage account."
  value       = module.storage.storage_account_id
}

output "customer_files_container_name" {
  description = "Name of the customer files container."
  value       = module.storage.customer_files_container_name
}

output "customer_files_container_id" {
  description = "Resource ID of the customer files container."
  value       = module.storage.customer_files_container_id
}

output "key_vault_name" {
  description = "Name of the CloudHelp Key Vault."
  value       = module.key_vault.key_vault_name
}

output "key_vault_id" {
  description = "Resource ID of the CloudHelp Key Vault."
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI used to access the CloudHelp Key Vault."
  value       = module.key_vault.key_vault_uri
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

output "log_analytics_workspace_name" {
  description = "Name of the CloudHelp Log Analytics Workspace."
  value       = module.monitoring.log_analytics_workspace_name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the CloudHelp Log Analytics Workspace."
  value       = module.monitoring.log_analytics_workspace_id
}
