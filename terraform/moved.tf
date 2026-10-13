moved {
  from = azurerm_subnet.app
  to   = module.networking.azurerm_subnet.app
}

moved {
  from = azurerm_subnet.private_endpoints
  to   = module.networking.azurerm_subnet.private_endpoints
}

moved {
  from = azurerm_network_security_group.app
  to   = module.networking.azurerm_network_security_group.app
}

moved {
  from = azurerm_subnet_network_security_group_association.app
  to   = module.networking.azurerm_subnet_network_security_group_association.app
}

moved {
  from = azurerm_virtual_network.cloudhelp
  to   = module.networking.azurerm_virtual_network.cloudhelp
}