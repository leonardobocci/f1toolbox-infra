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

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.gke_orchestration_ingestion_cluster.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.gke_orchestration_ingestion_cluster.master_auth[0].cluster_ca_certificate)
    client_certificate     = base64decode(google_container_cluster.gke_orchestration_ingestion_cluster.master_auth[0].client_certificate)
    client_key             = base64decode(google_container_cluster.gke_orchestration_ingestion_cluster.master_auth[0].client_key)
  }
}

resource "helm_release" "airbyte" {
  name       = "airbyte"
  repository = "https://airbytehq.github.io/helm-charts"
  chart      = "airbyte"
  version    = "0.49.1"

  depends_on = [ google_container_cluster.gke_orchestration_ingestion_cluster ]
}

resource "helm_release" "dagster" {
  name       = "dagster"
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  version    = "1.4.16"

  depends_on = [ helm_release.airbyte ]
}