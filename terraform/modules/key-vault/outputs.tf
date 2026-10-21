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