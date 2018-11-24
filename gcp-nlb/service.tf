module "service" {
  source            = "../service/"
  project_id        = var.project_id
  prefix            = var.prefix
  labels            = var.labels
  tags              = var.tags
  region            = var.region
  subnets           = [local.service_subnet]
  server_name       = var.server_name
  tls_fullchain_pem = var.tls_fullchain_pem
  tls_key           = var.tls_key
}

locals {
  service_sa = format("%s-service@%s.iam.gserviceaccount.com", var.prefix, var.project_id)
}
