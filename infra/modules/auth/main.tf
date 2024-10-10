resource "google_project_service" "enable_iam" {
  service = "iam.googleapis.com"
}

resource "google_service_account" "airbyte_service_account" {
  account_id   = "airbyte"
  display_name = "Airbyte Service Account"
  project      = var.project

  depends_on = [google_project_service.enable_iam]
}