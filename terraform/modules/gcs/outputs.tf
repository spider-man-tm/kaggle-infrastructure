output "digger_bucket_name" {
  description = "Name of the created GCS bucket for Digger"
  value       = google_storage_bucket.digger_bucket.name
}

output "competition_bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.competition_bucket.name
}
