# General variables
variable "name_prefix" {
  description = "Prefix to use for naming resources"
}

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