terraform {
  required_providers {
    null = {
      source  = "hashicorp/null" 
      version = "~> 3.2" #ensures that Terraform uses version ~> 3.2
    }
  }
}
provider "google" {
  project = "ritu-pro"
  region  = "us-central1"
  zone    = "us-central1-c"
}

data "google_client_config" "default" {} #✅ Purpose
#This is a Terraform data source from the google provider that fetches information about the currently authenticated Google Cloud client used by Terraform. It's especially useful when you need details like:
#Project,Region/Zone,Access token and Account being used
#This is useful in dynamic environments where you want Terraform to adapt to the current GCP configuration((for example, based on gcloud auth login).

resource "google_container_cluster" "cluster" {
  name     = "cluster"
  location = "us-central1-c"

  release_channel {      #🎯 Purpose
    channel = "REGULAR"  #release_channel block tells GKE how often your cluster should get Kubernetes and node updates.
  }                      #Choosing REGULAR helps you stay reasonably up-to-date without risking the instability of very new versions.

  initial_node_count = 2

  node_config {
    machine_type = "e2-micro"
    image_type   = "centos-stream-9" #COS stands for Container-Optimized OS, a lightweight, secure OS maintained by Google, specifically designed for running containers.
    disk_size_gb = 20 #CONTAINERD indicates that the node will use containerd as the container runtime (instead of the older docker runtime).
  }
deletion_protection=false
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
}


provider "kubernetes" { #This Terraform block defines the Kubernetes provider configuration and enables Terraform to interact with your Google Kubernetes Engine (GKE) cluster. 
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" { #It allows Terraform to run Helm commands (like installing charts) against your Kubernetes cluster, by setting up authentication and cluster access.
  kubernetes {
    host                   = "https://${google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

