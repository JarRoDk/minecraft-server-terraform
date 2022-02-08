data "google_compute_default_service_account" "default" {
  project = "quantum-bonus-325717"
}

resource "google_compute_instance" "default" {
  name         = "minecraft-temporary-server-centos7"
  machine_type = "e2-standard-2"
  zone         = "europe-central2-a"
  project      = "quantum-bonus-325717"


  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  tags = ["minecraft-server"]


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
    preemptible       = true
    automatic_restart = false
  }

  #  metadata = {
  #    shutdown-script = "/usr/bin/sh /opt/minecraft/backup-all.sh"
  #  }
}

data "google_secret_manager_secret_version" "key" {
  project = "quantum-bonus-325717"
  secret  = "new_relic_key"
  version = "1"
}

data "google_secret_manager_secret_version" "apikey" {
  project = "quantum-bonus-325717"
  secret  = "new_relic_api_key"
  version = "1"
}


data "template_file" "default" {
  template = file("start-minecraft-server.tpl")
  vars = {
    minecraft-version = "1.17.1"
    #    minecraft-download-spigot = "https://download.getbukkit.org/spigot/spigot" need to move it to build script
    openjdk        = "java-latest-openjdk-16.0.1.0.9-3.rolling.el7.x86_64"
    minecraft-core = "/opt/minecraft"
    minecraft-bin  = "spigot-server"
    minecraft-maps = "maps"
    map-prefix     = "map"
    #    realm = "2mm"
    realm                       = "3magda-jasin-agata"
    simplybackup-interval-hours = "2"
    key                         = data.google_secret_manager_secret_version.key.secret_data
    api_key                     = data.google_secret_manager_secret_version.apikey.secret_data
  }
}

