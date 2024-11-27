provider "google" {
  credentials = file("../../credential/terraform-key.json")
  project     = var.project_id
  region      = var.region
}

# Get the value from secret manager
data "google_secret_manager_secret_version" "kaggle_key" {
  secret  = "kaggle-key"
  version = "latest"
}

module "gce" {
  source                         = "../../modules/gce"
  zone                           = var.zone
  instance_name                  = var.instance_name
  instance_count                 = var.instance_count
  machine_type                   = var.machine_type
  image                          = var.image
  pub_key_path                   = var.pub_key_path
  network_name                   = var.network_name
  static_ip_addresses            = module.network.static_ip_addresses
  instance_service_account_email = module.iam.instance_service_account_email
  github_email                   = var.github_email
  github_user_name               = var.github_user_name
  kaggle_username                = var.kaggle_username
  kaggle_key                     = data.google_secret_manager_secret_version.kaggle_key.secret_data
}

module "network" {
  source         = "../../modules/network"
  region         = var.region
  instance_count = var.instance_count
  static_ip_name = var.static_ip_name
}

module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
}

module "gcs" {
  source      = "../../modules/gcs"
  bucket_name = var.bucket_name
  location    = var.location
}
