module "no-envelopes-processed-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "No_envelopes_processed_-_BSP"
  alert_desc = "Triggers when bulk scan processor did not process single envelope in last hour within SLA."

  app_insights_query = <<EOF
traces
| where timestamp > ago(1h)
| where message startswith "Processing zip file"
| make-series count(message) default=0 on timestamp in range(ago(1h), now(), 1m)
| mvexpand count_message, timestamp
| project files = toint(count_message), event_time = todatetime(timestamp)
| summarize ["# files"] = sum(files), last_event = max(event_time)
| extend day_of_week = toint(substring(tostring(dayofweek(last_event)), 0, 1))
| extend last_event_time = bin(last_event % 1d, 1m) + datetime("2018-02-02")
| project ["# files"],
    interval_start = last_event_time > datetime("2018-02-02 09:59:00"),
    interval_end = last_event_time < datetime("2018-02-02 17:01:00"),
    is_weekend = day_of_week == 0 and day_of_week == 6
| project files_are_processed = ["# files"] > 0
    or not (interval_start and interval_end)
    or is_weekend
| filter files_are_processed == false
EOF

  frequency_in_minutes       = 60
  time_window_in_minutes     = 60 // does not matter - set in query
  severity_level             = "4"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Bulk Scan - no envelopes processed"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
