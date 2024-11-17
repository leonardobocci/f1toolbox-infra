terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = var.project
  region      = var.region
  zone        = var.zone
}

module "storage" {
  source                                      = "./modules/storage"
  project                                     = var.project
  airbyte_auth_service_account_email          = module.auth.airbyte_service_account_email
  terraform_service_account_email             = var.terraform_service_account_email
  project_user_gmail                          = var.project_user_gmail
  workload_identity_gke_service_account_email = module.auth.workload_identity_gke_service_account.email
}

module "gke" {
  source = "./modules/gke"
}

module "auth" {
  source  = "./modules/auth"
  project = var.project
}

module "secrets" {
  source                             = "./modules/secrets"
  project                            = var.project
  airbyte_auth_service_account_email = module.auth.airbyte_service_account_email
}

module "bigquery" {
  source                             = "./modules/bigquery"
  project                            = var.project
  airbyte_auth_service_account_email = module.auth.airbyte_service_account_email
  metabase_auth_service_account_email = module.auth.metabase_service_account_email
  workload_identity_gke_service_account_email = module.auth.workload_identity_gke_service_account_email
  terraform_service_account_email    = var.terraform_service_account_email
}