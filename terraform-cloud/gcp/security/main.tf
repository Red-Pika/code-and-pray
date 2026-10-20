resource "google_compute_firewall" "https" {
  name          = "${var.name}-allow-https"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = var.allowed_https_cidrs
  target_tags   = ["https-server"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# SSH only through Identity-Aware Proxy (no public SSH)
resource "google_compute_firewall" "iap_ssh" {
  name          = "${var.name}-allow-iap-ssh"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_service_account" "workload" {
  account_id   = "${var.name}-workload"
  display_name = "${var.name} workload identity"
}

resource "google_kms_key_ring" "this" {
  name     = "${var.name}-keyring"
  location = var.kms_location
}

resource "google_kms_crypto_key" "this" {
  name            = "${var.name}-key"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "7776000s" # 90 days
}

resource "google_secret_manager_secret" "app" {
  secret_id = "${var.name}-secret"
  labels    = var.labels

  replication {
    auto {}
  }
  # The secret VERSION (value) is intentionally not managed here (it would land in state).
}

resource "google_secret_manager_secret_iam_member" "workload_access" {
  secret_id = google_secret_manager_secret.app.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.workload.email}"
}
