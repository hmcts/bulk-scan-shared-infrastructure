module "queue-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "envelopes"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT1H"
  lock_duration                           = "PT5M"
  max_delivery_count                      = "${var.envelope_queue_delivery_count}"
}

module "notifications-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "notifications"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
  max_delivery_count  = "${var.notification_queue_delivery_count}"
}

module "processed-envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "processed-envelopes"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
}

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "envelopes_queue_send_conn_str" {
  name      = "envelopes-queue-send-connection-string"
  value     = "${module.envelopes-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_conn_str" {
  name      = "envelopes-queue-listen-connection-string"
  value     = "${module.envelopes-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "envelopes_queue_max_delivery_count" {
  name      = "envelopes-queue-max-delivery-count"
  value     = "${var.envelope_queue_delivery_count}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "notifications_queue_send_conn_str" {
  name      = "notifications-queue-send-connection-string"
  value     = "${module.notifications-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "notifications_queue_listen_conn_str" {
  name      = "notifications-queue-listen-connection-string"
  value     = "${module.notifications-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_conn_str" {
  name      = "processed-envelopes-queue-send-connection-string"
  value     = "${module.processed-envelopes-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_conn_str" {
  name      = "processed-envelopes-queue-listen-connection-string"
  value     = "${module.processed-envelopes-queue.primary_listen_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}
# endregion

# deprecated, use `envelopes_queue_primary_listen_connection_string` instead
output "queue_primary_listen_connection_string" {
  value = "${module.envelopes-queue.primary_listen_connection_string}"
}

output "envelopes_queue_primary_listen_connection_string" {
  value = "${module.envelopes-queue.primary_listen_connection_string}"
}

# deprecated, use `envelopes_queue_primary_send_connection_string` instead
output "queue_primary_send_connection_string" {
  value = "${module.envelopes-queue.primary_send_connection_string}"
}

output "envelopes_queue_primary_send_connection_string" {
  value = "${module.envelopes-queue.primary_send_connection_string}"
}

output "notifications_queue_primary_listen_connection_string" {
  value = "${module.notifications-queue.primary_listen_connection_string}"
}

output "notifications_queue_primary_send_connection_string" {
  value = "${module.notifications-queue.primary_send_connection_string}"
}

output "processed_envelopes_queue_primary_listen_connection_string" {
  value = "${module.processed-envelopes-queue.primary_listen_connection_string}"
}

output "processed_envelopes_queue_primary_send_connection_string" {
  value = "${module.processed-envelopes-queue.primary_send_connection_string}"
}

output "envelopes_queue_max_delivery_count" {
  value = "${var.envelope_queue_delivery_count}"
}
