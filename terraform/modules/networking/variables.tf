variable "location" {
  description = "Azure region where networking resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing Azure Resource Group."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "IP address ranges assigned to the Virtual Network."
  type        = list(string)
}

variable "app_subnet_address_prefixes" {
  description = "IP address ranges assigned to the application subnet."
  type        = list(string)
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "IP address ranges assigned to the private endpoint subnet."
  type        = list(string)
}

variable "common_tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
}

variable "app_nsg_name" {
  description = "Name of the application Network Security Group."
  type        = string
}