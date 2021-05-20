locals {
  subnet_ids = [
    module.network.public_subnet_a,
    module.network.public_subnet_b,
    module.network.private_subnet_a,
    module.network.private_subnet_b
  ]
  vpc_id = module.network.vpc_id
}

module "network" {
  source                      = "./modules/network"
  cidr_block                  = "10.0.0.0/16"
  public_subnet_a_cidr_block  = "10.0.1.0/24"
  public_subnet_b_cidr_block  = "10.0.2.0/24"
  private_subnet_a_cidr_block = "10.0.3.0/24"
  private_subnet_b_cidr_block = "10.0.4.0/24"
  region                      = "us-east-1"
}

module "rds" {
  source           = "./modules/rds"
  username         = var.rds_username
  password         = var.rds_password
  name             = var.rds_db_name
  port             = var.rds_port
  vpc_id           = local.vpc_id
  public_subnets   = [local.subnet_ids[2], local.subnet_ids[3]]
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = local.vpc_id
  subnet_ids = [local.subnet_ids[0], local.subnet_ids[1]]
  docker_image = var.docker_image
}

module "asg" {
  source = "./modules/asg"
  vpc_id = local.vpc_id
  subnet_ids = [local.subnet_ids[0], local.subnet_ids[1]]
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = "devops-infraestructure"
}
