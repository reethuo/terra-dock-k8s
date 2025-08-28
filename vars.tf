variable "cluster_name" {
    default = "cluster"
  
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
  default     = "e2-small"  // Adjust based on the required machine type
}
