data "azurerm_key_vault_secret" "source_bsp_email_secret" {
  name         = "bulk-scan-alert-email"
  key_vault_id = module.vault.key_vault_id
}

module "alert-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = var.env

  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "BSP Alert (${var.env})"
  short_name             = "BSP_alert"
  email_receiver_name    = "BSP Alerts And Monitoring"
  email_receiver_address = data.azurerm_key_vault_secret.source_bsp_email_secret.value
}

resource "azurerm_key_vault_secret" "alert_action_group_name" {
  name         = "alert-action-group-name"
  value        = module.alert-action-group.action_group_name
  key_vault_id = module.vault.key_vault_id
}

output "action_group_name" {
  value = module.alert-action-group.action_group_name
}
