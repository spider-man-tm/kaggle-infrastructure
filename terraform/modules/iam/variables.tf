variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "digger_lock_bucket_name" {
  description = "GCS Bucket Name for Digger Lock"
  type        = string
}

variable "github_user_name" {
  description = "GitHub User Name"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub Repository Name"
  type        = string
}
