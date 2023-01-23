locals {
    data_lake_bucket = "dtc_data_lake"
} 

variable "project" {
    type = string 
    description = "Your GCP Project ID."
}

variable "region" {
    type = string 
    default = "us-central1" 
    description = "Region for GCP resources." 
}

variable "zone" {
    type = string
    default = "us-central1-a"
    description = "Zone for GCP resources."
}

## GCS variables
variable "storage_class" {
    description = "Storage class type for the bucket in GCS" 
    default = "STANDARD" 
}


## BigQuery ariables
variable "BG_DATASET" {
    description = "Raw dataset (from GCS) that will be written into BigQuery"
    type = string
    default = "trips_data_all"
}

variable "TABLE_NAME" {
    default = "ny_trips"
    type = string
    description = "BigQuery table"
}

## compute variables
variable "compute_name" {
    default = "de-zoomcamp"
    type = string
    description = "Name of the Compute Instance"
}

variable "compute_machine" {
    default = "e2-micro"
    type = string
    description = "Machine for the Compute Instance"
}

variable "ubuntu_2004_sku" {
  type        = string
  description = "SKU for Ubuntu 20.04 LTS"
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "compute_disk_size" {
    default = 30
    description = "Disk size for the Compute Instance"
}

variable "compute_static_ip" {
    default = "static-ip"
    type = string
    description = "Name of GCP Cloud Address instance"
}