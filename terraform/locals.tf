locals {
  resource_group_name = "${var.company_name}-${var.environment}-rg"

  common_tags = {
    Project          = "CloudHelp"
    Application      = "CloudHelp"
    Environment      = var.environment
    Owner            = var.owner
    ManagedBy        = "Terraform"
    CostCentre       = var.cost_centre
    DeploymentMethod = "GitHub Actions"
  }
}