provider "aws" {
  profile = "default"
  region  = var.REGION
}

terraform {
  backend "s3" {
    bucket               = "terraform-devops-infra-fatec"
    key                  = "main.tfstate"
    workspace_key_prefix = "terraform"
    region               = "us-east-1"
    encrypt              = false
  }
}
