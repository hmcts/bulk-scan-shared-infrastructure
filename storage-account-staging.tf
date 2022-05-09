#TF Infra Approvals Doesn't support count on Modules, so have to stick with this on master branch.
locals {
  external_hostname_suffix = "platform.hmcts.net"
  stripped_product_stg     = replace(var.product, "-", "")
  account_name_stg         = "${local.stripped_product_stg}${var.env}staging"
  prod_hostname_stg        = "${local.stripped_product_stg}stg.${local.external_hostname_suffix}"
  nonprod_hostname_stg     = "${local.stripped_product_stg}stg.${var.env}.${local.external_hostname_suffix}"
  external_hostname_stg    = var.env == "prod" ? local.prod_hostname_stg : local.nonprod_hostname_stg

  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names_stg = ["bulkscanauto", "bulkscan", "sscs", "divorce", "nfd", "probate", "finrem", "cmc", "publiclaw", "privatelaw"]
}

resource "azurerm_storage_account" "storage_account_staging" {
  name                = local.account_name_stg
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  allow_nested_items_to_be_public = false
  #   custom_domain {
  #     name          = "${local.external_hostname_stg}"
  #     use_subdomain = "false"
  #   }

  network_rules {
    virtual_network_subnet_ids = local.all_valid_subnets
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }

  tags = var.common_tags
}

resource "azurerm_storage_container" "service_containers_stg" {
  name                 = local.client_service_names_stg[count.index]
  storage_account_name = azurerm_storage_account.storage_account_staging.name
  count                = length(local.client_service_names_stg)
}

resource "azurerm_storage_container" "service_rejected_containers_stg" {
  name                 = "${local.client_service_names_stg[count.index]}-rejected"
  storage_account_name = azurerm_storage_account.storage_account_staging.name
  count                = length(local.client_service_names_stg)
}

resource "azurerm_key_vault_secret" "storage_account_staging_name" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-name"
  value        = azurerm_storage_account.storage_account_staging.name
}

resource "azurerm_key_vault_secret" "storage_account_staging_primary_key" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-primary-key"
  value        = azurerm_storage_account.storage_account_staging.primary_access_key
}

# this secret is used by blob-router-service for uploading blobs
resource "azurerm_key_vault_secret" "storage_account_staging_connection_string" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-connection-string"
  value        = azurerm_storage_account.storage_account_staging.primary_connection_string
}
