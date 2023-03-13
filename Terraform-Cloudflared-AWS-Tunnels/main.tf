module "cloudflare-tunnel" {
  source                = "./module/cloudflare-tunnel"
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_zone_id    = var.cloudflare_zone_id
  cloudflare_zone_name  = var.cloudflare_zone_name
  name_prefix           = var.name_prefix
  rdp_server_ip         = var.rdp_server_ip
}

module "cloudflare-server" {
  source                  = "./module/aws-cloudflared-server"
  aws_region              = var.aws_region
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  name_prefix             = var.name_prefix
  cloudflare_tunnel_token = module.cloudflare-tunnel.tunnel_token
}

module "rdp-server" {
  source         = "./module/aws-windows-server"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  name_prefix    = var.name_prefix
}