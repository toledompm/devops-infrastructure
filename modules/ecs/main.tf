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
  execution_role_arn = aws_iam_role.backend_task_execution.arn

  container_definitions = jsonencode([
    {
      name = "devops-application"
      image = var.docker_image
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
    }
  ])
  
  tags = local.default_tags
}

resource "aws_ecs_service" "backend" {
  name            = "devops-infra-ecs-service"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true

  launch_type = "EC2"

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
