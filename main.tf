terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"  # Updated Google provider to a newer, compatible version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22" # Updated Kubernetes provider to a newer, compatible version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11" # Updated Helm provider to a newer, compatible version
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

provider "google" {
  project = "ritu-pro"
  region  = "us-central1"
  zone    = "us-central1-c"
}

data "google_client_config" "default" {}

resource "google_container_cluster" "cluster" {
  name        = "cluster"
  location    = "us-central1-c"

  release_channel {
    channel = "REGULAR"
  }

  initial_node_count = 2

  node_config {
    machine_type = "e2-micro"
    image_type   = "centos-stream-9"
    disk_size_gb = 20
  }
}

resource "time_sleep" "wait_for_gke_cluster" {
  create_duration = "120s"
  depends_on = [google_container_cluster.cluster]
}

module "delegate" {
  source = "harness/harness-delegate/kubernetes"
  version = "0.2.3"

  account_id = "ucHySz2jQKKWQweZdXyCog"
  delegate_token = "NTRhYTY0Mjg3NThkNjBiNjMzNzhjOGQyNjEwOTQyZjY="
  delegate_name = "terraform-delegate-reethu"
  deploy_mode = "KUBERNETES"
  namespace = "harness-delegate-ng"
  manager_endpoint = "https://app.harness.io"
  delegate_image = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.08.86503"
  replicas = 1
  upgrader_enabled = true
  depends_on = [
    time_sleep.wait_for_gke_cluster
  ]
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
