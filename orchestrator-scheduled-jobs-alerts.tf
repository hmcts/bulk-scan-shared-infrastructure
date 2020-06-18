module "consume-envelopes-queue-messages-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Bulk_Scan_Consume_Envelopes_Queue_Messages_-_BSP"
  alert_desc = "Triggers when no logs from consume envelopes queue messages job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started consume-envelopes-queue job'"

  frequency_in_minutes       = 30
  time_window_in_minutes     = 30
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan consume-envelopes-queue scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "delete-messages-from-envelopes-dlq-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Bulk_Scan_Delete_Messages_From_Envelopes_Dlq_-_BSP"
  alert_desc = "Triggers when no logs from delete messages from envelopes dlq job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started delete-envelopes-dlq-messages job'"

  frequency_in_minutes       = 120
  time_window_in_minutes     = 180
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan delete-envelopes-dlq-messages scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}