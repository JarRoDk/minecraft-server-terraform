terraform {
  backend "gcs" {
    prefix = "minecraft-server-terraform"
    bucket = "minecraft-server-terraform"
  }
}
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
provider "cloudflare" {
  email   = var.cloudflare_email
  api_token  = var.cloudflare_api_token
}
