variable "RDS_USERNAME" {
  type        = string
  default     = ""
}

variable "RDS_PASSWORD" {
  type        = string
  description = "Must be greater than 8 characters"
}

variable "RDS_PORT" {
  type        = number
  default     = 5432
}

variable "RDS_DB_NAME" {
  type        = string
  default     = ""
}

variable "DOCKER_IMAGE" {
  type = string
}

variable "REGION" {
  default = "us-east-1"
}
