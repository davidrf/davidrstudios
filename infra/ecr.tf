resource "aws_ecr_repository" "app" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = var.app_name
  }
}
