locals {
  default_tags = {
    Terraform = "true"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags                 = local.default_tags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags   = local.default_tags
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = local.default_tags
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = merge(
    local.default_tags,
    {
      Subnet = "public-a"
  })
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = merge(
    local.default_tags,
    {
      Subnet = "public-b"
  })
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_a_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = merge(
    local.default_tags,
    {
      Subnet = "private-a"
  })
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_b_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = merge(
    local.default_tags,
    {
      Subnet = "private-b"
  })
}

resource "aws_route_table_association" "route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.route_table.id
}
