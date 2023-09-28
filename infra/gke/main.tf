resource "google_project_service" "enable_gke" { 
    service = "container.googleapis.com"
}

resource "google_container_cluster" "gke_orchestration_ingestion_cluster" {
  name     = "orchestration_ingestion"
  location = var.cluster_zone
  enable_autopilot = true
  spot = true
}

provider "helm" {
    kubernetes { }
}

resource "helm_release" "airbyte" {
    name = "airbyte"
    repository = "https://airbytehq.github.io/helm-charts"
    chart = "airbyte"
    version = "0.49.1"
}

#Add the Dagster installation here as well