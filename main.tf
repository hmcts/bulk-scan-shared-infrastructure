provider "azurerm" {
  features {}
}

module "ctags" {
  source      = "git@github.com:hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = var.product
  builtFrom   = var.builtFrom
}

locals {
  tags = merge(
    module.ctags.common_tags,
    tomap({
      "Team Contact" = "#rbs"
      "Team Name" = "Bulk Scan"
    })
  )
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = local.tags
}
