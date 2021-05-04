module "rds" {
  source           = "./modules/rds"
  username         = var.rds_username
  password         = var.rds_password
  name             = var.rds_db_name
  port             = var.rds_port
  vpc_id           = var.vpc_id
  public_subnets   = split(",", var.rds_public_subnets)
}
