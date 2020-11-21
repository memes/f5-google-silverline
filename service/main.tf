# This module has been tested with Terraform 0.13 only.

data "google_compute_subnetwork" "service" {
  self_link = element(var.subnets, 0)
}

# Create a service account for exclusive use of backend service
module "service_account" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "3.0.1"
  project_id   = var.project_id
  prefix       = var.prefix
  names        = ["service"]
  display_name = "NGINX service account"
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/monitoring.viewer",
  ]
  generate_keys = false
}

locals {
  # Generated service account emails are predictable; we can use them without
  # relying on actually generating them.
  service_account = format("%s-service@%s.iam.gserviceaccount.com", var.prefix, var.project_id)
}


resource "google_compute_instance_template" "service" {
  project              = var.project_id
  name_prefix          = format("%s-service", var.prefix)
  description          = format("%s service", var.prefix)
  instance_description = format("%s service", var.prefix)
  region               = var.region
  labels               = var.labels
  metadata = {
    enable-oslogin = "TRUE"
    user-data = templatefile("${path.module}/templates/cloud_config.yaml",
      {
        tls_fullchain_cert = base64gzip(file(var.tls_fullchain_pem)),
        tls_key            = base64gzip(file(var.tls_key)),
        server_name        = var.server_name,
      }
    )
  }

  machine_type = "n1-standard-1"
  service_account {
    email = local.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  }

  # Attach to each subnet without a public IP
  dynamic "network_interface" {
    for_each = toset(var.subnets)
    content {
      subnetwork = network_interface.value
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}

# Health check for MIG; prefer to fail slowly to avoid recycling VMs unnecessarily
resource "google_compute_health_check" "mig" {
  project             = var.project_id
  name                = format("%s-mig", var.prefix)
  check_interval_sec  = 30
  timeout_sec         = 2
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    request_path = "/"
    port         = 80
  }
}

# Make sure the MIG health check succeeds

# Allow GCP health checks to connect to service instances on port 80
resource "google_compute_firewall" "service" {
  project     = var.project_id
  name        = format("%s-allow-health-check-service-mig", var.prefix)
  network     = data.google_compute_subnetwork.service.network
  description = "Allow MIG TCP health check to service VMs"
  direction   = "INGRESS"
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
  target_service_accounts = [
    local.service_account,
  ]
  allow {
    protocol = "tcp"
    ports = [
      80,
    ]
  }
}

# Create a regional MIG for the service
resource "google_compute_region_instance_group_manager" "service" {
  project            = var.project_id
  name               = format("%s-service", var.prefix)
  description        = format("%s service MIG", var.prefix)
  region             = var.region
  base_instance_name = format("%s-service", var.prefix)
  target_size        = 2
  auto_healing_policies {
    health_check      = google_compute_health_check.mig.id
    initial_delay_sec = 60
  }
  version {
    name              = format("%s-service", var.prefix)
    instance_template = google_compute_instance_template.service.id
  }
}
