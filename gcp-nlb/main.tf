# This module has been tested with Terraform 0.13 only.
#
# Note: GCS backend requires the current user to have valid application-default
# credentials. An error like "... failed: dialing: google: could not find default
# credenitals" indicates that the calling user must (re-)authenticate application
# default credentials using `gcloud auth application-default login`.
terraform {
  required_version = "~> 0.13.5"
  # The location and path for GCS state storage must be specified in an environment
  # file(s) via `-backend-config=env/ENV/automation-factory.config"
  backend "gcs" {}
}

# Provider and Terraform service account impersonation is handled in providers.tf
