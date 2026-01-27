module "blob-processing-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Blob_Processing_-_BSP"
  alert_desc = "Triggers when no logs from blob processing job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started blob processing job'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "30"
  time_window_in_minutes     = "30"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan Blob processing scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "upload-documents-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Upload-Documents_-_BSP"
  alert_desc = "Triggers when no logs from upload documents job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started upload-documents job'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "30"
  time_window_in_minutes     = "30"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan upload-documents scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "delete-rejected-files-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name
  common_tags       = var.common_tags

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Delete_Rejected_Files_-_BSP"
  alert_desc = "Triggers when no logs from delete-rejected-files job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started delete-rejected-files job'"

  frequency_in_minutes       = "120"
  time_window_in_minutes     = "120"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan delete-rejected-files scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "delete-complete-files-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Delete_Completed_Files_-_BSP"
  alert_desc = "Triggers when no logs from delete completed files job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started delete-complete-files job'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "120"
  time_window_in_minutes     = "120"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan delete-complete-files scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "orchestrator-notifications-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Send_Orchestrator_Notification_-_BSP"
  alert_desc = "Triggers when no logs from send-orchestrator-notification job found within timeframe."

  app_insights_query = "traces | where message startswith 'Started send-orchestrator-notification job'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "30"
  time_window_in_minutes     = "30"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan send-orchestrator-notification scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "incomplete-envelopes-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights_uk.name

  enabled    = var.env == "prod"
  alert_name = "Bulk_Scan_Incomplete_Envelopes_Jobs_-_BSP"
  alert_desc = "Triggers when no logs from incomplete-envelopes-monitoring job found within timeframe."

  app_insights_query = "traces | where message starts with 'Started incomplete-envelopes-monitoring job'"
  common_tags        = var.common_tags

  frequency_in_minutes       = "120"
  time_window_in_minutes     = "120"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Bulk Scan incomplete-envelopes-monitoring scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
