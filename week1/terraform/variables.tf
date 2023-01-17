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

variable "storage_class" {
    description = "Storage class type for the bucket in GCS" 
    default = "STANDARD" 
}

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