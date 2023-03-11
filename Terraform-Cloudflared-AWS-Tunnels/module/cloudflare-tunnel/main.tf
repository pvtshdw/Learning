terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  #  profile    = "cloud_user"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  insecure   = true // Needed for ACloudGuru Playgrounds due to SSL cert errors
}

/*
 * Cloudflare
 */

# Create a 35-character secret for the tunnel.
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# Create the base tunnel resource
resource "cloudflare_tunnel" "demo" {
  account_id = var.cloudflare_account_id
  name       = "${var.name_prefix}-tunnel"
  secret     = random_id.tunnel_secret.b64_std
}

# Configure the tunnel
resource "cloudflare_tunnel_config" "demo-config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.demo.id

  config {
    warp_routing {
      enabled = true
    }

    ingress_rule {
      hostname = "hello.${var.cloudflare_zone_name}"
      service  = "hello_world"
    }
    ingress_rule {
      hostname = "rdp.${var.cloudflare_zone_name}"
      service = "rdp://???:3389"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Create a CNAME record for the application
resource "cloudflare_record" "demo-cname" {
  zone_id = var.cloudflare_zone_id
  name    = "hello"
  value   = "${cloudflare_tunnel.demo.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}
resource "cloudflare_record" "demo-cname" {
  zone_id = var.cloudflare_zone_id
  name    = "rdp"
  value   = "${cloudflare_tunnel.demo.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}