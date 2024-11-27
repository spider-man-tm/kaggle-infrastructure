variable "region" {
  description = "GCP Region"
  type        = string
}

variable "static_ip_name" {
  description = "Static IP Name"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}
