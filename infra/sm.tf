resource "aws_secretsmanager_secret" "app_env" {
  name        = "davidrstudios/env"
  description = "Environment variables for davidrstudios app"
  tags        = var.tags
}
