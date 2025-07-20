variable "aws_region" {
  default = "us-west-2"
}

variable "app_name" {
  default = "davidrstudios"
}

variable "github_repo" {
  description = "GitHub repository URL"
  default     = "https://github.com/davidrf/davidrstudios"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "davidrstudios"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
