resource "google_service_account" "airbyte_service_account" {
  account_id   = "airbyte"
  display_name = "Airbyte Service Account"
  project      = var.project
}