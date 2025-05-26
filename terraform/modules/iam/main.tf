#####################################################
# for Comepetitions Storatge
#####################################################
resource "google_service_account" "instance_service_account" {
  account_id   = "instance-service-account"
  display_name = "Instance Service Account"
}

# Allow instance to access storage
resource "google_project_iam_member" "storage_access" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.instance_service_account.email}"
}

#####################################################
# for Digger
#####################################################
resource "google_service_account" "digger_service_account" {
  account_id   = "digger-service-account"
  display_name = "Digger Service Account"
}

resource "google_project_iam_member" "digger_sa_project_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.digger_service_account.email}"
}

resource "google_iam_workload_identity_pool" "gha_pool" {
  workload_identity_pool_id = "gha-pool-kaggle-digger"
  display_name              = "GHA Workload Identity Pool"
  description               = "Workload Identity Pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "gha_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.gha_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gha-provider-kaggle-digger"
  display_name                       = "GHA Provider"
  description                        = "Provider for GitHub Actions"

  oidc { issuer_uri = "https://token.actions.githubusercontent.com" }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == \"${var.github_user_name}/${var.github_repo_name}\""
}

resource "google_service_account_iam_member" "digger_sa_wif_user" {
  service_account_id = google_service_account.digger_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gha_pool.name}/attribute.repository/${var.github_user_name}/${var.github_repo_name}"
}
