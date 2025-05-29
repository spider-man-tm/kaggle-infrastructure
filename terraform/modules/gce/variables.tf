variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "instance_name" {
  description = "Instance and IP address Name"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine Type"
  type        = string
}

variable "image" {
  description = "Machine Image"
  type        = string
}

variable "network_name" {
  description = "VPC Network name"
  type        = string
}

variable "static_ip_addresses" {
  description = "Static IP addresses"
  type        = list(string)
}

variable "instance_service_account_email" {
  description = "Service Account Email"
  type        = string
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

variable "kaggle_key" {
  description = "Kaggle API Key"
  type        = string
  sensitive   = true
}
