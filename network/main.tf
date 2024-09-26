#NETWORK
resource "azurerm_resource_group" "vnet" {
  name = "rg-vnet-${var.name}"
  location = var.location
}

#VNET + SUBNET + Subnet_NSG Association
resource "azurerm_virtual_network" "vnet" {
    name = "${var.name}_network"
    resource_group_name = azurerm_resource_group.vnet.name
    location = var.location
    address_space = [ "192.168.0.0/16" ]
}

resource "azurerm_subnet" "subnet_01" {
        name = "${var.name}_subnet_01"
        resource_group_name = azurerm_resource_group.vnet.name
        virtual_network_name = azurerm_virtual_network.vnet.name
        address_prefixes = ["192.168.1.0/24"]
        delegation {
    name = "${var.name}_subnet_01-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [
    var.backend_ip,
  ]
}
resource "azurerm_subnet_network_security_group_association" "subnet_01" {
  subnet_id                 = azurerm_subnet.subnet_01.id
  network_security_group_id = azurerm_network_security_group.subnet_01.id
}
        
resource "azurerm_subnet" "subnet_02" {
        name = "${var.name}_subnet_02"
        resource_group_name = azurerm_resource_group.vnet.name
        virtual_network_name = azurerm_virtual_network.vnet.name
        address_prefixes = ["192.168.2.0/24"]
        delegation {
    name = "${var.name}_subnet_02-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [
    var.database_ip,
  ]
}
resource "azurerm_subnet_network_security_group_association" "subnet_02" {
  subnet_id                 = azurerm_subnet.subnet_02.id
  network_security_group_id = azurerm_network_security_group.subnet_02.id
}


resource "azurerm_subnet" "subnet_03"  {
        name = "${var.name}_subnet_03"
        address_prefixes = ["192.168.3.0/24"]
        resource_group_name = azurerm_resource_group.vnet.name
        virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "${var.name}_subnet_03-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
  resource "azurerm_subnet_network_security_group_association" "subnet_03" {
  subnet_id                 = azurerm_subnet.subnet_03.id
  network_security_group_id = azurerm_network_security_group.subnet_03.id
}

#NETWORK SECURITY GROUPS
resource "azurerm_network_security_group" "subnet_03" {
    name = "${var.name}_nsg_subnet_03"
    location = var.location
    resource_group_name = azurerm_resource_group.vnet.name
    
  
  security_rule  {
    name = "${var.name}-security-rules-subnet_03"
    priority = "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_ranges = ["5432"]
    source_address_prefix = "192.168.2.0/24"
    destination_address_prefix = "192.168.3.0/24"
    

  }
}
resource "azurerm_network_security_group" "subnet_02" {
    name = "${var.name}_nsg_subnet_02"
    location = var.location
    resource_group_name = azurerm_resource_group.vnet.name
  
  security_rule  {
    name = "${var.name}-security-rules-subnet_02"
    priority = "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_ranges = ["8082"]
    source_address_prefix = "192.168.1.0/24"
    destination_address_prefix = "192.168.2.0/24"

  }
}
resource "azurerm_network_security_group" "subnet_01" {
    name = "${var.name}_nsg_subnet_01"
    location = var.location
    resource_group_name = azurerm_resource_group.vnet.name
  
  security_rule  {
    name = "${var.name}-security-rules-subnet_01"
    priority = "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_ranges = ["443", "80"]
    source_address_prefix = "*"
    destination_address_prefix = "192.168.1.0/24"

  }
}

## AZURE Loadbalancer für public access in die private vnets
resource "azurerm_lb" "loadbalancer" {
  location            = var.location
  name                = "${var.name}-lb"
  resource_group_name = azurerm_resource_group.vnet.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name = "${var.name}-fe-ip"
    public_ip_address_id = azurerm_public_ip.loadbalancer.id 
  }
  depends_on = [
    var.frontend_ip,
  ]
}
resource "azurerm_public_ip" "loadbalancer" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-lb-ip"
  resource_group_name = azurerm_resource_group.vnet.name
  sku                 = "Standard"
  domain_name_label   = var.name
  zones = ["1", "2", "3"]
}
resource "azurerm_lb_backend_address_pool" "loadbalancer" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "${var.name}-lb-be-ip-pool"
}
resource "azurerm_lb_backend_address_pool_address" "loadbalancer" {
  name                    = "${var.name}-be-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.loadbalancer.id
  virtual_network_id      = azurerm_virtual_network.vnet.id
  ip_address              = var.frontend_ip
  depends_on = [
    azurerm_lb.loadbalancer,
  ]
}

resource "azurerm_lb_nat_rule" "loadbalancer" {
  backend_address_pool_id        = azurerm_lb_backend_address_pool.loadbalancer.id
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.name}-fe-ip"
  frontend_port_start            = 80
  frontend_port_end              = 80
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "${var.name}-nat"
  protocol                       = "Tcp"
  resource_group_name            = azurerm_virtual_network.vnet.name
}

#resource "azurerm_lb_rule" "loadbalancer" {
#  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.loadbalancer.id]
#  backend_port                   = 80
#  disable_outbound_snat          = true
#  frontend_ip_configuration_name = "${var.name}-fe-ip"
#  frontend_port                  = 443
#  loadbalancer_id                = azurerm_lb.loadbalancer.id
#  name                           = "${var.name}-lb-rule"
#  protocol                       = "Tcp"
#}