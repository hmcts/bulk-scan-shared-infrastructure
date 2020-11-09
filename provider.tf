terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  alias           = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  features {}
}

provider "azurerm" {
  features {}
  alias = "aks"
  subscription_id = var.aks_subscription_id
}
