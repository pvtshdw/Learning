terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  #  profile    = "cloud_user"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  insecure   = true // Needed for ACloudGuru Playgrounds due to SSL cert errors
}
/*
 * AWS CloudflareD Server
 */
# Generate a secure private key and encode it as a PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the key pair
resource "aws_key_pair" "demo_key_pair" {
  key_name   = "${var.name_prefix}-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save the file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.demo_key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# Create the EC2 instance
resource "aws_instance" "demo_bastion" {
  ami           = "ami-0dfcb1ef8550277af" // AWS Linux AMI for US-East-1
  instance_type = "t2.micro"
  #   subnet_id = aws_subnet.qa_bastion_subnet.id
  key_name = aws_key_pair.demo_key_pair.key_name

  user_data = templatefile("cloudflared.tftpl", { tunnel_token = cloudflare_tunnel.demo.tunnel_token })

  tags = {
    Name          = "${var.name_prefix}-bastion"
    "createdby"   = "marvin.martian"
    "environment" = "prod"
  }
}