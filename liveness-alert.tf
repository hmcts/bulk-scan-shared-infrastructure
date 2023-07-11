module "bulk-scan-processor-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "Bulk_Scan_Processor_liveness_-_BSP"
  alert_desc  = "Triggers when bulk scan processor looks like being down within a 30 minutes window timeframe."
  common_tags = var.common_tags

  app_insights_query = <<EOF
requests
| where url endswith "/health/liveness" and success != "True"
| where cloud_RoleName == "Bulk Scan Processor"
EOF

  frequency_in_minutes       = "15"
  time_window_in_minutes     = "16"
  severity_level             = "2"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan Processor liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "10"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "bulk-scan-payment-processor-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "Bulk_Scan_Payment_Processor_liveness_-_BSP"
  alert_desc  = "Triggers when bulk scan payment processor looks like being down within a 30 minutes window timeframe."
  common_tags = var.common_tags

  app_insights_query = <<EOF
requests
| where url endswith "/health/liveness" and success != "True"
| where cloud_RoleName == "Bulk Scan Payment Processor"
EOF

  frequency_in_minutes       = "15"
  time_window_in_minutes     = "16"
  severity_level             = "2"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan Payment Processor liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "10"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "bulk-scan-orchestrator-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "Bulk_Scan_Orchestrator_liveness_-_BSP"
  alert_desc  = "Triggers when bulk scan orchestrator looks like being down within a 30 minutes window timeframe."
  common_tags = var.common_tags

  app_insights_query = <<EOF
requests
| where url endswith "/health/liveness" and success != "True"
| where cloud_RoleName == "Bulk Scan Orchestrator"
EOF

  frequency_in_minutes       = "15"
  time_window_in_minutes     = "16"
  severity_level             = "2"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan Orchestrator liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "10"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
