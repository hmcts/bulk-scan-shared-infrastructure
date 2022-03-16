provider "azurerm" {
  features {}
}

module "ctags" {
  source      = "git@github.com:hmcts/terraform-module-common-tags?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}

locals {
  tags = module.ctags.common_tags
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = local.tags
}
