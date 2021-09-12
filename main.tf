terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.83.0"
    }
  }
}

provider "google" {
  # Configuration options
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "europe-central2-a"
  project = "quantum-bonus-325717"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

}
output "public_ip" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}


data "template_file" "default" {
  template = "${file("start-minecraft-server.tpl")}"
  vars = {
    minecraft-version = "1.17.1"
    minecraft-download-spigot = "https://download.getbukkit.org/spigot/spigot-${minecraft-version}.jar"
    openjdk = "java-latest-openjdk-16.0.1.0.9-3.rolling.el7.x86_64"
    minecraft-core = "/var/opt/minecraft"
    minecraft-words = "words"
  }
}
