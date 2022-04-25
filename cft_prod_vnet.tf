locals {
  prod_vnet_name           = "cft-prod-vnet"
  prod_vnet_resource_group = "cft-prod-network-rg"
}

data "azurerm_subnet" "prod_aks_00_subnet" {
  provider             = azurerm.aks_prod
  name                 = "aks-00"
  virtual_network_name = local.prod_vnet_name
  resource_group_name  = local.prod_vnet_resource_group
}

data "azurerm_subnet" "prod_aks_01_subnet" {
  provider             = azurerm.aks_prod
  name                 = "aks-01"
  virtual_network_name = local.prod_vnet_name
  resource_group_name  = local.prod_vnet_resource_group
}

