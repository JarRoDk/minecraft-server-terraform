terraform {
  backend "gcs" {
    prefix = "minecraft-server-terraform"
    bucket = "minecraft-server-terraform"
  }
}
