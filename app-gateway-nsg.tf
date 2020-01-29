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
  aks_env_subscription = "${var.subscription == "aat" ? "stg" : var.subscription}"
}

data "azurerm_key_vault_secret" "allowed_external_ips" {
  name      = "nsg-allowed-external-ips"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

data "azurerm_public_ip" "proxy_out_public_ip" {
  provider            = "azurerm.cft-mgmt"
  name                = "reformMgmtProxyOutPublicIP"
  resource_group_name = "reformMgmtDmzRG"
}

data "azurerm_public_ip_prefix" "aks00_public_ip_prefix" {
  provider            = "azurerm.cftapps-${local.aks_env_subscription}"
  name                = "${var.env}-00-aks-pip"
  resource_group_name = "aks-infra-${var.env}-rg"
}

data "azurerm_public_ip_prefix" "aks01_public_ip_prefix" {
  provider            = "azurerm.cftapps-stg"
  name                = "${var.env}-01-aks-pip"
  resource_group_name = "aks-infra-${var.env}-rg"
}

resource "azurerm_network_security_group" "bulkscan" {
  name     = "bulk-scan-nsg-${var.env}"
  resource_group_name = "core-infra-${var.env}"
  location = "${var.location}"
  
  security_rule {
    name                       = "allow-inbound-https-external"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 100
    source_address_prefixes    = ["${split(",", data.azurerm_key_vault_secret.allowed_external_ips.value)}"]
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    protocol                   = "TCP"    
  }
  
  security_rule {
    name                       = "allow-inbound-https-internal"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 110
    source_address_prefix      = "["${data.azurerm_public_ip.proxy_out_public_ip.ip_address}","${data.azurerm_public_ip_prefix.aks00_public_ip_prefix.ip_prefix}","${data.azurerm_public_ip_prefix.aks01_public_ip_prefix.ip_prefix}"]"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    protocol                   = "TCP"    
  }
}
  
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = "${data.azurerm_subnet.subnet_b.id}"
  network_security_group_id = "${azurerm_network_security_group.bulkscan.id}"
}
