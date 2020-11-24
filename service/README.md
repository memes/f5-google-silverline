# Stupid little NGINX site in MIG

The Terraform will create a service MIG for testing.

<!-- spell-checker: ignore bigip oslogin nics byol payg vcpus preemptible routable zoneinfo -->
<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| labels | An optional map of string key:value pairs that will be applied to all resources<br>that accept labels. Default is an empty map. | `map(string)` | `{}` | no |
| prefix | The name of the upstream client network to create; default is 'client'. | `string` | n/a | yes |
| project\_id | The existing project id that will host the resources. E.g.<br>project\_id = "example-project-id" | `string` | n/a | yes |
| region | The GCE region to use for resources. Default is 'us-west1'. | `string` | `"us-west1"` | no |
| server\_name | The server name; e.g. `silverline.example.com`. | `string` | n/a | yes |
| subnets | The list of fully-qualified subnetworks to attach to the service VMs. | `list(string)` | n/a | yes |
| tags | An optional list of string network tags that will be applied to all taggable<br>resources. Default is an empty list. | `list(string)` | `[]` | no |
| tls\_fullchain\_pem | The path to a full-chain PEM file to install as TLS server certificate. | `string` | n/a | yes |
| tls\_key | The path to a private key PEM file to install with TLS server certificate. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_group | n/a |
| service\_account | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
