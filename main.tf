provider "azurerm" {
  version = "=1.22.1"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#rpe")
    )}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
