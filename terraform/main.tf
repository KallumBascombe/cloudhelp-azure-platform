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

