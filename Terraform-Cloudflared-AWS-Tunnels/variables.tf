# General variables
variable "name_prefix" {
  description = "Prefix to use for naming resources"
}

# Cloudflare variables
variable "cloudflare_account_id" {
  description = "The Cloudflare account ID for these resources"
}

variable "cloudflare_api_token" {
  description = "The Cloudflare API token"
}

variable "cloudflare_zone_id" {
  description = "The ID for the zone in which resources will be added"
}

variable "cloudflare_zone_name" {
  description = "The base domain name for the zone"
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

variable "rdp_server_ip" {
  description = "The private IP address of the RDP server"
}