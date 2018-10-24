resource "google_compute_firewall" "firewall_puma" {
  name     = "allow-puma-default"
  # Название сети для которой действует правило
  network  = "default"
  # Какой доступ разрешаем
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  } 
  # кому разрешаем ходить 
  source_ranges = ["0.0.0.0/0"]
  # на какой тэг вешается правило
  target_tags = ["reddit-app-terraform"]
}

