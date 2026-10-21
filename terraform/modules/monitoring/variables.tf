variable "company_name" {
  description = "Company name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing monitoring resources."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to monitoring resources."
  type        = map(string)
}

variable "alert_email_address" {
  description = "Email address receiving Azure Monitor alerts."
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault being monitored."
  type        = string
}

variable "web_app_id" {
  description = "Resource ID of the application Web App."
  type        = string
}

variable "app_service_plan_id" {
  description = "Resource ID of the App Service Plan."
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID of the Storage Account."
  type        = string
}