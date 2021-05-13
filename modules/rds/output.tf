output "all_subnets" {
  description = "all subnets ids"
  value = data.aws_subnet.public_subnets[*].id
}
