provider "azurerm" {
  version = "=1.33.1"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#rpe")
    )}"
  common_tags = {
    team_name    = "Bulk scan"
    team_contact = "#rbs"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
