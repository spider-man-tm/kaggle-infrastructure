# Purpose: Create a service account and grant it the necessary permissions to access Google Cloud Storage.
resource "google_service_account" "instance_service_account" {
  account_id   = "instance-service-account"
  display_name = "Instance Service Account"
}

# Grant the service account the necessary permissions to access Google Cloud Storage.
resource "google_project_iam_member" "storage_access" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.instance_service_account.email}"
}
