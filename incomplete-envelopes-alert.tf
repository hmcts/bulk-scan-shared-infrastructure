module "bulk-scan-incomplete-envelopes-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_incomplete_envelopes_-_BSP"
  alert_desc = "Triggers when bulk scan processor receives a log entry about having incomplete envelopes greater than 0"

  app_insights_query = <<EOF
traces
| where severityLevel == 2
| extend logger = tostring(customDimensions.LoggerName)
| where logger endswith "IncompleteEnvelopesTask"
| extend envelope_count = toint(extract("^There are (\\d+)", 1, message))
| extend event_date = extract("^There are \\d+ incomplete envelopes as of ([0-9\\-]{10})$", 1, message)
| where envelope_count > 0
| project envelope_count, event_date
EOF

  # consider increasing by hour to run less frequently
  # loss: increased window from actual log event which happens only once per day
  frequency_in_minutes       = 60
  time_window_in_minutes     = 60
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan incomplete envelopes"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = azurerm_resource_group.rg.name
}
