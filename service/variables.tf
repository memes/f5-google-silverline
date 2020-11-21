variable "project_id" {
  type        = string
  description = <<EOD
The existing project id that will host the resources. E.g.
project_id = "example-project-id"
EOD
}

variable "prefix" {
  type        = string
  description = <<EOD
The name of the upstream client network to create; default is 'client'.
EOD
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional map of string key:value pairs that will be applied to all resources
that accept labels. Default is an empty map.
EOD
}

variable "tags" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of string network tags that will be applied to all taggable
resources. Default is an empty list.
EOD
}

variable "region" {
  type    = string
  default = "us-west1"
  validation {
    condition     = can(regex("^[a-z][a-z-]+[0-9]$", var.region))
    error_message = "A valid region must be provided."
  }
  description = <<EOD
The GCE region to use for resources. Default is 'us-west1'.
EOD
}

variable "subnets" {
  type = list(string)
  validation {
    condition     = length(var.subnets) > 0 && length(var.subnets) < 9
    error_message = "At least 1 subnetwork, and at most 8 subnetworks can be added to a VM."
  }
  validation {
    condition     = length(join("", [for url in var.subnets : can(regex("^https://www.googleapis.com/compute/v1/projects/[a-z][a-z0-9-]{4,28}[a-z0-9]/regions/[a-z][a-z-]+[0-9]/subnetworks/[a-z]([a-z0-9-]*[a-z0-9])?$", url)) ? "x" : ""])) == length(var.subnets)
    error_message = "Each internal_subnetworks value must be a fully-qualified self-link URI."
  }
  description = <<EOD
The list of fully-qualified subnetworks to attach to the service VMs.
EOD
}

variable "server_name" {
  type        = string
  description = <<EOD
The server name; e.g. `silverline.example.com`.
EOD
}

variable "tls_fullchain_pem" {
  type        = string
  description = <<EOD
The path to a full-chain PEM file to install as TLS server certificate.
EOD
}

variable "tls_key" {
  type        = string
  description = <<EOD
The path to a private key PEM file to install with TLS server certificate.
EOD
}
