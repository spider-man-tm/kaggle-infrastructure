terraform {
  required_version = ">= 1.6"

  backend "gcs" {
    bucket = "tf-state-bucket-titanic"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}
