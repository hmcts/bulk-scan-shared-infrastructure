provider "azurerm" {
  alias                           = "mgmt"
  subscription_id                 = var.mgmt_subscription_id
  skip_provider_registration      = true
  features {}
}

locals {
  account_name = replace("${var.product}${var.env}", "-", "")

  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names = ["bulkscanauto", "bulkscan", "sscs", "divorce", "nfd", "probate", "finrem", "cmc", "publiclaw", "privatelaw", "adoption", "sscs-ibca"]

  resourcegroup_name = azurerm_resource_group.rg.name

  valid_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.jenkins_aks_00.id,
    data.azurerm_subnet.jenkins_aks_01.id,
    data.azurerm_subnet.app_aks_00_subnet.id,
    data.azurerm_subnet.app_aks_01_subnet.id,
  ]
  preview_subnets = var.env == "aat" ? [data.azurerm_subnet.preview_aks_00_subnet.id, data.azurerm_subnet.preview_aks_01_subnet.id] : []

  all_valid_subnets = concat(local.valid_subnets, local.preview_subnets)

}

resource "azurerm_storage_account" "storage_account" {
  name                = local.account_name
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  allow_nested_items_to_be_public = false
  #   custom_domain {
  #     name          = "${var.external_hostname}"
  #     use_subdomain = "false"
  #   }

  network_rules {
    virtual_network_subnet_ids = local.all_valid_subnets
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }

  tags = var.common_tags
}

resource "azurerm_storage_container" "service_containers" {
  name                 = local.client_service_names[count.index]
  storage_account_name = azurerm_storage_account.storage_account.name
  count                = length(local.client_service_names)
}

resource "azurerm_storage_container" "service_rejected_containers" {
  name                 = "${local.client_service_names[count.index]}-rejected"
  storage_account_name = azurerm_storage_account.storage_account.name
  count                = length(local.client_service_names)
}

resource "azurerm_key_vault_secret" "storage_account_name" {
  name         = "storage-account-name"
  value        = azurerm_storage_account.storage_account.name
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "storage_account_primary_key" {
  name         = "storage-account-primary-key"
  value        = azurerm_storage_account.storage_account.primary_access_key
  key_vault_id = module.vault.key_vault_id
}

# this secret is used by blob-router-service for uploading blobs
resource "azurerm_key_vault_secret" "storage_account_connection_string" {
  name         = "storage-account-connection-string"
  value        = azurerm_storage_account.storage_account.primary_connection_string
  key_vault_id = module.vault.key_vault_id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_primary_key" {
  sensitive = true
  value     = azurerm_storage_account.storage_account.primary_access_key
}
