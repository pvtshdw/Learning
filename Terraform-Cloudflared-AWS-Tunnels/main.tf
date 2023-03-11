module "cloudflare-tunnel" {
  source = "./module/cloudflare-tunnel"
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_zone_name = var.cloudflare_zone_name
  name_prefix = var.name_prefix
}
# terraform {
#   required_providers {
#     cloudflare = {
#       source  = "cloudflare/cloudflare"
#       version = "~> 4.0"
#     }

#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }

# provider "aws" {
#   #  profile    = "cloud_user"
#   region     = "us-east-1"
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
#   insecure   = true // Needed for ACloudGuru Playgrounds due to SSL cert errors
# }

# /*
#  * Cloudflare
#  */

# # Create a 35-character secret for the tunnel.
# resource "random_id" "tunnel_secret" {
#   byte_length = 35
# }

# # Create the base tunnel resource
# resource "cloudflare_tunnel" "demo" {
#   account_id = var.cloudflare_account_id
#   name       = "${var.name_prefix}-tunnel"
#   secret     = random_id.tunnel_secret.b64_std
# }

# # Configure the tunnel
# resource "cloudflare_tunnel_config" "demo-config" {
#   account_id = var.cloudflare_account_id
#   tunnel_id  = cloudflare_tunnel.demo.id

#   config {
#     warp_routing {
#       enabled = true
#     }

#     ingress_rule {
#       hostname = "hello.${var.cloudflare_zone_name}"
#       service  = "hello_world"
#     }
#     ingress_rule {
#       service = "http_status:404"
#     }
#   }
# }

# # Create a CNAME record for the application
# resource "cloudflare_record" "demo-cname" {
#   zone_id = var.cloudflare_zone_id
#   name    = "hello"
#   value   = "${cloudflare_tunnel.demo.id}.cfargotunnel.com"
#   type    = "CNAME"
#   proxied = true
# }

# /*
#  * AWS CloudflareD Server
#  */
# # Generate a secure private key and encode it as a PEM
# resource "tls_private_key" "key_pair" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# # Create the key pair
# resource "aws_key_pair" "demo_key_pair" {
#   key_name   = "${var.name_prefix}-key-pair"
#   public_key = tls_private_key.key_pair.public_key_openssh
# }

# # Save the file
# resource "local_file" "ssh_key" {
#   filename = "${aws_key_pair.demo_key_pair.key_name}.pem"
#   content  = tls_private_key.key_pair.private_key_pem
# }

# # Create the EC2 instance
# resource "aws_instance" "demo_bastion" {
#   ami           = "ami-0dfcb1ef8550277af" // AWS Linux AMI for US-East-1
#   instance_type = "t2.micro"
#   #   subnet_id = aws_subnet.qa_bastion_subnet.id
#   key_name = aws_key_pair.demo_key_pair.key_name

#   user_data = templatefile("cloudflared.tftpl", { tunnel_token = cloudflare_tunnel.demo.tunnel_token })

#   tags = {
#     Name          = "${var.name_prefix}-bastion"
#     "createdby"   = "marvin.martian"
#     "environment" = "prod"
#   }
# }