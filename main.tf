module "storage" {
  source = "./storage"
  name                    = var.name
  location                = var.location
  subscription            = var.subscription
}


module "vnet" {
  source = "./network"
  name                    = var.name
  location                = var.location
  subscription            = var.subscription
  frontend_ip             = module.frontend.frontend_ip
  backend_ip              = module.backend.backend_ip
  database_ip             = module.database.database_ip
}

module "frontend" {
  source = "./frontend"
  name                    = var.name
  location                = var.location
  subscription            = var.subscription
  frontend_image          = var.frontend_image
  backend_ip              = module.backend.backend_ip
  backend_port            = var.backend_port 
  delegated_subnet_01_id  = module.vnet.subnet_01_id
  image_registry_server   = var.image_registry_server
  image_registry_username = var.image_registry_username
  image_registry_password = var.image_registry_password   
}

module "backend" {
  source = "./backend"
  name                    = var.name
  location                = var.location
  subscription            = var.subscription 
  database_ip             = module.database.database_ip
  database_user           = var.database_user
  database_password       = var.database_password
  database_name           = var.database_name
  backend_image           = var.backend_image
  backend_port            = var.backend_port
  database_type           = var.database_type
  delegated_subnet_02_id  = module.vnet.subnet_02_id 
  image_registry_server   = var.image_registry_server
  image_registry_username = var.image_registry_username
  image_registry_password = var.image_registry_password 
}

module "database" {
  source = "./database"
  name                    = var.name
  location                = var.location
  subscription            = var.subscription
  database_user           = var.database_user
  database_password       = var.database_password
  database_name           = var.database_name
  delegated_subnet_03_id  = module.vnet.subnet_03_id
  database_data           = var.database_data
  database_image          = var.database_image
  image_registry_server   = var.image_registry_server
  image_registry_username = var.image_registry_username
  image_registry_password = var.image_registry_password
  storage_account_name_db = module.storage.storage_account_name_db
  storage_account_key_db  = module.storage.storage_account_key_db
  storage_share_db        = module.storage.storage_share_db 
}
