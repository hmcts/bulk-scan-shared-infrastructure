managed_identity_object_id = "42401564-6dad-49ef-8ab0-1bacd15857ca"
aks_subscription_id        = "96c274ce-846d-4e48-89a7-d528432298a7"

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
azure_service_bus_name = "bulk-scan-servicebus-ithc"