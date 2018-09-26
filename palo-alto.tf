module "palo_alto" {
  source  = "git@github.com:hmcts/terraform-module-palo-alto.git"
  env     = "${var.env}"
  product = "${var.product}"
  common_tags = "${var.common_tags}"

  untrusted_vnet_name           = "core-infra-vnet-${var.env}"
  untrusted_vnet_resource_group = "core-infra-${var.env}"
  untrusted_vnet_subnet_name    = "palo-untrusted-${var.env}"
  trusted_vnet_name             = "core-infra-vnet-${var.env}"
  trusted_vnet_resource_group   = "core-infra-${var.env}"
  trusted_vnet_subnet_name      = "palo-mgmt-${var.env}"
}
