external_hostname = "bulkscan.platform.hmcts.net"
external_cert_name = "wildcard-platform-hmcts-net"
external_cert_vault_uri = "https://infra-cert-prod.vault.azure.net/"

envelope_queue_delivery_count = "300"
notification_queue_delivery_count = "288" // To retry processing the message for 24hours
