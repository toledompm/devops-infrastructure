variable "rds_public_subnets" {
  type        = string
}

variable "rds_username" {
  type        = string
  default     = ""
}

variable "rds_password" {
  type        = string
  description = "Must be greater than 8 characters"
}

variable "rds_port" {
  type        = number
  default     = 5432
}

variable "rds_db_name" {
  type        = string
  default     = ""
}

variable "vpc_id" {
  type = string
}
