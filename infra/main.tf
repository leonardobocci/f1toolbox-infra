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
}

module "dataproc" {
  source = "./modules/dataproc"
}

module "gke" {
  source = "./modules/gke"
}

module "helm" {
  source = "./modules/helm"

  depends_on = [module.gke]
}