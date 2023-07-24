locals {
  service_bus_name = var.azure_service_bus_name
}

module "queue-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.aks
  }

  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.service_bus_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  sku                 = var.sku_service_bus
  capacity            = 1
  zone_redundant      = var.zone_redundant_service_bus
  common_tags         = var.common_tags
}

module "envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "envelopes"
  namespace_name      = module.queue-namespace.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.envelope_queue_max_delivery_count
}

module "processed-envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "processed-envelopes"
  namespace_name      = module.queue-namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  lock_duration       = "PT5M"

  // False in non prod, true in prod
  requires_duplicate_detection            = var.requires_duplicate_service_bus
  duplicate_detection_history_time_window = "PT59M"
  max_delivery_count                      = var.envelope_queue_max_delivery_count
}

module "payments-queue" {
  source                       = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                         = "payments"
  namespace_name               = module.queue-namespace.name
  resource_group_name          = azurerm_resource_group.rg.name
  lock_duration                = "PT5M"
  max_delivery_count           = var.payment_queue_max_delivery_count
  requires_duplicate_detection = var.requires_duplicate_service_bus

  // 59 for non prod and 15 for prod
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window_service_bus
}

# region shared access keys

resource "azurerm_key_vault_secret" "envelopes_queue_send_access_key" {
  name         = var.envelopes_queue_send_name
  value        = module.envelopes-queue.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.envelopes_queue_send_access_key_premium
  to   = azurerm_key_vault_secret.envelopes_queue_send_access_key
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_access_key" {
  name         = var.envelopes_queue_listen_name
  value        = module.envelopes-queue.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.envelopes_queue_listen_access_key_premium
  to   = azurerm_key_vault_secret.envelopes_queue_listen_access_key
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_access_key" {
  name         = var.processed_envelopes_queue_send_name
  value        = module.processed-envelopes-queue.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.processed_envelopes_queue_send_access_key
  to   = azurerm_key_vault_secret.processed_envelopes_queue_send_access_key_premium
}

moved {
  from = azurerm_key_vault_secret.processed_envelopes_queue_listen_access_key_premium
  to   = azurerm_key_vault_secret.processed_envelopes_queue_listen_access_key
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_access_key" {
  name         = var.processed_envelopes_queue_listen_name
  value        = module.processed-envelopes-queue.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.payments_queue_send_access_key_premium
  to   = azurerm_key_vault_secret.payments_queue_send_access_key
}

resource "azurerm_key_vault_secret" "payments_queue_send_access_key" {
  name         = var.payments_queue_send_name
  value        = module.payments-queue.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.payments_queue_listen_access_key_premium
  to   = azurerm_key_vault_secret.payments_queue_listen_access_key
}

resource "azurerm_key_vault_secret" "payments_queue_listen_access_key" {
  name         = var.payments_queue_listen_name
  value        = module.payments-queue.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

# endregion

# region connection strings and other shared queue information as Key Vault secrets
moved {
  from = azurerm_key_vault_secret.envelopes_queue_send_conn_str_premium
  to   = azurerm_key_vault_secret.envelopes_queue_send_conn_str
}

resource "azurerm_key_vault_secret" "envelopes_queue_send_conn_str" {
  name         = var.envelopes_queue_send_resource_name
  value        = module.envelopes-queue.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.envelopes_queue_listen_conn_str_premium
  to   = azurerm_key_vault_secret.envelopes_queue_listen_conn_str
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_conn_str" {
  name         = var.envelopes_queue_listen_resource_name
  value        = module.envelopes-queue.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.envelopes_queue_max_delivery_count_premium
  to   = azurerm_key_vault_secret.envelopes_queue_max_delivery_count
}

resource "azurerm_key_vault_secret" "envelopes_queue_max_delivery_count" {
  name         = var.envelopes_queue_max_delivery_count_resource_name
  value        = var.envelope_queue_max_delivery_count
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.processed_envelopes_queue_send_conn_str_premium
  to   = azurerm_key_vault_secret.processed_envelopes_queue_send_conn_str
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_conn_str" {
  name         = var.processed_envelopes_queue_send_resource_name
  value        = module.processed-envelopes-queue.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.processed_envelopes_queue_listen_conn_str_premium
  to   = azurerm_key_vault_secret.processed_envelopes_queue_listen_conn_str
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_conn_str" {
  name         = var.processed_envelopes_queue_listen_resource_name
  value        = module.processed-envelopes-queue.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.payments_queue_send_conn_str_premium
  to   = azurerm_key_vault_secret.payments_queue_send_conn_str
}

resource "azurerm_key_vault_secret" "payments_queue_send_conn_str" {
  name         = var.payments_queue_send_resource_name
  value        = module.payments-queue.primary_send_connection_string
  key_vault_id = module.vault.key_vault_id
}

moved {
  from = azurerm_key_vault_secret.payments_queue_listen_conn_str_premium
  to   = azurerm_key_vault_secret.payments_queue_listen_conn_str
}

resource "azurerm_key_vault_secret" "payments_queue_listen_conn_str" {
  name         = var.payments_queue_listen_resource_name
  value        = module.payments-queue.primary_listen_connection_string
  key_vault_id = module.vault.key_vault_id
}

# endregion

# Not sure if this is still needed anymore, or if we can remove.
# Not required for prod it seems but was included for lower envs
# Deprecated: use `envelopes_queue_primary_listen_connection_string` instead
output "queue_primary_listen_connection_string" {
  sensitive = true
  value     = module.envelopes-queue.primary_listen_connection_string
}

output "envelopes_queue_primary_listen_connection_string" {
  sensitive = true
  value     = module.envelopes-queue.primary_listen_connection_string
}

# Deprecated: use `envelopes_queue_primary_send_connection_string` instead
output "queue_primary_send_connection_string" {
  sensitive = true
  value     = module.envelopes-queue.primary_send_connection_string
}

output "envelopes_queue_primary_send_connection_string" {
  sensitive = true
  value     = module.envelopes-queue.primary_send_connection_string
}

output "processed_envelopes_queue_primary_listen_connection_string" {
  sensitive = true
  value     = module.processed-envelopes-queue.primary_listen_connection_string
}

output "processed_envelopes_queue_primary_send_connection_string" {
  sensitive = true
  value     = module.processed-envelopes-queue.primary_send_connection_string
}

output "envelopes_queue_max_delivery_count" {
  sensitive = true
  value     = var.envelope_queue_max_delivery_count
}
