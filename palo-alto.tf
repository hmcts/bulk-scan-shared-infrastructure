module "palo_alto" {
  source  = "git@github.com:hmcts/terraform-module-palo-alto.git"
  env     = "${var.env}"
  product = "${var.product}"

  untrusted_vnet_name           = "core-infra-vnet-sandbox"
  untrusted_vnet_resource_group = "core-infra-sandbox"
  untrusted_vnet_subnet_name    = "core-infra-subnet-0-sandbox"
  trusted_vnet_name             = "core-infra-vnet-sandbox"
  trusted_vnet_resource_group   = "core-infra-sandbox"
  trusted_vnet_subnet_name      = "palo-mgmt-sandbox"
}
