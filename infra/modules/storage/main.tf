resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
}

resource "google_storage_bucket" "landing_layer" {
  name = "landing-layer"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "transformed_layer" {
  name = "transformed-layer"
  location = var.bucket_region
  force_destroy = true

  depends_on = [ google_storage_bucket.landing_bucket ]
}