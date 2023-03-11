# AWS variables
variable "aws_region" {
  description = "The region in which resources will be created"
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "The AWS access key"
}

variable "aws_secret_key" {
  description = "The AWS secret key"
}