locals {
  default_tags = {
    Terraform = true
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "subnet_ids" {
  count = length(var.subnet_ids)
  id = var.subnet_ids[count.index]
}

data "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecsInstanceRole"
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id = "ami-0cce120e74c5100d4"
  iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_role.name
  security_groups = [aws_security_group.asg_sg.id]
  user_data = "#!/bin/bash\necho ECS_CLUSTER=devops-infra-cluster >> /etc/ecs/ecs.config"
  instance_type = "t2.micro"
  key_name = "devops-ecs"
}

resource "aws_autoscaling_group" "backend" {
  name = "devops-infra-asg"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  vpc_zone_identifier = [for i, v in data.aws_subnet.subnet_ids: v.id]

  desired_capacity = 1
  min_size = 1
  max_size = 1
  health_check_grace_period = 150
  health_check_type = "EC2"
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]
}

resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = [data.aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [data.aws_vpc.vpc.cidr_block, "0.0.0.0/0"]
  }

  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = local.default_tags
}
