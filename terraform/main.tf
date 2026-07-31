locals {
  resource_group_name = "${var.company_name}-${var.environment}-rg"

  common_tags = {
    Project     = "CloudHelp"
    Application = "CloudHelp"
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
    CostCentre  = var.cost_centre
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "cloudhelp" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "cloudhelp" {
  name                = "${var.company_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name
  address_space       = var.vnet_address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.cloudhelp.name
  virtual_network_name = azurerm_virtual_network.cloudhelp.name
  address_prefixes     = var.app_subnet_address_prefixes
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints-subnet"
  resource_group_name  = azurerm_resource_group.cloudhelp.name
  virtual_network_name = azurerm_virtual_network.cloudhelp.name
  address_prefixes     = var.private_endpoint_subnet_address_prefixes

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_network_security_group" "app" {
  name                = "${var.company_name}-${var.environment}-app-nsg"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

resource "azurerm_storage_account" "cloudhelp" {
  name                     = "${var.company_name}${var.environment}st${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.cloudhelp.name
  location                 = azurerm_resource_group.cloudhelp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

resource "azurerm_storage_container" "customer_files" {
  name                  = "customer-files"
  storage_account_id    = azurerm_storage_account.cloudhelp.id
  container_access_type = "private"
}

resource "random_string" "key_vault_suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

resource "azurerm_key_vault" "cloudhelp" {
  name                = "${var.company_name}-${var.environment}-kv-${random_string.key_vault_suffix.result}"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  soft_delete_retention_days = 7

  # Development settings; production would use private access
  # and evaluate enabling purge protection.
  purge_protection_enabled      = false
  public_network_access_enabled = true

  tags = local.common_tags
}

resource "azurerm_role_assignment" "current_user_key_vault_secrets_officer" {
  scope                = azurerm_key_vault.cloudhelp.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.key_vault_admin_object_id
}

resource "azurerm_user_assigned_identity" "application" {
  name                = "${var.company_name}-${var.environment}-app-identity"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name

  tags = local.common_tags
}

resource "azurerm_role_assignment" "application_key_vault_secrets_user" {
  scope                = azurerm_key_vault.cloudhelp.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.application.principal_id
}