variable "company_name" {
  description = "Company name used when naming storage resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev or prod."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing storage resources."
  type        = string
}

variable "location" {
  description = "Azure region where storage resources are deployed."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to storage resources."
  type        = map(string)
}