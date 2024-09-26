output "Speedtest-IP" {
    value = module.vnet.public_ip 
}
output "Speedtest-FQDN" {
    value = module.vnet.public_dns
}