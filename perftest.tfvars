managed_identity_object_id = "518ffa1a-fb22-4e80-86ac-b1345dc54e44"
aks_subscription_id        = "8a07fdcd-6abd-48b3-ad88-ff737a4b9e3c"

sku_service_bus                                     = "Basic"
zone_redundant_service_bus                          = false
duplicate_detection_history_time_window_service_bus = "PT59M"
requires_duplicate_service_bus                      = false

# Region names
envelopes_queue_send_name             = "envelopes-queue-send-shared-access-key"
envelopes_queue_listen_name           = "envelopes-queue-listen-shared-access-key"
processed_envelopes_queue_send_name   = "processed-envelopes-queue-send-shared-access-key"
processed_envelopes_queue_listen_name = "processed-envelopes-queue-listen-shared-access-key"
payments_queue_send_name              = "payments-queue-send-shared-access-key"
payments_queue_listen_name            = "payments-queue-listen-shared-access-key"

# region connection strings and other shared queue information as Key Vault secrets
envelopes_queue_send_resource_name               = "envelopes-queue-send-connection-string"
envelopes_queue_listen_resource_name             = "envelopes-queue-listen-connection-string"
envelopes_queue_max_delivery_count_resource_name = "envelopes-queue-max-delivery-count"
processed_envelopes_queue_send_resource_name     = "processed-envelopes-queue-send-connection-string"
processed_envelopes_queue_listen_resource_name   = "processed-envelopes-queue-listen-connection-string"
payments_queue_send_resource_name                = "payments-queue-send-connection-string"
payments_queue_listen_resource_name              = "payments-queue-listen-connection-string"

# Name of ASB
azure_service_bus_name = "bulk-scan-servicebus-perftest"