module "rds" {
  source           = "./modules/rds"
  username         = var.rds_username
  password         = var.rds_password
  name             = var.rds_db_name
  port             = var.rds_port
  public_subnet_id = var.rds_public_subnet_id
}
