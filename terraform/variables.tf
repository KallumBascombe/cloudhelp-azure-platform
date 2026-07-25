variable "company_name" {
  description = "Name of the company used in Azure resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev or prod."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either dev or prod."
  }
}

variable "location" {
  description = "Azure region in which resources will be deployed."
  type        = string
}

variable "owner" {
  description = "Person responsible for the Azure resources."
  type        = string
}

variable "cost_centre" {
  description = "Business department responsible for the Azure costs."
  type        = string
}