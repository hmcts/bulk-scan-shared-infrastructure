module "queue-namespace-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-servicebus-${var.env}-premium"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  sku                 = "Premium"
  capacity            = 1
  zone_redundant      = true
  common_tags         = var.common_tags
}

module "envelopes-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "envelopes"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.envelope_queue_max_delivery_count
}

module "processed-envelopes-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "processed-envelopes"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name
  lock_duration       = "PT5M"
}

module "payments-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "payments"
  namespace_name      = module.queue-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name
  lock_duration       = "PT5M"
  max_delivery_count  = var.payment_queue_max_delivery_count

  duplicate_detection_history_time_window = "PT15M"
}

# region shared access keys

resource "azurerm_key_vault_secret" "envelopes_queue_send_access_key_premium" {
  name         = "envelopes-queue-send-shared-access-key-premium"
  value        = module.envelopes-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_access_key_premium" {
  name         = "envelopes-queue-listen-shared-access-key-premium"
  value        = module.envelopes-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_access_key_premium" {
  name         = "processed-envelopes-queue-send-shared-access-key-premium"
  value        = module.processed-envelopes-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_access_key_premium" {
  name         = "processed-envelopes-queue-listen-shared-access-key-premium"
  value        = module.processed-envelopes-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}


resource "azurerm_key_vault_secret" "payments_queue_send_access_key_premium" {
  name         = "payments-queue-send-shared-access-key-premium"
  value        = module.payments-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "payments_queue_listen_access_key_premium" {
  name         = "payments-queue-listen-shared-access-key-premium"
  value        = module.payments-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

# endregion

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "envelopes_queue_send_conn_str_premium" {
  name         = "envelopes-queue-send-connection-string-premium"
  value        = module.envelopes-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_conn_str_premium" {
  name         = "envelopes-queue-listen-connection-string-premium"
  value        = module.envelopes-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "envelopes_queue_max_delivery_count_premium" {
  name         = "envelopes-queue-max-delivery-count-premium"
  value        = var.envelope_queue_max_delivery_count
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_conn_str_premium" {
  name         = "processed-envelopes-queue-send-connection-string-premium"
  value        = module.processed-envelopes-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_conn_str_premium" {
  name         = "processed-envelopes-queue-listen-connection-string-premium"
  value        = module.processed-envelopes-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}


resource "azurerm_key_vault_secret" "payments_queue_send_conn_str_premium" {
  name         = "payments-queue-send-connection-string-premium"
  value        = module.payments-queue-premium.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "payments_queue_listen_conn_str_premium" {
  name         = "payments-queue-listen-connection-string-premium"
  value        = module.payments-queue-premium.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}

# endregion
