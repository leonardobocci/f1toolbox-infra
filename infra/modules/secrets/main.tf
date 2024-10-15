resource "google_project_service" "enable_secret_manager" { 
    service = "secretmanager.googleapis.com"
    disable_on_destroy = false
}

resource "google_project_iam_member" "secretAdmin" {
  project = var.project
  role = "roles/secretmanager.admin"
  member  = "serviceAccount:${var.airbyte_auth_service_account_email}"

  depends_on = [ google_project_service.enable_secret_manager ]
}