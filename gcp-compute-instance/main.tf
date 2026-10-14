resource "google_compute_firewall" "ssh" {
  name    = "${var.name}-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.ssh_cidr]
  target_tags   = ["ssh"]
}

resource "google_compute_instance" "app" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
