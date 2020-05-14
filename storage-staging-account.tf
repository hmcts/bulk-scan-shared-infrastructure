locals {
  account_name_stg         = "${replace("${var.product}${var.env}", "-", "")}staging"
  mgmt_network_name_stg    = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name_stg = "aks-infra-cftptl-intsvc-rg"

  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names_stg = ["bulkscan", "sscs", "divorce", "probate", "finrem", "cmc"]
}

resource "azurerm_storage_account" "storage_account_staging" {
  name                = "${local.account_name_stg}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

  custom_domain {
    name          = "${var.external_hostname}"
    use_subdomain = "false"
  }

  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}", "${data.azurerm_subnet.jenkins_subnet.id}"]
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }

  tags = "${local.tags}"
}

resource "azurerm_storage_container" "service_containers_stg" {
  name                 = "${local.client_service_names_stg[count.index]}"
  resource_group_name  = "${azurerm_storage_account.storage_account_staging.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_account_staging.name}"
  count                = "${length(local.client_service_names_stg)}"
}

resource "azurerm_storage_container" "service_rejected_containers_stg" {
  name                 = "${local.client_service_names_stg[count.index]}-rejected"
  resource_group_name  = "${azurerm_storage_account.storage_account_staging.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_account_staging.name}"
  count                = "${length(local.client_service_names_stg)}"
}

resource "azurerm_key_vault_secret" "storage_account_staging_name" {
  name      = "storage-staging-account-name"
  value     = "${azurerm_storage_account.storage_account_staging.name}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "storage_account_staging_primary_key" {
  name      = "storage-staging-account-primary-key"
  value     = "${azurerm_storage_account.storage_account_staging.primary_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

# this secret is used by blob-router-service for uploading blobs
resource "azurerm_key_vault_secret" "storage_account_staging_connection_string" {
  name      = "storage-staging-account-connection-string"
  value     = "${azurerm_storage_account.storage_account_staging.primary_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}
