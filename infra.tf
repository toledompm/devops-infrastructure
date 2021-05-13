locals {
  subnet_ids = split(",", var.rds_public_subnets)
}

module "rds" {
  source           = "./modules/rds"
  username         = var.rds_username
  password         = var.rds_password
  name             = var.rds_db_name
  port             = var.rds_port
  vpc_id           = var.vpc_id
  public_subnets   = local.subnet_ids
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = var.vpc_id
  subnet_ids = local.subnet_ids
  docker_image = var.docker_image
}

module "asg" {
  source = "./modules/asg"
  vpc_id = var.vpc_id
  subnet_ids = local.subnet_ids
}
