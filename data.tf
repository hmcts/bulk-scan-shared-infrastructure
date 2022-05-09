locals {
  mgmt_network_name    = "cft-ptl-vnet"
  mgmt_network_rg_name = "cft-ptl-network-rg"

  aks_env = var.env == "sandbox" ? "sbox" : var.env

  aat_cft_vnet_name           = "cft-aat-vnet"
  aat_cft_vnet_resource_group = "cft-aat-network-rg"

  app_aks_network_name    = "cft-${local.aks_env}-vnet"
  app_aks_network_rg_name = "cft-${local.aks_env}-network-rg"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_00" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_aks_01" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "app_aks_00_subnet" {
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}

data "azurerm_subnet" "app_aks_01_subnet" {
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}

## Delete when DTSPO-5565 is complete
data "azurerm_subnet" "arm_aks_00_subnet" {
  count                = var.env == "prod" ? 1 : 0
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = "core-${local.aks_env}-vnet"
  resource_group_name  = "aks-infra-${local.aks_env}-rg"
}

## Delete when DTSPO-5565 is complete
data "azurerm_subnet" "arm_aks_01_subnet" {
  count                = var.env == "prod" ? 1 : 0
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = "core-${local.aks_env}-vnet"
  resource_group_name  = "aks-infra-${local.aks_env}-rg"
}
