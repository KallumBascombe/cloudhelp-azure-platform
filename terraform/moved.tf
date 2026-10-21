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

moved {
  from = random_string.storage_suffix
  to   = module.storage.random_string.storage_suffix
}

moved {
  from = azurerm_storage_account.cloudhelp
  to   = module.storage.azurerm_storage_account.cloudhelp
}

moved {
  from = azurerm_storage_container.customer_files
  to   = module.storage.azurerm_storage_container.customer_files
}

moved {
  from = random_string.key_vault_suffix
  to   = module.key_vault.random_string.key_vault_suffix
}

moved {
  from = azurerm_key_vault.cloudhelp
  to   = module.key_vault.azurerm_key_vault.cloudhelp
}

moved {
  from = azurerm_role_assignment.current_user_key_vault_secrets_officer
  to   = module.key_vault.azurerm_role_assignment.current_user_key_vault_secrets_officer
}

moved {
  from = azurerm_role_assignment.application_key_vault_secrets_user
  to   = module.key_vault.azurerm_role_assignment.application_key_vault_secrets_user
}

moved {
  from = azurerm_log_analytics_workspace.cloudhelp
  to   = module.monitoring.azurerm_log_analytics_workspace.cloudhelp
}

moved {
  from = azurerm_monitor_diagnostic_setting.key_vault
  to   = module.monitoring.azurerm_monitor_diagnostic_setting.key_vault
}

moved {
  from = azurerm_monitor_diagnostic_setting.web_app
  to   = module.monitoring.azurerm_monitor_diagnostic_setting.web_app
}

moved {
  from = azurerm_monitor_diagnostic_setting.app_service_plan
  to   = module.monitoring.azurerm_monitor_diagnostic_setting.app_service_plan
}

moved {
  from = azurerm_monitor_diagnostic_setting.blob_storage
  to   = module.monitoring.azurerm_monitor_diagnostic_setting.blob_storage
}

moved {
  from = azurerm_monitor_action_group.cloudhelp
  to   = module.monitoring.azurerm_monitor_action_group.cloudhelp
}

moved {
  from = azurerm_monitor_metric_alert.web_app_http_5xx
  to   = module.monitoring.azurerm_monitor_metric_alert.web_app_http_5xx
}

moved {
  from = azurerm_monitor_metric_alert.app_service_plan_high_cpu
  to   = module.monitoring.azurerm_monitor_metric_alert.app_service_plan_high_cpu
}

moved {
  from = azurerm_monitor_metric_alert.app_service_plan_high_memory
  to   = module.monitoring.azurerm_monitor_metric_alert.app_service_plan_high_memory
}

moved {
  from = azurerm_monitor_scheduled_query_rules_alert_v2.key_vault_failed_requests
  to   = module.monitoring.azurerm_monitor_scheduled_query_rules_alert_v2.key_vault_failed_requests
}