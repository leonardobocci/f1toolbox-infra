resource "google_project_service" "enable_iam" {
  service = "bigquery.googleapis.com"
  disable_on_destroy = false
}

data "google_iam_policy" "bigquery_admins" {
  binding {
    role = "roles/bigquery.admin"
    members = [
      "serviceAccount:${var.airbyte_auth_service_account_email}", "serviceAccount:${var.terraform_service_account_email}", "user:${var.project_user_gmail}"
    ]
  }
}

resource "google_bigquery_dataset_iam_policy" "dataset" {
  dataset_id  = google_bigquery_dataset.f1toolbox_core_dataset.dataset_id
  policy_data = data.google_iam_policy.bigquery_admins.policy_data
}

resource "google_bigquery_dataset" "f1toolbox_core_dataset" {
  dataset_id                  = "f1toolbox_core"
  friendly_name               = "f1toolbox"
  description                 = "Core data for f1 toolbox"
  location                    = var.bigquery_location
  delete_contents_on_destroy = true

  access {
    role = "WRITER"
    special_group = "projectWriters"
  }
  #required explicit owner
  access {
    role = "OWNER"
    user_by_email = var.terraform_service_account_email
  }
  access {
    role = "OWNER"
    special_group = "projectOwners"
  }
  access {
    role = "READER"
    special_group = "projectReaders"
  }
}