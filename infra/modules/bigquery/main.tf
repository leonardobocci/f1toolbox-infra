resource "google_project_service" "enable_iam" {
  service = "bigquery.googleapis.com"
  disable_on_destroy = false
}