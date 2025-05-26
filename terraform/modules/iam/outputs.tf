output "instance_service_account_email" {
  description = "Email address of the service account created for instance access."
  value       = google_service_account.instance_service_account.email
}

output "digger_service_account_email" {
  description = "Email address of the service account created for Digger access."
  value       = google_service_account.digger_service_account.email
}
