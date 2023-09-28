resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
}

resource "google_storage_bucket" "bronze_bucket" {
  name = "bronze-landing-zone"
  location = var.bucket_region
  force_destroy = true
}

#ADD SILVER AND GOLD BUCKETS HERE