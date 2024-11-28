# Kaggle Infrastructure

[English](../README.md) | [日本語](README.ja.md)

Document: [Blog](https://zenn.dev/takayoshi/articles/002-kaggle-iac)

<br />

## Setup GCP Project

1. 事前に gcloud CLI を使えるようにしておきます。
   参考：[gcloud CLI をインストールする](https://cloud.google.com/sdk/docs/install?hl=ja)[Google Cloud 公式]

2. 以下のコマンドを実行します。

```shell
cd setup-gcp-project
make setup-gcp-project \
    GCP_PROJECT_ID=<your_gcp_project_id> \
    BILLING_ACCOUNT_ID=<your_billing_account_id> \
    KAGGLE_KEY=<your_kaggle_api_key>
```

Biiling Account ID がわからない場合は、以下のコマンドを実行して確認できます。

```shell
gcloud billing accounts list
```

<br />

## Terraform

1. `terraform/environments/competition01/terraform.tfvars` ファイルを作成し、各種変数をお好みで設定してください。（下記はサンプルです。適宜変更してください。）

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

`competition01`と同じ階層に自由にディレクトリを作成しそれぞれ別の変数を定義することで、複数コンペティションのリソースを同時に管理することが可能です。

2. 以下のコマンドを実行します。

```shell
cd terraform/environments/competition01
terraform init
terraform plan
terraform apply

# If you want to destroy the resources
terraform destroy
```

3. 完了すると、作成されたインスタンスの外部 IP アドレスが表示されるので、SSH でログインしてください。

```shell
# 秘密鍵のパスは、terraform.tfvars で指定した公開鍵とセットになるものを使用してください。
ssh -i ~/.ssh/id_ed25519 ubuntu@<外部IPアドレス>
```

ローカルの`~/.ssh/config`に以下のような設定を追加すると、`ssh kaggle`で GCE にログインできるようになります。また VSCode の Remote SSH でも使用できるようになります。

```shell
Host kaggle-titanic
  HostName <外部IPアドレス>
  User ubuntu
  Port 22
  IdentityFile ${HOME}/.ssh/id_ed25519
```

<br />

## Docker

1. このリポジトリをクローンします。
2. 既に Docker, Docker Compose がインストールされているので、以下のコマンドを実行して Kaggle コンテナを起動します。

```shell
cd docker
docker-compose up -d
```

3. VSCode から Kaggle コンテナに接続すると、Python スクリプトの実行や Jupyter Notebook の使用が可能です。
