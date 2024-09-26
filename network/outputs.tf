output "subnet_01_id" {
  value = azurerm_subnet.subnet_01.id
}
output "subnet_02_id" {
  value = azurerm_subnet.subnet_02.id
}
output "subnet_03_id" {
  value = azurerm_subnet.subnet_03.id
}
output "public_ip" {
  value = azurerm_public_ip.loadbalancer.ip_address
}
output "public_dns" {
  value = azurerm_public_ip.loadbalancer.fqdn
}

