output "service_account" {
  value = local.service_account
}

output "instance_group" {
  value = google_compute_region_instance_group_manager.service.instance_group
}
