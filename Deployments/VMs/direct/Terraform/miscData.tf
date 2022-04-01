data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "random_string" "random" {
  length = 8
  special = false
  upper = false
}
