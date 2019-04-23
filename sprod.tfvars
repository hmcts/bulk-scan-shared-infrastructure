external_hostname = "bulkscan.sprod.platform.hmcts.net"
external_cert_name = "STAR-sprod-platform-hmcts-net"
external_cert_vault_uri = "https://infra-vault-sandbox.vault.azure.net/"

envelope_queue_max_delivery_count = "300"
notification_queue_max_delivery_count = "288" // To retry processing the message for 24hours
