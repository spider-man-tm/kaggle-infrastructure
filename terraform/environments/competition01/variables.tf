# General
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

# GCE
variable "zone" {
  description = "GCE Zone"
  type        = string
}

variable "instance_name" {
  description = "Instance and IP address Name"
  type        = string
}

variable "machine_type" {
  description = "Machine Type"
  type        = string
}

variable "image" {
  description = "Machine Image"
  type        = string
}

variable "pub_key_path" {
  description = "Public Key Path(local PC)"
  type        = string
}

variable "network_name" {
  description = "VPC Network name"
  type        = string
  default     = "default"
}

variable "github_email" {
  description = "GitHub Email"
  type        = string
}

variable "github_user_name" {
  description = "GitHub Username"
  type        = string
}

variable "kaggle_username" {
  description = "Kaggle Username"
  type        = string
}

# GCE & Network
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

# Network
variable "static_ip_name" {
  description = "Static IP Name"
  type        = string
}

# GCS
variable "bucket_name" {
  description = "GCS Bucket Name"
  type        = string
}

variable "location" {
  description = "GCS Location"
  type        = string
}
