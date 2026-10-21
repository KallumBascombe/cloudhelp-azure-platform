resource "azurerm_virtual_network" "cloudhelp" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloudhelp.name
  address_prefixes     = var.app_subnet_address_prefixes
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloudhelp.name
  address_prefixes     = var.private_endpoint_subnet_address_prefixes

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_network_security_group" "app" {
  name                = var.app_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}