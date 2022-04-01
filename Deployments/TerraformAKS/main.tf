terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
