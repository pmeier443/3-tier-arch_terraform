variable "location" {
  type        = string
}

variable "name" {
  type        = string
}
variable "subscription" {
  type        = string
}

#####
variable "backend_image" {
  type        = string
}

variable "database_ip" {
  type        = string
}
variable "backend_port" {
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

variable "database_type" {
  type        = string
}

variable "delegated_subnet_02_id" {
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