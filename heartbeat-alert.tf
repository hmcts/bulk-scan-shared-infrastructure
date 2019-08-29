module "envelopes-queue-heartbeat-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Envelopes queue heartbeat"
  alert_desc = "Triggers when orchestrator didn't read heatbeat message from the queue in withing timeframe."

  app_insights_query = "traces | where message startswith 'Heartbeat message received'"

  frequency_in_minutes       = 15
  time_window_in_minutes     = 15
  severity_level             = "1"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan Heartbeat"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
