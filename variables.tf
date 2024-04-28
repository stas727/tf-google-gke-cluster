variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project name"
}

variable "GKE_NUM_NODES" {
  type        = number
  default     = 2
  description = "GKE nodes number"
}

variable "GKE_MACHINE_TYPE" {
  type        = string
  default     = "g1-small"
  description = "machine type"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1-c"
  description = "GCP project region"
}

variable "CLUSTER_NAME" {
  type        = string
  default     = "gbot"
  description = "Cluster name"
}