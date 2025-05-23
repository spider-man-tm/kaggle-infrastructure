variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "tf_state_bucket_name" {
  description = "GCS Bucket Name for Terraform State"
  type        = string
}

variable "digger_bucket_name" {
  description = "GCS Bucket Name for Digger"
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
