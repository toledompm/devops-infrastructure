data "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  id = var.public_subnets[count.index]
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "rds_subnet"
  subnet_ids = [
    for i, v in data.aws_subnet.public_subnets: v.id
  ]
}

resource "aws_db_instance" "db" {
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12"
  instance_class         = "db.t2.micro"
  skip_final_snapshot    = true

  name                   = var.name
  username               = var.username
  password               = var.password
  port                   = var.port
  identifier             = "taskappdb"
  allocated_storage      = var.storage_size

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.public_subnet_group.name

  depends_on = [
    aws_db_subnet_group.public_subnet_group
  ]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
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
