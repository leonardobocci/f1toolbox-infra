resource "google_project_service" "enable_gke" { 
  service = "container.googleapis.com"
  disable_on_destroy = false
}

