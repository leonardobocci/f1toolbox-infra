resource "google_project_service" "enable_iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "airbyte_service_account" {
  account_id   = "airbyte"
  display_name = "Airbyte Service Account"
  project      = var.project

  depends_on = [google_project_service.enable_iam]
}

resource "google_service_account" "metabase_service_account" {
  account_id   = "metabase"
  display_name = "Metabase Service Account"
  project      = var.project

  depends_on = [google_project_service.enable_iam]
}

resource "google_service_account" "workload_identity_gke_service_account" {
  account_id   = "gke-workflow-identity"
  display_name = "Service Account For Workload Identity"

  depends_on = [google_project_service.enable_iam]
}