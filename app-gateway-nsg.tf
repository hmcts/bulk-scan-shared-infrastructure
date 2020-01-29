provider "azurerm" {
  alias  = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

data "azurerm_key_vault_secret" "allowed_external_ips" {
  name      = "nsg-allowed-external-ips"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

data "azurerm_public_ip_prefix" "proxy_out_public_ip" {
  provider            = "azurerm.cft-mgmt"
  name                = "reformMgmtProxyOutPublicIP"
  resource_group_name = "reformMgmtDmzRG"
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
    source_address_prefix      = "${data.azurerm_key_vault_secret.allowed_external_ips.value}"
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
    source_address_prefix      = "${data.azurerm_key_vault_secret.allowed_internal_ips.value}"
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
