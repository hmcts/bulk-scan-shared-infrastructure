module "queue-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "envelope-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "envelopes"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT1H"
}

module "notification-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "notifications"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

# deprecated, use `envelopes_queue_primary_listen_connection_string` instead
output "queue_primary_listen_connection_string" {
  value = "${module.envelope-queue.primary_listen_connection_string}"
}

output "envelopes_queue_primary_listen_connection_string" {
  value = "${module.envelope-queue.primary_listen_connection_string}"
}

# deprecated, use `envelopes_queue_primary_send_connection_string` instead
output "queue_primary_send_connection_string" {
  value = "${module.envelope-queue.primary_send_connection_string}"
}

output "envelopes_queue_primary_send_connection_string" {
  value = "${module.envelope-queue.primary_send_connection_string}"
}

output "notifications_queue_primary_listen_connection_string" {
  value = "${module.notification-queue.primary_listen_connection_string}"
}

output "notifications_queue_primary_send_connection_string" {
  value = "${module.notification-queue.primary_send_connection_string}"
}
