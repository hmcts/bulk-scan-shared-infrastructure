module "queue-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "queue" {
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

output "queue_primary_listen_connection_string" {
  value = "${module.queue.primary_listen_connection_string}"
}

output "queue_primary_send_connection_string" {
  value = "${module.queue.primary_send_connection_string}"
}

output "notification_primary_listen_connection_string" {
  value = "${module.notification-queue.primary_listen_connection_string}"
}

output "notification_primary_send_connection_string" {
  value = "${module.notification-queue.primary_send_connection_string}"
}
