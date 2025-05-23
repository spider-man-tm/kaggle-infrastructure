output "digger_lock_bucket_name" {
  description = "Name of the created GCS bucket for Digger lock"
  value       = google_storage_bucket.digger_lock.name
}

output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.default.name
}
