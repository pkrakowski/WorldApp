terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "~> 2.0"
    }
  }
}

provider "local" {
}
provider "random" {
}

provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {}
}