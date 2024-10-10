resource "google_project_service" "enable_gke" { 
  service = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "gke_f1toolbox_core_cluster" {
  name     = "f1toolbox-core"
  location = var.cluster_zone
  enable_autopilot = true

  depends_on = [google_project_service.enable_gke]
}