variable "location" {
  type        = string
}

variable "name" {
  type        = string
}

variable"subscription" {
  type        = string
}

#####
variable "database_image" {
  type        = string
  
}
variable "database_user" {
  type        = string
}

variable "database_password" {
  type        = string
}

variable "database_name" {
  type        = string
}
variable "database_data" {
  type        = string
}

variable "delegated_subnet_03_id" {
  type        = string
}
variable "image_registry_server" {
  type        = string
}
variable "image_registry_username" {
  type        = string
}
variable "image_registry_password" {
  type        = string
}
variable "storage_account_name_db" {
  type = string
}
variable "storage_account_key_db" {
  type = string
}
variable "storage_share_db" {
  type = string  
}