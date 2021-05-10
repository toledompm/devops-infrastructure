provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-devops-infra-fatec"
    key            = "terraform/main.tfstate"
    region         = "us-east-1"
    encrypt        = false
  }
}
