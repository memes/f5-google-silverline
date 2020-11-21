# Reserve a public IP address for NLB forwarding rule
module "nlb_ip" {
  source       = "terraform-google-modules/address/google"
  version      = "2.1.0"
  project_id   = var.project_id
  region       = var.region
  names        = [format("%s-nlb", var.prefix)]
  address_type = "EXTERNAL"
}

# Health check for NLB; okay for this to fail and recover quickly
resource "google_compute_region_health_check" "nlb" {
  project             = var.project_id
  name                = format("%s-tcp-nlb", var.prefix)
  region              = var.region
  check_interval_sec  = 15
  timeout_sec         = 2
  healthy_threshold   = 1
  unhealthy_threshold = 2

  tcp_health_check {
    port = 80
  }
}


resource "google_compute_region_backend_service" "service" {
  provider    = google-beta
  project     = var.project_id
  name        = format("%s-service", var.prefix)
  description = format("%s TCP backend service for NLB", var.prefix)
  region      = var.region
  health_checks = [
    google_compute_region_health_check.nlb.id,
  ]
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = module.service.instance_group
  }
}

resource "google_compute_forwarding_rule" "service" {
  provider              = google-beta
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  name                  = format("%s-nlb-service", var.prefix)
  description           = format("%s NLB to service", var.prefix)
  labels                = var.labels
  ip_address            = element(module.nlb_ip.addresses, 0)
  port_range            = "1-65535"
  backend_service       = google_compute_region_backend_service.service.id
}
