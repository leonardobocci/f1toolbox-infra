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
}

resource "helm_release" "dagster" {
  name       = "dagster"
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  version    = "1.4.16"
}