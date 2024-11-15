output "airbyte_service_account_email" {
  value = google_service_account.airbyte_service_account.email
}

output "workload_identity_gke_service_account" {
  value = google_service_account.workload_identity_gke_service_account
}

output "workload_identity_gke_service_account_email" {
  value = google_service_account.workload_identity_gke_service_account.email
}