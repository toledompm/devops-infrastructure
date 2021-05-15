resource "aws_ecr_repository" "devops-infraestructure" { 
​	name                 = "devops-infraestructure"  
​	image_tag_mutability = "MUTABLE"
}