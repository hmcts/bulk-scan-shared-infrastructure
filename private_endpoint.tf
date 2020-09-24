locals {
  scan_storage_vnet_name           = "${var.env == "aat" ? "core-infra-vnet-prod" : "core-infra-vnet-${var.env}"}"
  private_endpoint_prod_aat_count  = "${var.env == "prod" || var.env == "aat" ? "1": "0"}"
  private_endpoint_non_prod_count  = "${var.env == "prod" || var.env == "aat" ? "0": "1"}"
  scan_storage_vnet_resource_group = "core-infra-${var.env}"
  scan_storage_vnet_subnet_name    = "scan-storage"
}

data "azurerm_subnet" "scan_storage_subnet" {
  name                 = "${local.scan_storage_vnet_subnet_name}"
  virtual_network_name = "${local.scan_storage_vnet_name}"
  resource_group_name  = "${local.scan_storage_vnet_resource_group}"
}

provider "azurerm" {
  alias           = "cnp-prod"
  subscription_id = "8999dec3-0104-4a27-94ee-6588559729d1"
}

resource "azurerm_template_deployment" "private_endpoint_prod_aat" {
  name                = "${local.account_name}-endpoint"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = "${local.private_endpoint_prod_aat_count}}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}-endpoint"
    endpoint_location   = "${azurerm_resource_group.rg.location}"
    subnet_id           = "${data.azurerm_subnet.scan_storage_subnet.id}"
    storageaccount_id   = "${azurerm_storage_account.storage_account.id}" 
    storageaccount_fqdn = "${azurerm_storage_account.storage_account.primary_blob_endpoint }"
  }

  deployment_mode       = "Incremental"
  provider              = "azurerm.cnp-prod"
}

resource "azurerm_template_deployment" "private_endpoint_non_prod" {
  name                = "${local.account_name}-endpoint"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = "${local.private_endpoint_non_prod_count}}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}-endpoint"
    endpoint_location   = "${azurerm_resource_group.rg.location}"
    subnet_id           = "${data.azurerm_subnet.scan_storage_subnet.id}"
    storageaccount_id   = "${azurerm_storage_account.storage_account.id}" 
    storageaccount_fqdn = "${azurerm_storage_account.storage_account.primary_blob_endpoint }"
  }

  deployment_mode = "Incremental"
}
