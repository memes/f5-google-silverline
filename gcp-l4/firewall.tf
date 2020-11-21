# Allow bastion instance to ping and connect to service instances on ports 22,
# 80, and 443.
resource "google_compute_firewall" "bastion_service" {
  project     = var.project_id
  name        = format("%s-allow-bastion-service", var.prefix)
  network     = module.service_vpc.network_self_link
  description = "Allow bastion to service VMs on beta network"
  direction   = "INGRESS"
  source_service_accounts = [
    module.bastion.service_account,
  ]
  target_service_accounts = [
    local.service_sa,
  ]
  allow {
    protocol = "tcp"
    ports = [
      22,
      80,
      443,
    ]
  }
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "silverline_service" {
  project     = var.project_id
  name        = format("%s-allow-silverline-service", var.prefix)
  network     = module.service_vpc.network_self_link
  description = "Allow ingress traffic from Silverline"
  direction   = "INGRESS"
  source_ranges = [
    "107.162.0.0/21",
    "107.162.48.0/20",
  ]
  target_service_accounts = [
    local.service_sa,
  ]
  allow {
    protocol = "tcp"
    ports = [
      80,
      443,
    ]
  }
}

# Allow NLB to connect to service instances on port 80
resource "google_compute_firewall" "nlb_service" {
  project     = var.project_id
  name        = format("%s-allow-nlb-service", var.prefix)
  network     = module.service_vpc.network_self_link
  description = "Allow NLB health check to service VMs"
  direction   = "INGRESS"
  source_ranges = [
    "35.191.0.0/16",
    "209.85.152.0/22",
    "209.85.204.0/22"
  ]
  target_service_accounts = [
    local.service_sa,
  ]
  allow {
    protocol = "tcp"
    ports = [
      80,
      443,
    ]
  }
}

# Allow unprotected access to service
resource "google_compute_firewall" "unprotected_service" {
  project     = var.project_id
  name        = format("%s-allow-unprotected-service", var.prefix)
  network     = module.service_vpc.network_self_link
  description = "Allow ingress traffic from Silverline"
  direction   = "INGRESS"
  disabled    = ! var.enable_unprotected_access
  source_ranges = [
    "0.0.0.0/0",
  ]
  target_service_accounts = [
    local.service_sa,
  ]
  allow {
    protocol = "tcp"
    ports = [
      80,
      443,
    ]
  }
}
