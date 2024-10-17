resource "google_project_service" "enable_storage" { 
    service = "storage-api.googleapis.com"
    disable_on_destroy = false
}

resource "google_storage_bucket" "airbyte_state_bucket" {
  name = "airbyte-state-bucket"
  location = var.bucket_region
  project       = var.project
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "landing_files_layer" {
  name = "f1toolbox-landing-bucket"
  location = var.bucket_region
  project       = var.project
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

resource "google_storage_bucket" "bronze_files_layer" {
  name = "f1toolbox-bronze-bucket"
  location = var.bucket_region
  project       = var.project
  force_destroy = true

  depends_on = [ google_project_service.enable_storage ]
}

data "google_iam_policy" "bucket_admins" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${var.airbyte_auth_service_account_email}", "serviceAccount:${var.terraform_service_account_email}", "serviceAccount:${var.workload_identity_gke_service_account_email}", "user:${var.project_user_gmail}"
    ]
  }
  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${var.airbyte_auth_service_account_email}", "serviceAccount:${var.terraform_service_account_email}", "serviceAccount:${var.workload_identity_gke_service_account_email}", "user:${var.project_user_gmail}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "airbyte_state_bucket_admin" {
  bucket = google_storage_bucket.airbyte_state_bucket.name
  policy_data = data.google_iam_policy.bucket_admins.policy_data

  depends_on = [ google_storage_bucket.airbyte_state_bucket ]
}

resource "google_storage_bucket_iam_policy" "landing_files_bucket_admin" {
  bucket = google_storage_bucket.landing_files_layer.name
  policy_data = data.google_iam_policy.bucket_admins.policy_data

  depends_on = [ google_storage_bucket.landing_files_layer ]
}

resource "google_storage_bucket_iam_policy" "bronze_files_bucket_admin" {
  bucket = google_storage_bucket.bronze_files_layer.name
  policy_data = data.google_iam_policy.bucket_admins.policy_data

  depends_on = [ google_storage_bucket.bronze_files_layer ]
}