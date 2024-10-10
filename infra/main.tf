terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.84.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

provider "google" {
    credentials = var.GOOGLE_CREDENTIALS
    project = var.project
    region = var.region
    zone = var.zone
}

module "storage" {
  source = "./modules/storage"
  project = var.project
  airbyte_auth_service_account_email = module.auth.airbyte_service_account_email
}

module "gke" {
  source = "./modules/gke"
}

module "auth" {
  source = "./modules/auth"
  project = var.project
}