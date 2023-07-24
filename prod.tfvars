envelope_queue_max_delivery_count = "300"
payment_queue_max_delivery_count  = "300"

managed_identity_object_id = "cf7ac491-41a9-4d94-8a0d-eab17a806415"
aks_subscription_id        = "8cbc6f36-7c56-4963-9d36-739db5d00b27"

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
envelopes_queue_send_region_name = "envelopes-queue-send-connection-string-premium"
envelopes_queue_listen_region_name = "envelopes-queue-listen-connection-string-premium"
envelopes_queue_max_delivery_count_region_name = "envelopes-queue-max-delivery-count-premium"
processed_envelopes_queue_send_region_name = "processed-envelopes-queue-send-connection-string-premium"
processed_envelopes_queue_listen_region_name = "processed-envelopes-queue-listen-connection-string-premium"
payments_queue_send_region_name = "payments-queue-send-connection-string-premium"
payments_queue_listen_region_name = "payments-queue-listen-connection-string-premium"