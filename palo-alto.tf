module "palo_alto" {
  source = "git@github.com:hmcts/terraform-module-palo-alto.git"
  env = "${var.env}"
  product = "${var.product}"
}
