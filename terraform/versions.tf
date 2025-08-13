terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.39.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}