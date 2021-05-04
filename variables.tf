variable "rds_public_subnet_id" {
  type        = string
  default     = ""
  description = "Rds subnet id"
}

variable "rds_username" {
  type        = string
  default     = ""
}

variable "rds_password" {
  type        = string
  default     = ""
}

variable "rds_port" {
  type        = number
  default     = 5432
}

variable "rds_db_name" {
  type        = string
  default     = ""
}
