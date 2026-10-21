variable "company_name" {
  description = "Company name used when naming Key Vault."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev or prod."
  type        = string
}

variable "location" {
  description = "Azure region where Key Vault is deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to Key Vault."
  type        = map(string)
}

variable "key_vault_admin_object_id" {
  description = "Object ID of the administrator receiving Secrets Officer permissions."
  type        = string
}

variable "application_principal_id" {
  description = "Principal ID of the application managed identity."
  type        = string
}