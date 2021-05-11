locals {
    default_tags = {
        Terraform = true
    }
}

data "aws_vpc" "vpc" {
    id = var.vpc_id
}

resource "aws_ecs_cluster" "backend" {
    name = "devops-infra-cluster"

    setting {
        name  = "containerInsights"
        value = "disabled"
    }

    tags = local.default_tags
}

resource "aws_ecs_task_definition" "app_task" {
    family = "service"
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.backend_task_execution.arn

    container_definitions = jsonencode([
        {
            name = "devops-application"
            image = "jasoncarneiro/devops-app:latest"
            cpu = 1
            memory = 512
            essential = true
            environment = [
                {
                    name = "PORT"
                    value = "3000"
                }
            ]
            portMappings = [
                {
                    containerPort = 3000
                    hostPort = 3000
                }
            ]
            networkMode = "awsvpc"
        }
    ])
    
    tags = local.default_tags
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}


resource "aws_ecs_service" "backend" {
  name            = "devops-infra-ecs-service"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1

  launch_type = "EC2"

  network_configuration {
    subnets = var.subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  tags = local.default_tags
}

resource "aws_iam_role" "backend_task_execution" {
  name = "backend-task-execution"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
  })

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
