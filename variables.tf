##GENERAL##
variable "location" {
  default = "Westeurope"
}

variable "name" {
  default = "speedtest"
}

variable"subscription" {
  default = ""
}

variable "image_registry_server" {
  type        = string
  default     = "philippm.azurecr.io"
}
variable "image_registry_username" {
  type        = string
  default     = "PhilippM"
}
variable "image_registry_password" {
  type        = string
  default     = ""
}

##NETWORK##
##FRONTEND##
variable "frontend_image" {
  type        = string
  default     = "philippm.azurecr.io/speedtest-proxy:1.1" 
}

##BACKEND##
variable "backend_container_name" {
  type        = string
  default     = "speedtest-standalone"
}

variable "backend_image" {
  type        = string
  default     = "philippm.azurecr.io/speedtest-standalone:1.3"
}
variable "database_type" {
  type        = string
  default     = "postgresql"
}
variable "backend_port" {
  type       = string
  default    = "8082" 
}


##DATABASE##
variable "database_image" {
  type        = string
  default     = "philippm.azurecr.io/speedtest-db-pqsql:1.3"
}

variable "database_user" {
  type        = string
  default     ="speedtest"
}

variable "database_password" {
  type        = string
  default     ="speedtest"
}

variable "database_name" {
  type        = string
  default     ="speedtest-db"
}

variable "database_data" {
  type        = string
  default     ="/var/lib/postgresql/volume/"
}



##STORAGE##

##MONITORING##
