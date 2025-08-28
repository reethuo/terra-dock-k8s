# Fetch GKE Cluster Details
data "google_container_cluster" "gke_cluster" {
  name       = google_container_cluster.primary.name
  location   = var.region
}

# Add the Harness delegate module
module "delegate" {
  source           = "harness/harness-delegate/kubernetes"
  version          = "0.2.3"
  account_id       = "ucHySz2jQKKWQweZdXyCog"
  delegate_token   = "NTRhYTY0Mjg3NThkNjBiNjMzNzhjOGQyNjEwOTQyZjY="
  delegate_name    = "terraform-delegate-reethu"
  deploy_mode      = "KUBERNETES"
  namespace        = "harness-delegate-ng"
  manager_endpoint = "https://app.harness.io"
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.08.86503"
  replicas         = 1
  upgrader_enabled = true
  depends_on       = [google_container_cluster.primary]
}
