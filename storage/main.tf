##Provider
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

## RESOURCES
resource "azurerm_resource_group" "storage" {
  name     = "rg-stg-${var.name}"
  location = var.location
}

resource "azurerm_storage_account" "database" {
  name                     = "${var.name}stgacctdb"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled = true
  min_tls_version           = "TLS1_2"

}
resource "azurerm_storage_share" "database" {
  name                  = "${var.name}dbstgcont"
  storage_account_name  = azurerm_storage_account.database.name
  quota                 = 100
}