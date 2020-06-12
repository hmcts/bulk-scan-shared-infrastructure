module "consume-payments-queue-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Bulk_Scan_Consume_Payments_Queue_Messages_-_BSP"
  alert_desc = "Triggers when no logs from consume payments queue messages job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started consume-payments-queue job'"

  frequency_in_minutes       = 30
  time_window_in_minutes     = 30
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan consume-payments-queue scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}