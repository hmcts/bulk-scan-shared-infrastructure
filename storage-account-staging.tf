locals {
  stripped_product_stg     = "${replace(var.product, "-", "")}"
  account_name_stg         = "${local.stripped_product_stg}${var.env}staging"
  mgmt_network_name_stg    = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name_stg = "aks-infra-cftptl-intsvc-rg"
  prod_hostname_stg        = "${local.stripped_product_stg}stg.${var.external_hostname}"
  nonprod_hostname_stg     = "${local.stripped_product_stg}.${var.env}stg.${var.external_hostname}"
  external_hostname_stg    = "${ var.env == "prod" ? local.prod_hostname_stg : local.nonprod_hostname_stg}"

  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names_stg = ["bulkscan", "sscs", "divorce", "probate", "finrem", "cmc"]
}

data "azurerm_subnet" "trusted_subnet_stg" {
  name                 = "${local.trusted_vnet_subnet_name_stg}"
  virtual_network_name = "${local.trusted_vnet_name_stg}"
  resource_group_name  = "${local.trusted_vnet_resource_group_stg}"
}

data "azurerm_subnet" "jenkins_subnet_stg" {
  provider             = "azurerm.mgmt"
  name                 = "iaas"
  virtual_network_name = "${local.mgmt_network_name_stg}"
  resource_group_name  = "${local.mgmt_network_rg_name_stg}"
}

resource "azurerm_storage_account" "storage_account_staging" {
  name                = "${local.account_name_stg}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

  custom_domain {
    name          = "${local.external_hostname_stg}"
    use_subdomain = "false"
  }

  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet_stg.id}", "${data.azurerm_subnet.jenkins_subnet_stg.id}"]
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
