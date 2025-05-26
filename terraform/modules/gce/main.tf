resource "google_compute_instance" "competition_instance" {
  count        = var.instance_count
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  # exp. Ubuntu 20.04 LTS image
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  # Creating a static IP address
  network_interface {
    network = var.network_name

    access_config {
      nat_ip = var.static_ip_addresses[count.index]
    }
  }

  # You can access the instance using local ssh-keys
  metadata = {
    ssh-keys = "ubuntu:${file(var.pub_key_path)}"
  }

  # This service account is used to access GCS bucket
  service_account {
    email  = var.instance_service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  # This file is used to install docker and git, and to create kaggle.json file in the instance.
  metadata_startup_script = templatefile("${path.module}/startup-script.sh.tpl", {
    github_email     = var.github_email,
    github_user_name = var.github_user_name,
    kaggle_json = jsonencode({
      username = var.kaggle_username,
      key      = var.kaggle_key
    })
  })
}
