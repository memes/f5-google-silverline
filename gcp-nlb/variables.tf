variable "tf_sa_email" {
  type        = string
  description = <<EOD
The fully-qualified email address of the Terraform service account to use for
resource creation. E.g.
tf_sa_email = "terraform@PROJECT_ID.iam.gserviceaccount.com"
EOD
}

variable "tf_sa_token_lifetime_secs" {
  type        = number
  default     = 600
  description = <<EOD
The expiration duration for the service account token, in seconds. This value
should be high enough to prevent token timeout issues during resource creation,
but short enough that the token is useless replayed later. Default value is 600
(10 mins).
EOD
}

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
  type        = string
  default     = "us-west1"
  description = <<EOD
The GCE region to use for resources. Default is 'us-west1'.
EOD
}

variable "bastion_access_members" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of users/groups/serviceAccounts that will be granted login
privleges to the control-plane bastion via IAP tunnelling. Default is an empty
list.
EOD
}

variable "enable_unprotected_access" {
  type        = bool
  default     = false
  description = <<EOD
When set to true, allow ingress to backend service without proxying through
Silverline. Default is false, which restricts ingress to the CIDRs associated
with Silverline.
EOD
}

variable "service_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = <<EOD
The CIDR to assign to the 'service' subnet. Default is '172.16.0.0/16'.
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
