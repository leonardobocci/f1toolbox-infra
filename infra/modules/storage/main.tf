resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
}

resource "google_storage_bucket" "landing_layer" {
  name = "champredict-landing-layer"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "transformed_layer" {
  name = "champredict-transformed-layer"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "airbyte_bucket" {
  name          = "champredict-airbyte-bucket"
  location      = var.bucket_region
  project       = var.project
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "airbyte_bucket_access" {
  bucket = google_storage_bucket.airbyte_bucket.name
  role   = var.airbyte_bucket_role
  member = "serviceAccount:${google_service_account.airbyte_service_account.email}"
}