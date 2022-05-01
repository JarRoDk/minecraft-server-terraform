data "google_compute_default_service_account" "default" {
  project = var.project_name
}

resource "google_compute_instance" "default" {
  name         = var.gci_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_name


  boot_disk {
    initialize_params {
      image = var.boot_disk_image_name
    }
  }
  tags = var.tags

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = data.template_file.default.rendered

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }
  scheduling {
    preemptible       = var.preemptible
    automatic_restart = false
  }

  #  metadata = {
  #    shutdown-script = "/usr/bin/sh /opt/minecraft/backup-all.sh"
  #  }
}

data "google_secret_manager_secret_version" "key" {
  project = var.project_name
  secret  = "new_relic_key"
  version = "1"
}

data "google_secret_manager_secret_version" "apikey" {
  project = var.project_name
  secret  = "new_relic_api_key"
  version = "1"
}


data "template_file" "default" {
  template = file("start-minecraft-server.tpl")
  vars = {
    minecraft-version = var.minecraft_version
    #    minecraft-download-spigot = "https://download.getbukkit.org/spigot/spigot" need to move it to build script
    openjdk        = var.openjdk
    minecraft-core = var.minecraft-core
    minecraft-bin  = var.minecraft-bin
    minecraft-maps = var.minecraft-maps
    map-prefix     = var.map-prefix
    realm                       = var.realm
    simplybackup-interval-hours = var.simplybackup-interval-hours
    key                         = data.google_secret_manager_secret_version.key.secret_data
    api_key                     = data.google_secret_manager_secret_version.apikey.secret_data
  }
}


