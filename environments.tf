locals {
  environments = {
    prod = {
      enable_ecr = true
      enable_ecs = true
      enable_rds = true
      enable_net = true
    }

    staging = {
      enable_ecr = false
      enable_ecs = true
      enable_rds = true
      enable_net = true
    }
  }
}
