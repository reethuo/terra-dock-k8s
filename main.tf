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

variable "cluster_name" {
    default = "cluster-2"
}
variable "region" {
    default = "us-central1-c"
}
variable "node_count" {
    default = "2"
}

variable "node_machine_type" {
  description = "The type of machine to use for nodes in the Kubernetes cluster"
  type        = string
  default     = "e2-standard-4"
}
