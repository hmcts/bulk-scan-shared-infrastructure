// single alert to minify unnecessary cost because threshold used in here is minimal
module "bulk-scan-dlq-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.appinsights_location
  app_insights_name = module_application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Bulk_Scan_DLQ_-_BSP"
  alert_desc  = "Triggers when bulk scan services record at least one dead lettered message within a 15 minutes window timeframe."
  common_tags = var.common_tags

  app_insights_query = <<EOF
customEvents
| where name == "DeadLetter"
| extend dimensions = parse_json(customDimensions)
| extend measurements = parse_json(customMeasurements)
| project timestamp,
          reason = dimensions.reason,
          description = dimensions.description,
          messageId = dimensions.messageId,
          queue = dimensions.queue,
          deliveryCount = measurements.deliveryCount
EOF

  frequency_in_minutes       = "15"
  time_window_in_minutes     = "15"
  severity_level             = "2"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan dead letter"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
