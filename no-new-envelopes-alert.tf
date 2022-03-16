module "no-new-envelopes-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "No_new_envelopes_-_Bulk_Scan_Processor"
  alert_desc  = "Triggers when Bulk Scan Processor did not receive new envelopes"

  app_insights_query = <<EOF
traces
| where message startswith "No envelopes received"
EOF

  frequency_in_minutes        = 60
  time_window_in_minutes      = 90
  severity_level              = "4"
  action_group_name           = module.alert-action-group.action_group_name
  custom_email_subject        = "Bulk Scan Processor - No new envelopes"
  trigger_threshold_operator  = "GreaterThan"
  trigger_threshold           = 0
  resourcegroup_name          = azurerm_resource_group.rg.name
}
