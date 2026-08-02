terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}

  subscription_id     = var.subscription_id
  storage_use_azuread = true

  # Resource providers are registered separately rather than
  # automatically by the AzureRM provider.
  resource_provider_registrations = "none"
}