variable "bucket_region" {
    default = "us-central1"
}

variable "airbyte_bucket_role" {
    default = "roles/storage.objectUser"
}

variable "project" { }

variable "airbyte_auth_service_account_email" {}