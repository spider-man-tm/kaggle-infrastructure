resource "google_storage_bucket" "default" {
  name     = var.bucket_name
  location = var.location

  storage_class = "STANDARD" // This is the default value
  force_destroy = true       // This is to delete the bucket even if it is not empty

  uniform_bucket_level_access = true

  # Enable versioning
  versioning {
    enabled = true
  }

  # Set a lifecycle rule to delete objects older than 365 days
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}
