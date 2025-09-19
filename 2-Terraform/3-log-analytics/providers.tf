terraform {
  required_version = ">= 1.9.8"
  backend "azurerm" {
    resource_group_name  = "rg-devopsthehardway"
    storage_account_name = "sadevopshardwaysa"
    container_name       = "tfstate"
    key                  = "la-terraform.tfstate"
    use_azuread_auth = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.28.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "0048e322-32a4-4cea-9722-71bb5918a734"
}