resource "google_project_service" "enable_gke" { 
    service = "container.googleapis.com"
}

resource "google_container_cluster" "gke_orchestration_ingestion_cluster" {
  name     = "orchestration-ingestion"
  location = var.cluster_zone
  enable_autopilot = true
  node_config {
    spot = true
  }

  depends_on = [google_project_service.enable_gke]
}