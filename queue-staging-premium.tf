locals {
  staging_resource_count_premium = var.env == "aat" ? "1" : "0"
}

module "envelopes-staging-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=DTSPO-6371_azurerm_upgrade"
  name                = "envelopes-staging"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.envelope_queue_max_delivery_count
}

module "processed-envelopes-staging-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=DTSPO-6371_azurerm_upgrade"
  name                = "processed-envelopes-staging"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name
  lock_duration       = "PT5M"
}

module "payments-staging-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=DTSPO-6371_azurerm_upgrade"
  name                = "payments-staging"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name
  lock_duration       = "PT5M"
  max_delivery_count  = var.payment_queue_max_delivery_count

  duplicate_detection_history_time_window = "PT15M"
}

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "envelopes_staging_queue_send_conn_str_premium" {
  name         = "envelopes-staging-queue-send-connection-string-premium"
  value        = module.envelopes-staging-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "envelopes_staging_queue_listen_conn_str_premium" {
  name         = "envelopes-staging-queue-listen-connection-string-premium"
  value        = module.envelopes-staging-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_send_conn_str_premium" {
  name         = "processed-envelopes-staging-queue-send-connection-string-premium"
  value        = module.processed-envelopes-staging-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_listen_conn_str_premium" {
  name         = "processed-envelopes-staging-queue-listen-connection-string-premium"
  value        = module.processed-envelopes-staging-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "payments_staging_queue_send_conn_str_premium" {
  name         = "payments-staging-queue-send-connection-string-premium"
  value        = module.payments-staging-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "payments_staging_queue_listen_conn_str_premium" {
  name         = "payments-staging-queue-listen-connection-string-premium"
  value        = module.payments-staging-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
  count        = local.staging_resource_count_premium
}

resource "azurerm_key_vault_secret" "envelopes_staging_queue_send_access_key_premium" {
  name         = "envelopes-staging-queue-send-shared-access-key-premium"
  value        = module.envelopes-staging-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "envelopes_staging_queue_listen_access_key_premium" {
  name         = "envelopes-staging-queue-listen-shared-access-key-premium"
  value        = module.envelopes-staging-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_send_access_key_premium" {
  name         = "processed-envelopes-staging-queue-send-shared-access-key-premium"
  value        = module.processed-envelopes-staging-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_listen_access_key_premium" {
  name         = "processed-envelopes-staging-queue-listen-shared-access-key-premium"
  value        = module.processed-envelopes-staging-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}


resource "azurerm_key_vault_secret" "payments_staging_queue_send_access_key_premium" {
  name         = "payments-staging-queue-send-shared-access-key-premium"
  value        = module.payments-staging-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "payments_staging_queue_listen_access_key_premium" {
  name         = "payments-staging-queue-listen-shared-access-key-premium"
  value        = module.payments-staging-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

# endregion
