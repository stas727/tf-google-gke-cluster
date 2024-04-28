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

resource "google_compute_instance" "my_instance" {
  zone = "us-central1-a"
  name = "test"

  machine_type = "n1-standard-16" # <<<<<<<<<< Try changing this to n1-standard-32 to compare the costs
  network_interface {
    network = "default"
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scheduling {
    preemptible = true
  }

  guest_accelerator {
    type = "nvidia-tesla-t4" # <<<<<<<<<< Try changing this to nvidia-tesla-p4 to compare the costs
    count = 4
  }

  labels = {
    environment = "production"
    service = "web-app"
  }
}

resource "google_cloudfunctions_function" "my_function" {
  runtime = "nodejs20"
  name = "test"
  available_memory_mb = 512

  labels = {
    environment = "Prod"
  }
}