resource "azurerm_resource_group" "backend" {
  name = "rg-be-${var.name}"
  location = var.location
}

resource "azurerm_container_group" "backend" {
  name                = "${var.name}-cg-backend"
  location            = var.location
  resource_group_name = azurerm_resource_group.backend.name
  os_type             = "Linux"
  restart_policy      = "Never"
  ip_address_type     = "Private"
  subnet_ids          = [var.delegated_subnet_02_id]

  container {
    name   = "${var.name}-backend"
    image  = var.backend_image
    cpu    = 1
    memory = 2

    ports {
      port     = var.backend_port
      protocol = "TCP"
    }

    environment_variables = {
      DB_TYPE     = var.database_type
      DB_HOSTNAME = var.database_ip
      DB_NAME     = var.database_name
      WEBPORT     = var.backend_port
    }
  
    secure_environment_variables = {
      DB_USERNAME     = var.database_user
      DB_PASSWORD     = var.database_password
    }
  }
  image_registry_credential {
    server   = var.image_registry_server
    username = var.image_registry_username
    password = var.image_registry_password
  }
  depends_on = [
    var.delegated_subnet_02_id,
  ]
}