variable "location" {
  description = "The Azure region where the Terraform state resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group used to store the Terraform state resources."
  type        = string
}

variable "storage_account_name" {
  description = "The globally unique name of the Storage Account used to store the Terraform state."
  type        = string
}

variable "container_name" {
  description = "The name of the Blob Container that stores the Terraform state file."
  type        = string
}