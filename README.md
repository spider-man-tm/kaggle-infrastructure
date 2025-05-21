# Kaggle Infrastructure

[English](README.md) | [日本語](docs/README.ja.md)

<br />

## Setup GCP Project

1. Prepare to use the gcloud CLI in advance.
   Reference: [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install?hl=ja) [Google Cloud Official]

2. Run the following commands:

```shell
cd setup-gcp-project
make setup-gcp-project \
    GCP_PROJECT_ID=<your_gcp_project_id> \
    BILLING_ACCOUNT_ID=<your_billing_account_id> \
    KAGGLE_KEY=<your_kaggle_api_key> \
    TF_STATE_BUCKET_NAME=<your_tf_state_bucket_name>
```

If you don't know your Billing Account ID, you can check it by running the following command:

```shell
gcloud billing accounts list
```

<br />

## Terraform

1. Create the `terraform/environments/competition01/terraform.tfvars` file and set various variables as you like. (The following is a sample. Please change it as needed.)

```hcl
# General
project_id = "kaggle-infra"
region     = "asia-northeast1"

# GCE
zone             = "asia-northeast1-c"
instance_name    = "titanic-instance"
machine_type     = "e2-micro"
image            = "ubuntu-os-cloud/ubuntu-2004-lts"
pub_key_path     = "~/.ssh/id_ed25519.pub" # Key path used for SSH login (local PC)
network_name     = "default"
github_email     = "xyz@gmail.com"
github_user_name = "Your GitHub Username"
kaggle_username  = "spidermandance" # Your Kaggle username

# GCE & Network
instance_count = 1

# Network
static_ip_name = "titanic-static-ip"

# GCS
bucket_name = "titanic-bucket-xyz" # GCS bucket name
location    = "ASIA"               # GCS region
```

It is possible to manage resources for multiple competitions simultaneously by freely creating directories at the same level as `competition01` and defining separate variables for each directory.

2. Update the `terraform/environments/competition01/terraform.tf` file to change the tfstate file storage location to the GCS bucket created with the `make` command above. Change the prefix as needed.

```hcl
terraform {
  required_version = ">= 1.6"

  backend "gcs" {
    bucket = "tf-state-bucket-name-titanic"  # <- GCS Bucket name
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}
```

3. Run the following commands:

```shell
cd terraform/environments/competition01
terraform init
terraform plan
terraform apply

# If you want to destroy the resources
terraform destroy
```

4. Upon completion, the external IP address of the created instance will be displayed, so log in via SSH.

```shell
# Use the private key that matches the public key specified in terraform.tfvars.
ssh -i ~/.ssh/id_ed25519 ubuntu@<External IP Address>
```

By adding the following settings to your local `~/.ssh/config`, you can log into GCE with `ssh kaggle-titanic`. This also enables usage with VSCode's Remote SSH.

```shell
Host kaggle-titanic
  HostName <External IP Address>
  User ubuntu
  Port 22
  IdentityFile ${HOME}/.ssh/id_ed25519
```

<br />

## Docker

1. Clone this repository.
2. Since Docker and Docker Compose are already installed, run the following commands to start the Kaggle container:

```shell
cd docker
docker-compose up -d
```

3. Once connected to the Kaggle container from VSCode, you can execute Python scripts and use Jupyter Notebook.
