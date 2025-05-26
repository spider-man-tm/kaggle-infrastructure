terraform {
  required_version = ">= 1.6"

  backend "gcs" {
    bucket = "tf-state-kaggle-infra-exp-0808"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}
