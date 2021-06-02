locals {
  subnet_ids = [
    module.network[0].public_subnet_a,
    module.network[0].public_subnet_b,
    module.network[0].private_subnet_a,
    module.network[0].private_subnet_b
  ]

  vpc_id = module.network[0].vpc_id

  env = terraform.workspace
}

module "network" {
  count                       = local.environments[local.env].enable_net ? 1 : 0
  source                      = "./modules/network"
  cidr_block                  = "10.0.0.0/16"
  public_subnet_a_cidr_block  = "10.0.1.0/24"
  public_subnet_b_cidr_block  = "10.0.2.0/24"
  private_subnet_a_cidr_block = "10.0.3.0/24"
  private_subnet_b_cidr_block = "10.0.4.0/24"
  region                      = "us-east-1"
}

module "rds" {
  count            = local.environments[local.env].enable_rds ? 1 : 0
  source           = "./modules/rds"
  username         = var.RDS_USERNAME
  password         = var.RDS_PASSWORD
  name             = var.RDS_DB_NAME
  port             = var.RDS_PORT
  vpc_id           = local.vpc_id
  public_subnets   = [local.subnet_ids[2], local.subnet_ids[3]]
}

module "ecs" {
  count  = local.environments[local.env].enable_ecs ? 1 : 0
  source = "./modules/ecs"
  vpc_id = local.vpc_id
  subnet_ids = [local.subnet_ids[0], local.subnet_ids[1]]
  docker_image = var.DOCKER_IMAGE
}

module "asg" {
  count  = local.environments[local.env].enable_ecs ? 1 : 0
  source = "./modules/asg"
  vpc_id = local.vpc_id
  subnet_ids = [local.subnet_ids[0], local.subnet_ids[1]]
}

module "ecr" {
  count  = local.environments[local.env].enable_ecr ? 1 : 0
  source = "./modules/ecr"
  repository_name = "devops-infraestructure"
}
