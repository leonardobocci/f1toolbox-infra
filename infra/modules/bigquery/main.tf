resource "google_project_service" "enable_iam" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "f1toolbox_core_dataset" {
  dataset_id                 = "f1toolbox_core"
  friendly_name              = "f1toolbox"
  description                = "Core data for f1 toolbox"
  location                   = var.bigquery_location
  delete_contents_on_destroy = true

  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }
  #required explicit owner
  access {
    role          = "OWNER"
    user_by_email = var.terraform_service_account_email
  }
  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }
  access {
    role          = "READER"
    special_group = "projectReaders"
  }
}

resource "google_project_iam_member" "bigquery_airbyte_data_editor" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"
}

resource "google_project_iam_member" "bigquery_airbyte_user" {
  project = var.project
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"
}

resource "google_project_iam_member" "bigquery_dagster_dbt_data_editor" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.workload_identity_gke_service_account_email}"
}

resource "google_project_iam_member" "bigquery_dagster_dbt_user" {
  project = var.project
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${var.workload_identity_gke_service_account_email}"
}

resource "google_project_iam_member" "bigquery_metabase_data_viewer" {
  project = var.project
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${var.metabase_auth_service_account_email}"
}

resource "google_project_iam_member" "bigquery_metabase_metadata_viewer" {
  project = var.project
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${var.metabase_auth_service_account_email}"
}

resource "google_project_iam_member" "bigquery_metabase_job_user" {
  project = var.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.metabase_auth_service_account_email}"
}