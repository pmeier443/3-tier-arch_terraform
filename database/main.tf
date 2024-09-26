resource "azurerm_resource_group" "database" {
  name = "rg-db-${var.name}"
  location = var.location
}

resource "azurerm_container_group" "database" {
  resource_group_name = azurerm_resource_group.database.name
  location            = var.location
  name                = "${var.database_name}-cg"
  os_type             = "Linux"
  restart_policy      = "Never"
  ip_address_type     = "Private"
  subnet_ids          = [var.delegated_subnet_03_id]
  depends_on = [
    var.delegated_subnet_03_id,
    ]
  container {
    cpu = 1
    environment_variables = {
      PGDATA      = var.database_data
      POSTGRES_DB = var.database_name
    }
    image  = var.database_image
    memory = 2
    name   = var.database_name
    secure_environment_variables = {
      POSTGRES_PASSWORD = var.database_password
      POSTGRES_USER     = var.database_user
    }
    ports {
      port = 5432
      protocol = "TCP"
    }
    volume {
      name       = "database"
      mount_path = var.database_data
      read_only  = false
      share_name = var.storage_share_db
      storage_account_name = var.storage_account_name_db
      storage_account_key  = var.storage_account_key_db
    }
  }
  
  image_registry_credential {
    server   = var.image_registry_server
    username = var.image_registry_username
    password = var.image_registry_password
  }
}