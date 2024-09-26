#AZURE PROVIDER
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.108.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-tfstate-speedtest"
      storage_account_name = "speedteststgaccttfstate"
      container_name       = "speedtesttfstatestgcont"
      key                  = "terraformstate"
  }  
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription
}

