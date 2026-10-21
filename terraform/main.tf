module "networking" {
  source = "./modules/networking"

  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name

  vnet_name          = "${var.company_name}-${var.environment}-vnet"
  vnet_address_space = var.vnet_address_space

  app_subnet_address_prefixes              = var.app_subnet_address_prefixes
  private_endpoint_subnet_address_prefixes = var.private_endpoint_subnet_address_prefixes

  app_nsg_name = "${var.company_name}-${var.environment}-app-nsg"
  common_tags  = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  company_name        = var.company_name
  environment         = var.environment
  resource_group_name = azurerm_resource_group.cloudhelp.name
  location            = azurerm_resource_group.cloudhelp.location
  common_tags         = local.common_tags
}

module "key_vault" {
  source = "./modules/key-vault"

  company_name              = var.company_name
  environment               = var.environment
  location                  = azurerm_resource_group.cloudhelp.location
  resource_group_name       = azurerm_resource_group.cloudhelp.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  common_tags               = local.common_tags
  key_vault_admin_object_id = var.key_vault_admin_object_id
  application_principal_id  = azurerm_user_assigned_identity.application.principal_id
}

module "monitoring" {
  source = "./modules/monitoring"

  company_name        = var.company_name
  environment         = var.environment
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name
  common_tags         = local.common_tags
  alert_email_address = var.alert_email_address

  key_vault_id        = module.key_vault.key_vault_id
  web_app_id          = azurerm_linux_web_app.application.id
  app_service_plan_id = azurerm_service_plan.application.id
  storage_account_id  = module.storage.storage_account_id
}