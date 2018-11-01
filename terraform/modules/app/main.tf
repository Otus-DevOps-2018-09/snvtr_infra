# статический ip
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

# сама машина
resource "google_compute_instance" "app" {
  name          = "reddit-app"
  machine_type  = "g1-small"
  zone          = "${var.zone}"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ethemeral ip для доступа из интернет
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  # ключ для доступа снаружи
  metadata {
    ssh-keys = "user:${file(var.public_key_path)}"
  }

  #
  tags = ["reddit-app"]

  # как подключаться провиженерам
  connection {
    type  = "ssh"
    user  = "user"
    agent = false
    private_key = "${file("/home/user/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source      = "../files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "../files/deploy.sh"
  }
}

# правило firewall для доступа к сервису
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}

