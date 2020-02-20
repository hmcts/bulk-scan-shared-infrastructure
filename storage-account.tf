provider "azurerm" {
  alias           = "mgmt"
  subscription_id = "${var.mgmt_subscription_id}"
  version         = "=1.33.1"
}

provider "azurerm" {
  alias  = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

provider "azurerm" {
  alias  = "cftapps-prod"
  subscription_id = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
}

provider "azurerm" {
  alias  = "cftapps-stg"
  subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
}

provider "azurerm" {
  alias  = "cftapps-sbox"
  subscription_id = "b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb"
}

locals {
  account_name      = "${replace("${var.product}${var.env}", "-", "")}"
  mgmt_network_name = "${var.subscription == "prod" || var.subscription == "nonprod" ? "mgmt-infra-prod" : "mgmt-infra-sandbox"}"
  aks_network_name = "${var.subscription == "prod" || var.subscription == "nonprod" ? "core-prod-vnet" : "core-aat-vnet"}"
  aks_resource_group = "${var.subscription == "prod" || var.subscription == "nonprod" ? "aks-infra-prod-rg" : "aks-infra-aat-rg"}"

  prod_virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}", "${data.azurerm_subnet.jenkins_subnet.id}", "${data.azurerm_subnet.aks00_subnet_prod.id}", "${data.azurerm_subnet.aks01_subnet_prod.id}"]
  stg_virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}", "${data.azurerm_subnet.jenkins_subnet.id}", "${data.azurerm_subnet.aks00_subnet_stg.id}", "${data.azurerm_subnet.aks01_subnet_stg.id}"]
  sbox_virtual_network_subnet_ids = ["${data.azurerm_subnet.trusted_subnet.id}", "${data.azurerm_subnet.jenkins_subnet.id}", "${data.azurerm_subnet.aks00_subnet_sbox.id}", "${data.azurerm_subnet.aks01_subnet_sbox.id}"]
  
  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by bulk-scan
  client_service_names = ["bulkscan", "sscs", "divorce", "probate", "finrem", "cmc"]
}

data "azurerm_subnet" "trusted_subnet" {
  name                 = "${local.trusted_vnet_subnet_name}"
  virtual_network_name = "${local.trusted_vnet_name}"
  resource_group_name  = "${local.trusted_vnet_resource_group}"
}

data "azurerm_subnet" "aks00_subnet_prod" {
  provider             = "azurerm.cftapps-prod"
  name                 = "aks-00"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
}
    
data "azurerm_subnet" "aks01_subnet_prod" {
  provider             = "azurerm.cftapps-prod"
  name                 = "aks-01"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
} 
data "azurerm_subnet" "aks00_subnet_stg" {
  provider             = "azurerm.cftapps-stg"
  name                 = "aks-00"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
}
    
data "azurerm_subnet" "aks01_subnet_stg" {
  provider             = "azurerm.cftapps-stg"
  name                 = "aks-01"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
}

data "azurerm_subnet" "aks00_subnet_sbox" {
  provider             = "azurerm.cftapps-sbox"
  name                 = "aks-00"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
}
    
data "azurerm_subnet" "aks01_subnet_sbox" {
  provider             = "azurerm.cftapps-prod"
  name                 = "aks-01"
  virtual_network_name = "${local.aks_network_name}"
  resource_group_name  = "${local.aks_resource_group}"
}     
    
data "azurerm_subnet" "jenkins_subnet" {
  provider             = "azurerm.mgmt"
  name                 = "jenkins-subnet"
  virtual_network_name = "${local.mgmt_network_name}"
  resource_group_name  = "${local.mgmt_network_name}"
}

resource "azurerm_storage_account" "storage_account" {
  name                = "${local.account_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"

  custom_domain {
    name          = "${var.external_hostname}"
    use_subdomain = "false"
  }

  network_rules {
    virtual_network_subnet_ids = "${var.subscription == "aat" ? local.stg_virtual_network_subnet_ids : var.subscription == "prod" ? local.prod_virtual_network_subnet_ids : local.sbox_virtual_network_subnet_ids}"
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Deny"
  }

  tags = "${local.tags}"
}

resource "azurerm_storage_container" "service_containers" {
  name                 = "${local.client_service_names[count.index]}"
  resource_group_name  = "${azurerm_storage_account.storage_account.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_account.name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_storage_container" "service_rejected_containers" {
  name                 = "${local.client_service_names[count.index]}-rejected"
  resource_group_name  = "${azurerm_storage_account.storage_account.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_account.name}"
  count                = "${length(local.client_service_names)}"
}

resource "azurerm_key_vault_secret" "storage_account_name" {
  name      = "storage-account-name"
  value     = "${azurerm_storage_account.storage_account.name}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

resource "azurerm_key_vault_secret" "storage_account_primary_key" {
  name      = "storage-account-primary-key"
  value     = "${azurerm_storage_account.storage_account.primary_access_key}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

# this secret is used by blob-router-service for uploading blobs
resource "azurerm_key_vault_secret" "storage_account_connection_string" {
  name      = "storage-account-connection-string"
  value     = "${azurerm_storage_account.storage_account.primary_connection_string}"
  vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.storage_account.name}"
}

output "storage_account_primary_key" {
  sensitive = true
  value     = "${azurerm_storage_account.storage_account.primary_access_key}"
}
