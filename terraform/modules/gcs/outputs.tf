output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.default.name
}
