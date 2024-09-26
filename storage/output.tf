output "storage_resource_group" {
    value = azurerm_resource_group.storage.name
}

output "storage_account_name_db" {
    value = azurerm_storage_account.database.name 
}
output "storage_account_key_db" {
    value = azurerm_storage_account.database.primary_access_key
    sensitive = true
}
output "storage_share_db" {
    value = azurerm_storage_share.database.name
}