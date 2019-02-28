// single alert to minify unnecessary cost because threshold used in here is minimal
module "bulk-scan-exception-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod" || var.env == "aat"}"
  alert_name = "Bulk_Scan_exception_-_BSP"
  alert_desc = "Triggers when bulk scan services receive at least one exception within a 15 minutes window timeframe."

  app_insights_query = "exceptions"

  frequency_in_minutes       = 15
  time_window_in_minutes     = 15
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
