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

/*
data "google_container_cluster" "cluster_info" {
  name     = google_container_cluster.gke_orchestration_ingestion_cluster.name
  project  = var.project
  location = var.cluster_zone
}
*/

resource "null_resource" "deploy_helmfile" {
  /*
  triggers = {
    # This trigger ensures that the Helmfile deployment only happens after the GKE Autopilot cluster is ready.
    cluster_ready = data.google_container_cluster.cluster_info.default_node_pool != null
  }
  */

  # Execute the Helmfile deployment when the trigger condition is met.
  provisioner "local-exec" {
    command = "helmfile -e production -f ./charts/helmfile.yaml apply"
  }

  depends_on = [google_container_cluster.gke_orchestration_ingestion_cluster]
}