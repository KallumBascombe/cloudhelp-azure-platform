output "resource_group_name" {
  description = "The name of the Resource Group containing the Terraform state Storage Account."
  value       = azurerm_resource_group.terraform_state.name
}

output "storage_account_name" {
  description = "The name of the Storage Account used to store the Terraform state."
  value       = azurerm_storage_account.terraform_state.name
}

output "container_name" {
  description = "The name of the Blob Container storing the Terraform state."
  value       = azurerm_storage_container.terraform_state.name
}