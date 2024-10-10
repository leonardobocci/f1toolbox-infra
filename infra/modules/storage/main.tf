resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
    disable_on_destroy = false
}

resource "google_storage_bucket" "landing_files_layer" {
  name = "f1toolbox-landing-bucket"
  location = var.bucket_region
  project       = var.project
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "bronze_files_layer" {
  name = "f1toolbox-bronze-bucket"
  location = var.bucket_region
  project       = var.project
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket_iam_member" "airbyte_landing_bucket_access" {
  bucket = google_storage_bucket.landing_files_layer.name
  role   = var.airbyte_bucket_role
  member = "serviceAccount:${var.airbyte_auth_service_account_email}"
}

resource "google_storage_bucket_iam_member" "airbyte_landing_bucket_access" {
  bucket = google_storage_bucket.bronze_files_layer.name
  role   = var.airbyte_bucket_role
  member = "serviceAccount:${var.airbyte_auth_service_account_email}"
}