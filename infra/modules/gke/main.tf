#https://registry.terraform.io/providers/hashicorp/google/6.7.0/docs/resources/container_cluster

data "google_client_config" "current" {}

resource "google_project_service" "enable_gke" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "primary" {
  name     = "f1toolbox-core-cluster"
  location = var.cluster_zone

  # Node pool below - default one gets removed at startup
  remove_default_node_pool = true
  initial_node_count       = 1

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 4
      maximum       = 24
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 16
      maximum       = 96
    }
    auto_provisioning_locations = [var.cluster_zone]
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  workload_identity_config {
    workload_pool = "${data.google_client_config.current.project}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "f1toolbox-core-node-pool"
  location = var.cluster_zone
  cluster  = google_container_cluster.primary.name

  node_config {
    spot         = true
    machine_type = "c3-standard-4"
    disk_size_gb = 35

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}