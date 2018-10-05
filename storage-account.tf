locals {
  account_name = "${replace("${var.product}${var.env}", "-", "")}"
}

data "azurerm_subnet" "trusted_subnet" {
  name                 = "${local.trusted_vnet_subnet_name}"
  virtual_network_name = "${local.trusted_vnet_name}"
  resource_group_name  = "${local.trusted_vnet_resource_group}"
}

resource "azurerm_storage_account" "storage_account" {
  name                = "${local.account_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

  network_rules {
    virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}"]
    bypass                     = ["Logging", "Metrics", "AzureServices"]
  }

  custom_domain {
    name          = "${var.external_hostname}"
    use_subdomain = false
  }

  tags = "${local.tags}"
}

// Can't create containers currently as jenkins doesn't have the service endpoint enabled
// Enabling it for jenkins would block it accessing other accounts
// so need to work on getting that rolled out
// For now containers will be created manually

//resource "azurerm_storage_container" "bulkscan_container" {
//  name                  = "bulkscan"
//  resource_group_name   = "${azurerm_storage_account.storage_account.resource_group_name}"
//  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
//}
//
//resource "azurerm_storage_container" "sscs_container" {
//  name                  = "sscs"
//  resource_group_name   = "${azurerm_storage_account.storage_account.resource_group_name}"
//  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
//}
