variable "RDS_USERNAME" {
  type        = string
  default     = "devopsapp"
}

variable "RDS_PASSWORD" {
  type        = string
  default     = "devopsapp"
  description = "Must be greater than 8 characters"
}

variable "RDS_PORT" {
  type        = number
  default     = 5432
}

variable "RDS_DB_NAME" {
  type        = string
  default     = "devopsapp"
}

variable "DOCKER_IMAGE" {
  type        = string
  default     = "jasoncarneiro/devops-app:latest"
}

variable "REGION" {
  type        = string
  default     = "us-east-1"
}
