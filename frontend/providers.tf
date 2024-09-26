#AZURE PROVIDER
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.108.0"
    }
  }
  #backend "azurerm" {
      #resource_group_name  = "rg-PhilippMeier-tfstate"
      #storage_account_name = "philippmeiertfstate"
      #container_name       = "tfstate"
      #key                  = "terraform.tfstate"
      #use_azuread_auth     = true
  }


provider "azurerm" {
  features {}
  subscription_id = var.subscription
}
