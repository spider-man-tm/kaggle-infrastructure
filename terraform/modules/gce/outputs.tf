output "instance_names" {
  description = "Names of the created instances"
  value       = google_compute_instance.competition_instance[*].name
}
