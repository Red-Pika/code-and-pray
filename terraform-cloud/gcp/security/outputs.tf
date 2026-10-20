output "service_account_email" { value = google_service_account.workload.email }
output "kms_key_id" { value = google_kms_crypto_key.this.id }
output "secret_id" { value = google_secret_manager_secret.app.id }
output "https_firewall_name" { value = google_compute_firewall.https.name }
