module "queue-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${local.tags}"
}

module "envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "envelopes"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = "${var.envelope_queue_max_delivery_count}"
}

module "processed-envelopes-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "processed-envelopes"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
}

module "payments-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "payments"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  lock_duration       = "PT5M"
  max_delivery_count  = "${var.payment_queue_max_delivery_count}"

  duplicate_detection_history_time_window = "PT15M"
}

# region shared access keys

resource "azurerm_key_vault_secret" "envelopes_queue_send_access_key" {
  name      = "envelopes-queue-send-shared-access-key"
  value     = "${module.envelopes-queue.primary_send_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "envelopes_queue_listen_access_key" {
  name      = "envelopes-queue-listen-shared-access-key"
  value     = "${module.envelopes-queue.primary_listen_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_send_access_key" {
  name      = "processed-envelopes-queue-send-shared-access-key"
  value     = "${module.processed-envelopes-queue.primary_send_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "processed_envelopes_queue_listen_access_key" {
  name      = "processed-envelopes-queue-listen-shared-access-key"
  value     = "${module.processed-envelopes-queue.primary_listen_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}


resource "azurerm_key_vault_secret" "payments_queue_send_access_key" {
  name      = "payments-queue-send-shared-access-key"
  value     = "${module.payments-queue.primary_send_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "payments_queue_listen_access_key" {
  name      = "payments-queue-listen-shared-access-key"
  value     = "${module.payments-queue.primary_listen_shared_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

# endregion

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
  value     = "${var.envelope_queue_max_delivery_count}"
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


resource "azurerm_key_vault_secret" "payments_queue_send_conn_str" {
  name      = "payments-queue-send-connection-string"
  value     = "${module.payments-queue.primary_send_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "payments_queue_listen_conn_str" {
  name      = "payments-queue-listen-connection-string"
  value     = "${module.payments-queue.primary_listen_connection_string}"
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

output "processed_envelopes_queue_primary_listen_connection_string" {
  value = "${module.processed-envelopes-queue.primary_listen_connection_string}"
}

output "processed_envelopes_queue_primary_send_connection_string" {
  value = "${module.processed-envelopes-queue.primary_send_connection_string}"
}

output "envelopes_queue_max_delivery_count" {
  value = "${var.envelope_queue_max_delivery_count}"
}
