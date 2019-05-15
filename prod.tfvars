external_hostname = "bulkscan.platform.hmcts.net"
external_cert_name = "wildcard-platform-hmcts-net"

envelope_queue_max_delivery_count = "300"
notification_queue_max_delivery_count = "288" // To retry processing the message for 24hours

key_vault_id = "/subscriptions/00b9a00a-20eb-4173-b7b6-468e00836a33/resourceGroups/infra-cert-prod/providers/Microsoft.KeyVault/vaults/infra-cert-prod"