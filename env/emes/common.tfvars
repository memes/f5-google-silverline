# Use this file to set Terraform variables for cis-gke specific Terraform
project_id  = "f5-gcs-4138-sales-cloud-sales"
tf_sa_email = "terraform@f5-gcs-4138-sales-cloud-sales.iam.gserviceaccount.com"
labels = {
  owner     = "emes"
  retention = "none"
}
tags              = []
server_name       = "silverline.securecloudarchitecture.com"
tls_fullchain_pem = "/Users/emes/projects/demos/f5-google-silverline/silverline.securecloudarchitecture.com.full-chain.pem"
tls_key           = "/Users/emes/projects/demos/f5-google-silverline/silverline.securecloudarchitecture.com.key.pem"
