terraform {
  required_version = ">= 1.0"
  backend "local" {}
  required_providers {
    google = {
        source = "hashicorp/google"
    }
  }
}

provider "google" {
    project = var.project
    region = var.region
}

resource "google_storage_bucket" "data-lake-bucket" {
    name = "${local.data_lake_bucket}_${var.project}"
    location = var.region
    storage_class = var.storage_class

    uniform_bucket_level_access = true

    versioning {
        enabled = true
    }

    lifecycle_rule {
        action {
            type = "Delete"
        }
        condition {
            age = 30 // days
        }
    }

    force_destroy = true
}

resource "google_bigquery_dataset" "dataset" {
    dataset_id = var.BG_DATASET
    project = var.project
    location = var.region
}

resource "google_compute_address" "static_ip" {
    name = var.compute_static_ip
}

resource "google_compute_instance" "compute_instance" {
    name = var.compute_name
    machine_type = var.compute_machine
    zone = var.zone

    allow_stopping_for_update = true

    boot_disk {
        initialize_params {
            image = var.ubuntu_2004_sku
            size = 30
        }
    }

    network_interface {
        network = "default"
        access_config { 
            nat_ip = "${google_compute_address.static_ip.address}"
        } ## needed to enable external IP
    }

    service_account {
        scopes = ["cloud-platform"]
    }

    metadata = {
        "ssh-keys" = <<EOT
            igoryamamoto:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcWYQTVpMHA6Mjn3MxnhyE+2tYDH72CWELj2BWvL1jGxRG9x/H/Gi4qzpBcVQOLsoFYCfWrk+fgAHGn55B8tb2nv/W7qN0yNEHcLVXz5o3OhiM/fjgQwG0eRVb9GttSzR1knyKEqkUHFcxXmKemqml88XzsTZ4PUkQc2QW0CK/UPWD/FOcA2y2PZmbQZfcg6gDh2gH76itXZ2QR2Cuy1feUTmNI/bG0djIF9QKeDPgM0lpqvaqIK1d+o1CgMwAmHdsxiVJ434THNmo6aevJdBtC0tOv+RSvtm6KW5J1WuBM9Zd9A0TQjmxrBWcW+1MmJUY2yCz45fL402s+FdotV/j igoryamamoto
        EOT
  }
}