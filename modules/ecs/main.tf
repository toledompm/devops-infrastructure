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

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/aws/ecs/devops-culture"

  tags = local.default_tags
}

resource "aws_ecs_task_definition" "app_task" {
  family             = "service"
  execution_role_arn = aws_iam_role.backend_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "devops-application"
      image     = var.docker_image
      cpu       = 1
      memory    = 512
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app_log_group.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "devops-culture"
        }
      }
      environment = [
        {
          name  = "PORT"
          value = "3000"
        }
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

    }
  ])

  tags = local.default_tags
}

resource "aws_ecs_service" "backend" {
  name                               = "devops-infra-ecs-service"
  cluster                            = aws_ecs_cluster.backend.id
  task_definition                    = aws_ecs_task_definition.app_task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  force_new_deployment               = true

  launch_type = "EC2"

  tags = local.default_tags

  depends_on = [
    aws_ecs_task_definition.app_task
  ]
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

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_utilization_alarm" {
  alarm_name                = "ecs_cpu_utilization_alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ecs cpu utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = aws_ecs_cluster.backend.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_utilization_alarm" {
  alarm_name                = "ecs_memory_utilization_alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ecs memory utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = aws_ecs_cluster.backend.name
  }
}