resource "azurerm_virtual_network" "storage_vnet" {
  name                = "${local.account_name}-vnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["${var.storage_vnet_cidr}"]

  subnet {
    name           = "scan-storage"
    address_prefix = "${var.storage_subnet_cidr}"
  }
}

resource "azurerm_template_deployment" "private_endpoint" {
  name                = "${local.account_name}-endpoint"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}-endpoint"
    endpoint_location   = "${azurerm_resource_group.rg.location}"
    subnet_id           = "${azurerm_virtual_network.storage_vnet.scan-storage.id}"
    storageaccount_id   = "${azurerm_storage_account.storage_account.id}" 
    storageaccount_fqdn = "${azurerm_storage_account.storage_account.primary_blob_endpoint }"
  }

  deployment_mode = "Incremental"
}
