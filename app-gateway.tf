data "azurerm_key_vault" "infra_vault" {
  name = "infra-vault-${var.subscription}"
  resource_group_name = var.env == "prod" ? "core-infra-prod" : "cnp-core-infra"
}

data "azurerm_key_vault_secret" "cert" {
  name      = var.external_cert_name
  key_vault_id = data.azurerm_key_vault.infra_vault.id
}
