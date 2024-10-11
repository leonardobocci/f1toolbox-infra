resource "google_project_service" "enable_secret_manager" { 
    service = "secretmanager.googleapis.com"
    disable_on_destroy = false
}

resource "google_project_iam_member" "secretAccessor" {
  project = var.project
  role = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"

  depends_on = [ google_project_service.enable_secret_manager ]
}

resource "google_project_iam_member" "secretVersionAdder" {
  project = var.project
  role = "roles/secretmanager.secretVersionAdder"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"

  depends_on = [ google_project_service.enable_secret_manager ]
}

resource "google_project_iam_member" "secretVersionManager" {
  project = var.project
  role = "roles/secretmanager.secretVersionManager"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"

  depends_on = [ google_project_service.enable_secret_manager ]
}

resource "google_project_iam_member" "secretViewer" {
  project = var.project
  role = "roles/secretmanager.viewer"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"

  depends_on = [ google_project_service.enable_secret_manager ]
}