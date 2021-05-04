variable "username" {
  type        = string
  default     = ""
  description = "Database username"
}

variable "password" {
  type        = string
  default     = ""
  description = "Database password"
}

variable "name" {
  type        = string
  default     = ""
  description = "Database name"
}

variable "storage_size" {
  type        = number
  default     = 10
  description = "Database storage size"
}

variable "port" {
  type        = number
  default     = 5432
  description = "Database port"
}

variable "public_subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id"
}
