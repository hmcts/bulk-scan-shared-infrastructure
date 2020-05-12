module "queue-staging-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "envelopes-staging-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "envelopes"
  namespace_name      = "${module.queue-staging-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = "${var.envelope_queue_max_delivery_count}"
}

module "processed-envelopes-staging-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "processed-envelopes"
  namespace_name      = "${module.queue-staging-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
}

module "payments-staging-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "payments"
  namespace_name      = "${module.queue-staging-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
  max_delivery_count  = "${var.payment_queue_max_delivery_count}"

  duplicate_detection_history_time_window = "PT15M"
}

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "envelopes_queue_staging_send_conn_str" {
  name      = "envelopes-staging-queue-send-connection-string"
  value     = "${module.envelopes-staging-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_conn_str" {
  name      = "envelopes-staging-queue-listen-connection-string"
  value     = "${module.envelopes-staging-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "envelopes_staging_queue_max_delivery_count" {
  name      = "envelopes-staging-queue-max-delivery-count"
  value     = "${var.envelope_staging_queue_max_delivery_count}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_send_conn_str" {
  name      = "processed-envelopes-staging-queue-send-connection-string"
  value     = "${module.processed-envelopes-staging-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_staging_queue_listen_conn_str" {
  name      = "processed-envelopes-staging-queue-listen-connection-string"
  value     = "${module.processed-envelopes-staging-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "payments_staging_queue_send_conn_str" {
  name      = "payments-staging-queue-send-connection-string"
  value     = "${module.payments-staging-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "payments_staging_queue_listen_conn_str" {
  name      = "payments-staging-queue-listen-connection-string"
  value     = "${module.payments-staging-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

# endregion

output "envelopes_staging_queue_primary_listen_connection_string" {
  value = "${module.envelopes-staging-queue.primary_listen_connection_string}"
}

output "envelopes_staging_queue_primary_send_connection_string" {
  value = "${module.envelopes-staging-queue.primary_send_connection_string}"
}

output "processed_envelopes_staging_queue_primary_listen_connection_string" {
  value = "${module.processed-envelopes-staging-queue.primary_listen_connection_string}"
}

output "processed_envelopes_staging_queue_primary_send_connection_string" {
  value = "${module.processed-envelopes-staging-queue.primary_send_connection_string}"
}

output "envelopes_staging_queue_max_delivery_count" {
  value = "${var.envelope_staging_queue_max_delivery_count}"
}
