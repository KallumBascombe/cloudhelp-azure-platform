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