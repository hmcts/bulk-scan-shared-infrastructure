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

data "azurerm_subnet" "app_aks_00_subnet_stg" {
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name_stg
  resource_group_name  = local.mgmt_network_rg_name_stg
}

data "azurerm_subnet" "app_aks_01_subnet_stg" {
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name_stg
  resource_group_name  = local.mgmt_network_rg_name_stg
}
