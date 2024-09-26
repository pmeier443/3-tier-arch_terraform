output "resource_group_name" {
  value = azurerm_resource_group.backend.name
}

output "location" {
  value = var.location
}

output "backend_ip" {
  value = azurerm_container_group.backend.ip_address
}
