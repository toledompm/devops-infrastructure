data "aws_subnet" "public-subnet" {
    id = var.public_subnet_id
}

resource "aws_db_subnet_group" "public-subnet-group" {
    name       = "rds-subnet"
    subnet_ids = [data.aws_subnet.public-subnet.id]
}

resource "aws_db_instance" "db" {
  storage_type           = "gp2"
  engine                 = "postgresql"
  engine_version         = "12.2"
  instance_class         = "db.t2.micro"
  skip_final_snapshot    = true

  name                   = var.name
  username               = var.username
  password               = var.password
  port                   = var.port
  identifier             = var.name
  allocated_storage      = var.storage_size

  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.public-subnet-group.name

  depends_on = [
      aws_db_subnet_group.public-subnet-group
  ]
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  vpc_id      = data.aws_subnet.public-subnet.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [data.aws_subnet.public-subnet.cidr_block]
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
