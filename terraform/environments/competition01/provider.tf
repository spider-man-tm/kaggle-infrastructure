provider "google" {
  credentials = file("../../credential/terraform-key.json")
  project     = var.project_id
  region      = var.region
}
