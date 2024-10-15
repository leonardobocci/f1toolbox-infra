variable "project" { }

variable "bigquery_location" {
    default = "us-central1"
}

variable "terraform_service_account_email" { }

variable "project_user_gmail" { }

variable "airbyte_auth_service_account_email" {}