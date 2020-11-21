# Service network will be exposed as an ingress on public internet. Egress
# through this network is permitted.
module "service_vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "2.5.0"
  project_id                             = var.project_id
  network_name                           = format("%s-service", var.prefix)
  delete_default_internet_gateway_routes = false
  subnets = [
    {
      subnet_name           = "service"
      subnet_ip             = var.service_cidr
      subnet_region         = var.region
      subnet_private_access = false
    }
  ]
}

# Create a NAT gateway on the service network
module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 1.3.0"
  project_id                         = var.project_id
  region                             = var.region
  name                               = format("%s-service", var.prefix)
  router                             = format("%s-service", var.prefix)
  create_router                      = true
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  network                            = module.service_vpc.network_self_link
  subnetworks = [
    {
      name                     = "service"
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    },
  ]
}

locals {
  service_subnet = lookup(lookup(module.service_vpc.subnets, format("%s/service", var.region), {}), "self_link", "")
}
