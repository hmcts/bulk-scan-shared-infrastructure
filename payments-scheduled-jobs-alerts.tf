module "consume-payments-queue-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Consume_Payments_Queue_Messages_-_BSP"
  alert_desc = "Triggers when consume payments queue listener log not found within timeframe."

  app_insights_query = "traces | where message startswith 'Payments queue consume listener is working.'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "60"
  time_window_in_minutes     = "60"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan consume-payments-queue listener alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
