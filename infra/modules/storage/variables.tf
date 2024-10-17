variable "bucket_region" {
    default = "us-central1"
}

variable "project" { }

variable "terraform_service_account_email" { }

variable "project_user_gmail" { }

variable "airbyte_auth_service_account_email" {}

variable "workload_identity_gke_service_account_email" {}