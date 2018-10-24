provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}
resource "google_compute_instance" "app" {
  name          = "reddit-app-terraform"
  machine_type  = "g1-small"
  zone          = "europe-west1-b"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ethemeral ip для доступа из интернет
    access_config {}
  }
  metadata {
    ssh-keys = "user:${file(var.public_key_path)}"
  }
  tags = ["reddit-app-terraform"]
  connection {
    type  = "ssh"
    user  = "user"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

