locals {
  staging_account_name      = "${replace("${var.product}${var.env}", "-", "")}staging"
}

resource "azurerm_storage_account" "storage_staging_account" {
  name                = "${local.staging_account_name}"
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

resource "azurerm_storage_container" "service_staging_containers" {
  name                 = "${local.client_service_names[count.index]}"
  resource_group_name  = "${azurerm_storage_account.storage_staging_account.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_staging_account.name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_storage_container" "service_staging_rejected_containers" {
  name                 = "${local.client_service_names[count.index]}-rejected"
  resource_group_name  = "${azurerm_storage_account.storage_staging_account.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_staging_account.name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_key_vault_secret" "storage_staging_account_name" {
  name      = "storage-staging-account-name"
  value     = "${azurerm_storage_account.storage_staging_account.name}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "storage_staging_account_primary_key" {
  name      = "storage-staging-account-primary-key"
  value     = "${azurerm_storage_account.storage_staging_account.primary_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

# this secret is used by blob-router-service for uploading blobs
resource "azurerm_key_vault_secret" "storage_staging_account_connection_string" {
  name      = "storage-staging-account-connection-string"
  value     = "${azurerm_storage_account.storage_staging_account.primary_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}
