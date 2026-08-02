resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

resource "azurerm_storage_account" "cloudhelp" {
  name                     = "${var.company_name}${var.environment}st${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.cloudhelp.name
  location                 = azurerm_resource_group.cloudhelp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

resource "azurerm_storage_container" "customer_files" {
  name                  = "customer-files"
  storage_account_id    = azurerm_storage_account.cloudhelp.id
  container_access_type = "private"
}