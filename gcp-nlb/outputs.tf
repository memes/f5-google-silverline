output "address" {
  value       = google_compute_forwarding_rule.service.ip_address
  description = <<EOD
The assigned public IPv4 address of NLB.
EOD
}
