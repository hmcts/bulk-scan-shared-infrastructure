
provider "azurerm" {
  alias           = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  features {}
}

provider "azurerm" {
  features {}
  alias                           = "aks"
  subscription_id                 = var.aks_subscription_id
  resource_provider_registrations = "none"
}

provider "azurerm" {
  features {}
  alias           = "aks_preview"
  subscription_id = "8b6ea922-0862-443e-af15-6056e1c9b9a4"
}

provider "azurerm" {
  features {}
  alias           = "aks_prod"
  subscription_id = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
}

