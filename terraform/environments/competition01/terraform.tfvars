project_id = "kaggle-infra-exp18"
region     = "asia-northeast1"

# GCE
zone             = "asia-northeast1-c"
instance_name    = "titanic-instance"
machine_type     = "e2-micro"
image            = "ubuntu-os-cloud/ubuntu-2004-lts"
pub_key_path     = "~/.ssh/id_ed25519.pub" # Key path used for SSH login (local PC)
network_name     = "default"
github_email     = "makabe.takayoshi1117@gmail.com"
github_user_name = "spider-man-tm"
kaggle_username  = "spidermandance" # Your Kaggle username

# GCE & Network
instance_count = 1

# Network
static_ip_name = "titanic-static-ip"

# GCS
tf_state_bucket_name = "tf-state-bucket-titanic"   # GCS bucket name for Terraform state
digger_bucket_name   = "titanic-digger-bucket-xyz" # GCS bucket name for Digger
bucket_name          = "titanic-bucket-xyz"        # GCS bucket name
location             = "ASIA"                      # GCS region

# Github Actions
github_repo_name = "kaggle-infrastructure"
