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

resource "azurerm_monitor_action_group" "cloudhelp" {
  name                = "${var.company_name}-${var.environment}-ag"
  resource_group_name = azurerm_resource_group.cloudhelp.name
  short_name          = "ch-${var.environment}"

  email_receiver {
    name                    = "cloudhelp-operations"
    email_address           = var.alert_email_address
    use_common_alert_schema = true
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "web_app_http_5xx" {
  name                = "${var.company_name}-${var.environment}-app-http-5xx-alert"
  resource_group_name = azurerm_resource_group.cloudhelp.name
  scopes              = [azurerm_linux_web_app.application.id]

  description = "Alerts when the CloudHelp Web App returns HTTP 5xx responses."
  severity    = 1
  frequency   = "PT5M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.cloudhelp.id
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "app_service_plan_high_cpu" {
  name                = "${var.company_name}-${var.environment}-app-plan-high-cpu-alert"
  resource_group_name = azurerm_resource_group.cloudhelp.name
  scopes              = [azurerm_service_plan.application.id]

  description = "Alerts when the CloudHelp App Service Plan CPU usage is greater than 80 percent."
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.cloudhelp.id
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "app_service_plan_high_memory" {
  name                = "${var.company_name}-${var.environment}-app-plan-high-memory-alert"
  resource_group_name = azurerm_resource_group.cloudhelp.name
  scopes              = [azurerm_service_plan.application.id]

  description = "Alerts when the CloudHelp App Service Plan memory usage is greater than 80 percent."
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "MemoryPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.cloudhelp.id
  }

  tags = local.common_tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "key_vault_failed_requests" {
  name                = "${var.company_name}-${var.environment}-kv-failed-requests-alert"
  resource_group_name = azurerm_resource_group.cloudhelp.name
  location            = azurerm_resource_group.cloudhelp.location

  scopes = [
    azurerm_log_analytics_workspace.cloudhelp.id
  ]

  description          = "Alerts when failed requests are detected against the CloudHelp Key Vault."
  severity             = 1
  enabled              = true
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  criteria {
    query = <<-QUERY
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where httpStatusCode_d >= 300
      | where not(OperationName == "Authentication" and httpStatusCode_d == 401)
    QUERY

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.cloudhelp.id
    ]
  }

  tags = local.common_tags
}