## Create Resource Group
resource "azurerm_resource_group" "frontend" {
  name = "rg-fe-${var.name}"
  location = var.location
}

resource "azurerm_container_group" "frontend" {
  name                = "${var.name}-cg-frontend"
  location            = var.location
  resource_group_name = azurerm_resource_group.frontend.name
  os_type             = "Linux"
  restart_policy      = "Never"
  ip_address_type     = "Private"
  subnet_ids          = [var.delegated_subnet_01_id]

  container {
    name   = "${var.name}-frontend"
    image  = var.frontend_image
    cpu    = 1
    memory = 2

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      BACKEND_HOST = "http://${var.backend_ip}:${var.backend_port}"
    }
  }
  image_registry_credential {
    server   = var.image_registry_server
    username = var.image_registry_username
    password = var.image_registry_password
  }
}
