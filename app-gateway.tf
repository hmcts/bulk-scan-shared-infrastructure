data "azurerm_key_vault" "infra_vault" {
  name = "infra-vault-${var.subscription}"
  resource_group_name = "${var.env == "prod" ? "core-infra-prod" : "cnp-core-infra"}"
}

data "azurerm_key_vault_secret" "cert" {
  name      = "${var.external_cert_name}"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

data "azurerm_key_vault_secret" "allowed_external_ips" {
  name      = "external-ip"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

data "azurerm_key_vault_secret" "allowed_internal_ips" {
  name      = "vpn-ip"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

module "appGw" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=master"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}"
  resourcegroupname = "${azurerm_resource_group.rg.name}"
  common_tags       = "${var.common_tags}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_b.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.external_cert_name}"
      data     = "${data.azurerm_key_vault_secret.cert.value}"
      password = ""
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.external_cert_name}"
      hostName                = "${var.external_hostname}"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-${var.env}"

      backendAddresses = "${module.palo_alto.untrusted_ips_ip_address}"
    },
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "False"
      HostName                       = "${var.external_hostname}"
    },
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                = "https"
      RuleType            = "Basic"
      httpListener        = "https-listener"
      backendAddressPool  = "${var.product}-${var.env}"
      backendHttpSettings = "backend"
    },
  ]

  probes = [
    {
      name                                = "http-probe"
      protocol                            = "Http"
      path                                = "/"
      interval                            = 30
      timeout                             = 30
      unhealthyThreshold                  = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend"
      host                                = "${var.external_hostname}"
      healthyStatusCodes                  = "200-404"                  // MS returns 400 on /, allowing more codes in case they change it
    },
  ]
}
  
resource "azure_security_group" "bulkscan" {
  name     = "bulk-scan-nsg-${var.env}"
  resource_group_name = "core-infra-${var.env}"
  location = "${var.location}"
  
  security_rule {
    name                       = "allow-inbound-https-external"
    type                       = "Inbound"
    action                     = "Allow"
    priority                   = 100
    source_address_prefix      = "${data.azurerm_key_vault_secret.allowed_external_ips.value}"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    protocol                   = "TCP"    
  }
  
  security_rule {
    name                       = "allow-inbound-https-internal"
    type                       = "Inbound"
    action                     = "Allow"
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
