module "bulk-scan-processor-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert?ref=feature/parameterise-enabled-field"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Bulk Scan Processor liveness - BSP"
  alert_desc = "Triggers when bulk scan processor looks like being down within a 30 minutes window timeframe."

  app_insights_query = <<EOF
requests
| where name == "GET /health" and resultCode != "200"
| where url contains "processor"
EOF

  frequency_in_minutes       = 15
  time_window_in_minutes     = 30
  severity_level             = "2"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan Processor liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 5
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "bulk-scan-orchestrator-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert?ref=feature/parameterise-enabled-field"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Bulk Scan Orchestrator liveness - BSP"
  alert_desc = "Triggers when bulk scan orchestrator looks like being down within a 30 minutes window timeframe."

  app_insights_query = <<EOF
requests
| where name == "GET /health" and resultCode != "200"
| where url contains "orchestrator"
EOF

  frequency_in_minutes       = 15
  time_window_in_minutes     = 30
  severity_level             = "2"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan Orchestrator liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 5
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
