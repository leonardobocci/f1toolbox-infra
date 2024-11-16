resource "google_project_service" "enable_iam" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "f1toolbox_core_bronze_dataset" {
  dataset_id                 = "f1toolbox_core_bronze"
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

resource "google_bigquery_dataset" "f1toolbox_core_silver_dataset" {
  dataset_id                 = "f1toolbox_core_silver"
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

resource "google_bigquery_dataset" "f1toolbox_core_gold_dataset" {
  dataset_id                 = "f1toolbox_core_gold"
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

resource "google_bigquery_dataset" "f1toolbox_core_marts_dataset" {
  dataset_id                 = "f1toolbox_core_marts"
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