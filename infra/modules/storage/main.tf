resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
}

resource "google_storage_bucket" "landing_bucket" {
  name = "bronze-landing-zone"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "transformed_bucket" {
  name = "silver-transformed-zone"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_storage_bucket.bronze_bucket ]
}