resource "azurerm_log_analytics_workspace" "cloudhelp" {
  name                = "cloudhelp-dev-law"
  location            = azurerm_resource_group.cloudhelp.location
  resource_group_name = azurerm_resource_group.cloudhelp.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.5

  tags = local.common_tags
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "${var.company_name}-${var.environment}-kv-diagnostics"
  target_resource_id         = azurerm_key_vault.cloudhelp.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cloudhelp.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "web_app" {
  name                       = "${var.company_name}-${var.environment}-app-diagnostics"
  target_resource_id         = azurerm_linux_web_app.application.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cloudhelp.id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "app_service_plan" {
  name                       = "${var.company_name}-${var.environment}-app-plan-diagnostics"
  target_resource_id         = azurerm_service_plan.application.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cloudhelp.id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "blob_storage" {
  name                       = "${var.company_name}-${var.environment}-blob-diagnostics"
  target_resource_id         = "${azurerm_storage_account.cloudhelp.id}/blobServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cloudhelp.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}