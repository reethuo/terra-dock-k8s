terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    # Add the utils provider here
    utils = {
      source = "cloudposse/utils"
      version = "~> 1.2" # Use a compatible version
    }
    # Add the time provider here
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9" # Use a compatible version
    }
  }
}

provider "google" {
  zone = var.region
  project = "ritu-pro"
}

resource "google_container_cluster" "primary" {
  name        = var.cluster_name
  location    = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 20
  }

  remove_default_node_pool = false
}
