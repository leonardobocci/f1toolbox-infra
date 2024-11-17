variable "project" {}

variable "bigquery_location" {
  default = "us-central1"
}

variable "terraform_service_account_email" {}

variable "airbyte_auth_service_account_email" {}

variable "metabase_auth_service_account_email" {}

variable "workload_identity_gke_service_account_email" {}