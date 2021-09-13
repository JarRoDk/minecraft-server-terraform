output "reder_scrip" {
    value = data.template_file.default.rendered
}
output "public_ip" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}