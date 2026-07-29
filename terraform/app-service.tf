resource "azurerm_service_plan" "application" {
  name                = "${var.company_name}-${var.environment}-app-plan"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name

  os_type  = "Linux"
  sku_name = "F1"

  tags = local.common_tags
}

resource "random_string" "web_app_suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

locals {
  web_app_name = "${var.company_name}-${var.environment}-app-${random_string.web_app_suffix.result}"
}

resource "azurerm_linux_web_app" "application" {
  name                = local.web_app_name
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name
  service_plan_id     = azurerm_service_plan.application.id

  https_only = true

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.application.id
    ]
  }

  site_config {
    always_on = false
  }

  tags = local.common_tags
}