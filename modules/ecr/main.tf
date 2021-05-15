resource "aws_ecr_repository" "devops-infraestructure" { 
​	name                 = var.repository_name
​	image_tag_mutability = "MUTABLE"
}
