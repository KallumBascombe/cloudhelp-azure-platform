

resource "azurerm_user_assigned_identity" "application" {
  name                = "${var.company_name}-${var.environment}-app-identity"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name

  tags = local.common_tags
}


