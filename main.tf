resource "google_compute_instance" "default" {
  name         = "minecraft-temporary-server-centos7"
  machine_type = "e2-medium"
  zone         = "europe-central2-a"
  project = "quantum-bonus-325717"


  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
#  tags {
#    minecraft-server
#  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "${data.template_file.default.rendered}"
#  user_data = data.template_file.default.rendered

}
output "public_ip" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
output "reder_scrip" {
    value = data.template_file.default.rendered

}



data "template_file" "default" {
  template = "${file("start-minecraft-server.tpl")}"
  vars = {
    minecraft-version = "1.17.1"
    minecraft-download-spigot = "https://download.getbukkit.org/spigot/spigot"
    openjdk = "java-latest-openjdk-16.0.1.0.9-3.rolling.el7.x86_64"
    minecraft-core = "/opt/minecraft"
    minecraft-words = "words"
  }
}
