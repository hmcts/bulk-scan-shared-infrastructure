managed_identity_object_id = "bc0fc140-dfae-45f2-9e0e-2065173f51a3"
aks_subscription_id        = "d025fece-ce99-4df2-b7a9-b649d3ff2060"

# At present, demo is configured to values.yaml which uses premium azure service buses
sku_service_bus = "Premium"
zone_redundant_service_bus = true
duplicate_detection_history_time_window_service_bus = "PT15M"
requires_duplicate_service_bus = true

# Region names
envelopes_queue_send_name = "envelopes-queue-send-shared-access-key-premium"
envelopes_queue_listen_name = "envelopes-queue-listen-shared-access-key-premium"
processed_envelopes_queue_send_name = "processed-envelopes-queue-send-shared-access-key-premium"
processed_envelopes_queue_listen_name = "processed-envelopes-queue-listen-shared-access-key-premium"
payments_queue_send_name = "payments-queue-send-shared-access-key-premium"
payments_queue_listen_name = "payments-queue-listen-shared-access-key-premium"

# region connection strings and other shared queue information as Key Vault secrets
envelopes_queue_send_resource_name = "envelopes-queue-send-connection-string-premium"
envelopes_queue_listen_resource_name = "envelopes-queue-listen-connection-string-premium"
envelopes_queue_max_delivery_count_resource_name = "envelopes-queue-max-delivery-count-premium"
processed_envelopes_queue_send_resource_name = "processed-envelopes-queue-send-connection-string-premium"
processed_envelopes_queue_listen_resource_name = "processed-envelopes-queue-listen-connection-string-premium"
payments_queue_send_resource_name = "payments-queue-send-connection-string-premium"
payments_queue_listen_resource_name = "payments-queue-listen-connection-string-premium"