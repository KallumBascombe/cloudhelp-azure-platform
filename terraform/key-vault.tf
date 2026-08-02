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
