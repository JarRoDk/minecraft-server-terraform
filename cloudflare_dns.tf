resource "cloudflare_record" "minecraft_dns" {
  zone_id = lookup(data.cloudflare_zones.minecraft_zone.zones[0], "id")
  name    = var.dns_name
  value   = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  type    = "A"
  proxied = false
  allow_overwrite = true
  ttl = 1
}
data "cloudflare_zones" "minecraft_zone" {
  filter {
    name = var.dns_zone
  }
}
