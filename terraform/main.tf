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