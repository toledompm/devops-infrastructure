variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
}

variable "docker_image" {
  type        = string
}
