variable "aws_region" {
  default = "us-west-2"
}

variable "app_name" {
  default = "davidrstudios"
}

variable "domain_name" {
  description = "David Rodriguez Studios"
  default     = "davidrstudios.com"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "davidrstudios"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

variable "tf_state_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  default     = "davidrstudios-terraform-state"
}

variable "tf_state_lock_table" {
  description = "The name of the DynamoDB table for Terraform state locking"
  default     = "davidrstudios-terraform-locks"
}
