resource "google_compute_instance_template" "app" {
  name_prefix  = "${var.name}-"
  machine_type = var.machine_type
  tags         = ["ssh"]

  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
  }

  network_interface {
    network = "default"
    access_config {}
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "app" {
  name               = "${var.name}-mig"
  base_instance_name = var.name
  region             = var.region

  version {
    instance_template = google_compute_instance_template.app.id
  }

  update_policy {
    type                         = "PROACTIVE"
    minimal_action               = "REPLACE"
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = 3
    max_unavailable_fixed        = 0
  }
}

resource "google_compute_region_autoscaler" "app" {
  name   = "${var.name}-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.app.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 60

    cpu_utilization {
      target = var.cpu_target
    }
  }
}
