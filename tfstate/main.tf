terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.108.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription
}

variable "location" {
  default = "Westeurope"
}

variable "name" {
  default = "speedtest"
}

variable"subscription" {
  default = "7fae56f8-ef32-4c6a-a8c1-53be8241e468"
}

resource "azurerm_resource_group" "tfstate" {
  name = "rg-tfstate-${var.name}"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.name}stgaccttfstate"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  enable_https_traffic_only = true
  shared_access_key_enabled = true
  min_tls_version = "TLS1_2"

}
resource "azurerm_storage_container" "tfstate" {
  name                  = "${var.name}tfstatestgcont"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

output "resource_group_name" {
    value = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
    value = azurerm_storage_account.tfstate.name
}

output "container_name" {
    value = azurerm_storage_container.tfstate.name
}

  