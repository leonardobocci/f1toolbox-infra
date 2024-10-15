#https://registry.terraform.io/providers/hashicorp/google/6.7.0/docs/resources/container_cluster

resource "google_project_service" "enable_gke" { 
  service = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "primary" {
  name     = "f1toolbox-core-cluster"
  location = var.cluster_zone

  # Node pool below - remove default one
  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "f1toolbox-core-node-pool"
  location   = var.cluster_zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 45

    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}