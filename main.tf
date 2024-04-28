provider "google" {
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

resource "google_container_cluster" "gbot" {
  name                     = var.CLUSTER_NAME
  location                 = var.GOOGLE_REGION
  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = 1
}

resource "google_container_node_pool" "main" {
  name     = "main"
  project  = google_container_cluster.gbot.project
  cluster  = google_container_cluster.gbot.name
  location = google_container_cluster.gbot.location

  node_count = var.GKE_NUM_NODES

  node_config {
    machine_type = var.GKE_MACHINE_TYPE
  }
}

module "gke_auth" {
  depends_on = [
    google_container_cluster.this
  ]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = var.GOOGLE_PROJECT
  cluster_name         = google_container_cluster.this.name
  location             = var.GOOGLE_REGION
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
  file_permission = "0400"
}
