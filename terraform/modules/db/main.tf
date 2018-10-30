# сама машина
resource "google_compute_instance" "db" {
  name          = "reddit-db"
  machine_type  = "g1-small"
  zone          = "${var.zone}"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ethemeral ip для доступа из интернет
    access_config {
    }
  }

  # ключ для доступа снаружи
  metadata {
    ssh-keys = "user:${file(var.public_key_path)}"
  }

  #
  tags = ["reddit-db"]

  # как подключаться провиженерам
  #connection {
  #  type  = "ssh"
  #  user  = "user"
  #  agent = false
  #  private_key = "${file("/home/user/.ssh/id_rsa")}"
  #}
  #provisioner "file" {
  #  source      = "files/puma.service"
  #  destination = "/tmp/puma.service"
  #}
  #provisioner "remote-exec" {
  #  script = "files/deploy.sh"
  #}
}

# правило доступа к БД от приложения
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # к какому хосту применяем
  target_tags  = ["reddit-db"]
  # хосты с которого будет доступно
  source_tags = ["reddit-app"]

}
