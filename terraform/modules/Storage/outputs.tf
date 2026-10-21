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