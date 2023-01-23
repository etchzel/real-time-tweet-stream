variable "project" {
  description = "GCP Project ID"
  default     = "data-engineering-368812"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number"
  default     = "363736832367"
  type        = string
}

variable "region" {
  description = "Project Region"
  default     = "us-west1"
  type        = string
}

variable "zone" {
  description = "Project Zone"
  default     = "us-west1-b"
  type        = string
}

variable "vm_image" {
  description = "VM OS Image"
  default     = "debian-cloud/debian-11"
  type        = string
}

variable "vm_machine_type" {
  description = "Instance type for the VM"
  default     = "e2-standard-2"
  type        = string
}

variable "network" {
  description = "Network for the instance"
  default     = "default"
  type        = string
}